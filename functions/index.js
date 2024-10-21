const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const firestore = admin.firestore();
const FieldValue = admin.firestore.FieldValue;

exports.sendUserNotification = functions.firestore
  .document('userNotifications/{userId}/notifications/{notificationId}')
  .onCreate(async (snapshot, context) => {
    const notificationData = snapshot.data();
    const userId = context.params.userId;

    // Fetch the user's FCM token from userDetails collection
    const userDetailsRef = admin.firestore().collection('userDetails').doc(userId);
    const userDetailsSnapshot = await userDetailsRef.get();

    if (!userDetailsSnapshot.exists) {
      console.error('User not found:', userId);
      return;
    }

    const fcmToken = userDetailsSnapshot.data().fcmToken;

    if (!fcmToken) {
      console.error('FCM token not found for user:', userId);
      return;
    }

    // Construct the notification message
    const message = {
      token: fcmToken,
      notification: {
        title: notificationData.title,
        body: `You have a new notification: ${notificationData.notificationType}`,
      },
      data: {
        orderId: notificationData.orderId || '',
        productId: notificationData.productId || '',
        notificationType: notificationData.notificationType || '',
      }
    };

    // Send notification via Firebase Cloud Messaging
    try {
      const response = await admin.messaging().send(message);
      console.log('Successfully sent notification:', response);
    } catch (error) {
      console.error('Error sending notification:', error);

      // Handle "messaging/registration-token-not-registered" error
      if (error.code === 'messaging/registration-token-not-registered') {
        console.warn(`FCM token for user ${userId} is no longer valid. Removing token from userDetails.`);

        // Update user document to remove the invalid token
        await userDetailsRef.update({ fcmToken: admin.firestore.FieldValue.delete() });
      }
    }
  });


exports.sendChatNotification = functions.firestore
  .document('userMessages/{chatId}/messages/{messageId}')
  .onCreate(async (snapshot, context) => {
    const messageData = snapshot.data(); // Get the new message data
    const userId = messageData.userId; // Get userId from the message document
    const chatId = context.params.chatId; // Get chatId from the Firestore path

    if (!userId) {
      console.error('No userId found in message document.');
      return;
    }

    try {
      // Fetch the first document from the convo collection of this chat
      const convoSnapshot = await admin
        .firestore()
        .collection('chats')
        .doc(userId)
        .collection('convo')
        .limit(1)
        .get();

      if (convoSnapshot.empty) {
        console.error('No conversation found for user:', userId);
        return;
      }

      const convoData = convoSnapshot.docs[0].data(); // Get the first convo document

      let recipientId; // This will store the recipient's userId
      if (userId === convoData.sellerId) {
        // If the message sender is the seller, notify the buyer
        recipientId = convoData.buyerId;
      } else {
        // If the message sender is not the seller, notify the seller
        recipientId = convoData.sellerId;
      }

      if (!recipientId) {
        console.error('Recipient ID not found in conversation.');
        return;
      }

      // Fetch the FCM token of the recipient from userDetails collection
      const userDetailsRef = admin.firestore().collection('userDetails').doc(recipientId);
      const userDetailsSnapshot = await userDetailsRef.get();

      if (!userDetailsSnapshot.exists) {
        console.error('User not found:', recipientId);
        return;
      }

      const fcmToken = userDetailsSnapshot.data().fcmToken;

      if (!fcmToken) {
        console.error('FCM token not found for user:', recipientId);
        return;
      }

      // Construct the notification message
      const message = {
        token: fcmToken,
        notification: {
          title: 'New Message',
          body: messageData.message || 'You have a new message!',
        },
        data: {
          messageId: context.params.messageId,
          chatId: chatId,
          senderId: userId,
        },
      };

      // Send notification via Firebase Cloud Messaging
      const response = await admin.messaging().send(message);
      console.log('Successfully sent chat notification:', response);

    } catch (error) {
      console.error('Error processing chat notification:', error);
    }
  });

exports.sendNotificationOnOfferStatusChange = functions.firestore
    .document('orders/{orderId}')
    .onUpdate(async (change, context) => {
        const after = change.after.data();
        const before = change.before.data();

        const orderId = context.params.orderId;
        const offersAfter = after.offers;
        const offersBefore = before.offers;

        // Check if isAccepted has changed
        if (offersAfter.isAccepted !== offersBefore.isAccepted) {
            const buyerId = after.buyerId;  // Fetch buyerId from the document
            const offerPrice = offersAfter.offerPrice;  // Fetch the offer price

            let notificationTitle = '';
            let notificationBody = '';

            // Determine the type of notification based on isAccepted value
            if (offersAfter.isAccepted === 'accepted') {
                notificationTitle = 'Offer Accepted';
                notificationBody = `Your offer of $${offerPrice} has been accepted for order ID: ${orderId}.`;
            } else if (offersAfter.isAccepted === 'rejected') {
                notificationTitle = 'Offer Rejected';
                notificationBody = `Your offer of $${offerPrice} has been rejected for order ID: ${orderId}.`;
            }

            try {
                // Fetch buyer's FCM token from userDetails collection
                const userDoc = await admin.firestore().collection('userDetails').doc(buyerId).get();

                if (!userDoc.exists) {
                    console.error('User not found for buyerId:', buyerId);
                    return null;
                }

                const userData = userDoc.data();
                const buyerToken = userData.fcmToken;  // Assuming the FCM token is stored as fcmToken

                const message = {
                    token: buyerToken,  // Buyer's FCM token
                    notification: {
                        title: notificationTitle,
                        body: notificationBody,
                    },
                    data: {
                        orderId: context.params.orderId,  // Order ID in the data payload
                        buyerId: buyerId,  // Buyer ID
                        offerPrice: offerPrice.toString(),  // Offer price as string
                    },
                };

                // Send notification to the buyer's device
                const response = await admin.messaging().send(message);
                console.log('Successfully sent offer status notification:', response);
            } catch (error) {
                console.error('Error sending notification:', error);
            }
        }

        return null;  // Return null if no change in isAccepted field
    });


exports.checkAndRefundOrders = functions.pubsub.schedule('every 6 hours').onRun(async (context) => {
        const currentTime = admin.firestore.Timestamp.now();
        const cutoffTime = admin.firestore.Timestamp.fromMillis(currentTime.toMillis() - 24 * 60 * 60 * 1000); // 24 hours ago

        try {
            // Fetch orders where deliveryStatus is false and orderDate is older than 24 hours
            const orderSnapshot = await firestore.collection('orders')
                .where('deliveryStatus', '==', false)
                .where('refund', '==', false)
                .where('orderDate', '<=', cutoffTime)
                .get();

            if (orderSnapshot.empty) {
                console.log('No orders found that require refunds');
                return null;
            }

            const refundPromises = [];
            orderSnapshot.forEach(doc => {
                const orderData = doc.data();
                const buyerId = orderData.buyerId;
                const buyingPrice = orderData.buyingprice;
                if(orderData.buyingprice>=50){
                // Refund logic for each buyer
                refundPromises.push(processRefund(buyerId, buyingPrice, doc.id));

               }else{
                console.log("buyihg is less then 50 so can't refund");
                  return null;
               }
            });

            // Wait for all refund promises to complete
            await Promise.all(refundPromises);

            console.log('Refunds processed successfully');
            return null;
        } catch (error) {
            console.error('Error processing refunds:', error);
            return null;
        }
    });
exports.refundOrderOnUpdate = functions.firestore
    .document('orders/{orderId}')
    .onUpdate(async (change, context) => {
        const beforeData = change.before.data(); // Data before the update
        const afterData = change.after.data();   // Data after the update

        // Check if `isReturning` changed from `false` to `true` and refund is `false`
        if (!beforeData.isReturning && afterData.isReturning && !afterData.refund) {
            try {
                const buyerId = afterData.buyerId;
                const buyingPrice = afterData.buyingprice;

                // Only refund if the buying price is 50 or more

                    await processRefund(buyerId, buyingPrice, context.params.orderId);
                    console.log('Refund processed for order:', context.params.orderId);



            } catch (error) {
                console.error('Error processing refund for order:', context.params.orderId, error);
                return null;
            }
        } else {
            console.log('No action required. Either isReturning did not change or refund has already been processed.');
            return null;
        }
    });

// Mock refund function for illustration
async function processRefund(buyerId, amount, orderId) {
    // Your refund logic here
    console.log(`Refunding ${amount} to buyer ${buyerId} for order ${orderId}`);
}


    // Function to process refund for a specific buyer
    async function processRefund(buyerId, refundAmount, orderId) {
        const walletRef = firestore.collection('wallet').doc(buyerId);
        const userRef = firestore.collection('userDetails').doc(buyerId); // Assuming user's FCM token is stored in users collection

        return firestore.runTransaction(async (transaction) => {
            const walletDoc = await transaction.get(walletRef);
            const userDoc = await transaction.get(userRef);

            if (!walletDoc.exists) {
                console.error(`No wallet found for user ${buyerId}`);
                return;
            }

            if (!userDoc.exists) {
                console.error(`No user data found for user ${buyerId}`);
                return;
            }

            const currentBalance = walletDoc.data().balance || 0;
            const refundWithBonus = refundAmount + (refundAmount * 0.10); // Add 10% to the refund amount
            const newBalance = currentBalance + refundWithBonus;

            // Update the buyer's wallet with the new balance
            transaction.update(walletRef, {
                balance: newBalance
            });

            // Update the order to indicate refund is processed
            transaction.update(firestore.collection('orders').doc(orderId), {
                refund: true
            });

            // Send notification to the buyer if refund is processed
            const fcmToken = userDoc.data().fcmToken; // Assuming FCM token is stored in user's document
            if (fcmToken) {
                await sendRefundNotification(fcmToken, refundWithBonus);
            } else {
                console.log(`No FCM token found for user ${buyerId}, cannot send notification`);
            }

            console.log(`Refund of ${refundAmount} processed for user ${buyerId}`);
        });
    }

    // Function to send notification using Firebase Cloud Messaging (FCM)
    async function sendRefundNotification(fcmToken, refundAmount) {
        const message = {
            token: fcmToken,
            notification: {
                title: 'Refund Successful',
                body: `Your refund of ${refundAmount} has been processed successfully.`,
            },
        };

        try {
            await admin.messaging().send(message);
            console.log(`Notification sent to token: ${fcmToken}`);
        } catch (error) {
            console.error('Error sending notification:', error);
        }
    }

    exports.onRefundProcessed = functions.firestore.document('orders/{orderId}').onUpdate(async (change, context) => {
            const beforeData = change.before.data();
            const afterData = change.after.data();

            // Check if refund status changed to true
            if (!beforeData.refund && afterData.refund) {
                const userId = afterData.buyerId;
                const sellerId = afterData.sellerId;
                const price = afterData.buyingprice;
                const productName = afterData.productName;
                const purchaseType = 'refund';

                try {
                    // Fetch buyer details (userName and userImage)
                    const userSnapshot = await firestore.collection('userDetails').doc(userId).get();
                    const userData = userSnapshot.data();
                    const userName = userData.userName;
                    const userImage = userData.userImage;

                    // Fetch seller details (sellerName)
                    const sellerSnapshot = await firestore.collection('userDetails').doc(sellerId).get();
                    const sellerData = sellerSnapshot.data();
                    const sellerName = sellerData.userName;

                    // Store the refund transaction in the buyer's wallet transaction collection
                    await firestore.collection('wallet').doc(userId).collection('transaction').add({
                        'price': price,
                        'date': admin.firestore.FieldValue.serverTimestamp(), // Use server timestamp
                        'type': purchaseType,
                        'productName': productName,
                        'userName': userName,
                        'userImage': userImage,
                        'sellerName': sellerName
                    });

                    console.log(`Transaction recorded for refund of ${price} for user ${userId}`);
                } catch (error) {
                    console.error('Error storing transaction history:', error);
                }
            }
        });


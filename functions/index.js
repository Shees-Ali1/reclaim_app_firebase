const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// Triggered when a new document is created in the userNotifications/{userId}/notifications collection
exports.sendUserNotification = functions.firestore
  .document('userNotifications/{userId}/notifications/{notificationId}')
  .onCreate(async (snapshot, context) => {
    const notificationData = snapshot.data(); // The new notification data
    const userId = context.params.userId; // Extract userId from the path

    // Fetch the user's FCM token from userDetails collection
    const userDetailsRef = admin.firestore().collection('userDetails').doc(userId);
    const userDetailsSnapshot = await userDetailsRef.get();

    if (!userDetailsSnapshot.exists) {
      console.error('User not found!');
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
        orderId: notificationData.orderId || '', // Add any additional data if needed
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
    }
  });

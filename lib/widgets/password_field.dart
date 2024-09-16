import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PasswordField extends StatelessWidget {

  // final String label;
  final String hint;
  // final FocusNode passwordFocus;
  final TextEditingController? controller;
  final FormFieldValidator<String?>? validator;
  final VoidCallback? onTap;
  final TextInputType keyboard;
  // final TextInputAction textInputAction;
  final Color? cursorColor;
  final bool isObscure;
  final Widget trailIcon;
  final hintStyle;

  const PasswordField(
      {super.key,
        // required this.label,
        required this.hint,

        // required this.passwordFocus,
        required this.keyboard,
        // required this.textInputAction,
        required this.trailIcon,
        required this.isObscure,
        this.controller,
        this.cursorColor,
        this.onTap,
        this.validator, this.hintStyle});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: isObscure,
      // keyboardType: keyboard,
      validator: validator,
      // focusNode: passwordFocus,
      cursorColor: cursorColor,
      textInputAction: TextInputAction.done,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xff29604E).withOpacity(0.06),
        hintText: hint,
        hintStyle: hintStyle,
        // labelText: label,
        // labelStyle: const TextStyle(color: AppColor.blackColor),
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.all(15.0),
        //   child: SvgPicture.asset(AppIcons.passwordLock),
        // ),
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: trailIcon,
          ),
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }
}

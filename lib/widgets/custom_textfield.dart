import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputField extends StatelessWidget {

  // final String label;
  final contentPadding;
  final String hint;
  // final String preIcon;
  // final FocusNode inputFocus;
  final TextEditingController? controller;
  final FormFieldValidator<String?>? validator;
  // final VoidCallback onComplete;
  final TextStyle hintStyle;
  final TextStyle inputTextStyle;
  final TextInputType keyboard;
  final Color? cursorColor;
  final bool readOnly;

  const InputField(


      {super.key,
        // required this.label,
        required this.hint,
        // required this.preIcon,
        // required this.inputFocus,
        // required this.onComplete,
        required this.keyboard,
        this.hintStyle =
        const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        this.inputTextStyle = const TextStyle(color: Colors.black),
        this.controller,
        this.cursorColor,
        this.validator, this.readOnly=false, this.contentPadding});

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: keyboard,
      validator: validator,
      // focusNode: inputFocus,
      textInputAction: TextInputAction.next,
      // onEditingComplete: onComplete,
      style: inputTextStyle,
      cursorColor: cursorColor,
      decoration: InputDecoration(

        filled: true,
        fillColor: const Color(0xff29604E).withOpacity(0.06),
        hintText: hint,
        hintStyle: hintStyle,
        // labelText: label,
        // labelStyle: const TextStyle(color: AppColor.shadeBlue),
        // prefixIcon: Padding(
        //   padding: const EdgeInsets.all(15.0),
        //   child: SvgPicture.asset(preIcon),
        // ),
        contentPadding:
       contentPadding,
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

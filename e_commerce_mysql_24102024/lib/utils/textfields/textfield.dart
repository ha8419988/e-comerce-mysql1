// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final bool isObsecure;
  final VoidCallback? onLeftIconPressed;
  final VoidCallback? onRightIconPressed;

  const AppTextField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.leftIcon,
    this.rightIcon,
    this.isObsecure = false,
    this.onLeftIconPressed,
    this.onRightIconPressed,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            15,
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 3,
              offset: const Offset(0, 3),
              color: Colors.grey.withOpacity(0.3),
            ),
          ]),
      child: TextField(
        obscureText: widget.isObsecure,
        controller: widget.textEditingController,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: InkWell(
            onTap: widget.onLeftIconPressed,
            child: Icon(
              widget.leftIcon,
              color: const Color.fromARGB(
                205,
                102,
                104,
                209,
              ),
            ),
          ),
          suffixIcon: InkWell(
            onTap: widget.onRightIconPressed,
            child: Icon(
              widget.rightIcon,
              color: const Color.fromARGB(
                205,
                102,
                104,
                209,
              ),
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                20,
              ),
              borderSide: const BorderSide(
                width: 1,
                color: Colors.grey,
              )),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15,
            ),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

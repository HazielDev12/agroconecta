import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  const CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 254, 254, 254),
        width: 1.2,
      ),
      borderRadius: BorderRadius.circular(15),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      /*       decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ), */
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        cursorColor: colors.primary,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade50,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: colors.primary.withValues(alpha: 0.8))
              : null,
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: colors.primary.withValues(alpha: 0.8))
              : null,
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: TextStyle(
            color: colors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          enabledBorder: border.copyWith(
            borderSide: BorderSide(color: colors.primary, width: 1.2),
          ),
          focusedBorder: border.copyWith(
            borderSide: BorderSide(color: colors.primary, width: 1.8),
            borderRadius: BorderRadius.circular(14),
          ),
          errorBorder: border.copyWith(
            borderSide: BorderSide(color: Colors.red.shade800, width: 1.5),
          ),
          focusedErrorBorder: border.copyWith(
            borderSide: BorderSide(color: Colors.red.shade800, width: 1.5),
          ),
          isDense: true,
          label: label != null ? Text(label!) : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
          // icon: Icon( Icons.supervised_user_circle_outlined, color: colors.primary, )
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ofg_web/constants/color_palette.dart';

OFGColorPalette _palette = OFGColorPalette();

class TopLabelTextField {
  TopLabelTextField();

  Widget topLabelTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required TextInputType keyboardType,
    required bool obscureText,
    required bool requiredField,
    Color? borderColor,
    int? maxLines,
    int? maxLength,
    double? borderRadius,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // The label above the input field
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: _palette.primaryBlue,
              ),
            ),
            requiredField
                ? const Text(
                    ' *',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          maxLength: maxLength,
          maxLines: maxLines ?? 1,
          keyboardType: keyboardType,
          obscureText: obscureText,
          cursorColor: _palette.primaryBlue,
          autocorrect: true,
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
            focusedBorder: borderColor != null
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                  )
                : null,
            hintText: hintText,
            suffixIcon: suffixIcon,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12),
              borderSide: BorderSide(color: _palette.primaryBlue),
            ),
          ),
        ),
      ],
    );
  }
}

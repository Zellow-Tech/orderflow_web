// the custom text field
import 'package:flutter/material.dart';
import 'package:ofg_web/constants/color_palette.dart';

OFGColorPalette _palette = OFGColorPalette();

class TopLabelTextField {
  TopLabelTextField();

  topLabelTextField(
      {required controller,
      required label,
      required hintText,
      required keyboardType,
      required obscureText,
      required requiredField,
      borderColor,
      maxLines,
      maxLength,
      borderRadius}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            // the label above top
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: _palette.primaryBlue,
              ),
            ),
            requiredField
                ? const Text(
                    '*',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(
                    width: 0,
                  ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          maxLength: maxLength,
          maxLines: maxLines != null ? maxLines! : 1,
          keyboardType: keyboardType,
          obscureText: obscureText,
          cursorColor: _palette.primaryBlue,
          autocorrect: true,
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
            focusedBorder: borderColor != null
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor!))
                : null,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            border: borderRadius == null
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                    borderSide: BorderSide(color: _palette.primaryBlue))
                : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius!),
                    borderSide: BorderSide(color: _palette.primaryBlue)),
          ),
        ),
      ],
    );
  }
}

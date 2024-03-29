import 'package:flutter/material.dart';

// ignore: constant_identifier_names
enum TextfieldType { Text, Password, Number, Email }

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextfieldType type;
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.controller,
    this.validator,
    this.type = TextfieldType.Text,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obsequreText = false;
  @override
  void initState() {
    if (widget.type == TextfieldType.Password) {
      obsequreText = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType;
    if (widget.type == TextfieldType.Number) {
      keyboardType = TextInputType.number;
    } else if (widget.type == TextfieldType.Email) {
      keyboardType = TextInputType.emailAddress;
    } else {
      keyboardType = TextInputType.text;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: TextFormField(
        obscureText: obsequreText,
        keyboardType: keyboardType,
        validator: widget.validator,
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(
            widget.prefixIcon,
          ),
          suffixIcon: widget.type == TextfieldType.Password
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      obsequreText = !obsequreText;
                    });
                  },
                  child: Icon(
                    obsequreText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.brown,
                  ))
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool readOnly; 
  final VoidCallback? onTap; 
  final IconData icon;
  final GlobalKey<FormFieldState>? formFieldKey; 
  final String? Function(String?)? validator;
  final String textFieldName;

  const CustomTextField({ 
    super.key,
    this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.readOnly = false, 
    this.onTap, 
    required this.icon,
    this.validator,
    this.formFieldKey, 
    required this.textFieldName,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(widget.textFieldName , style: const TextStyle(fontWeight: FontWeight.w400 , fontSize: 15)),
        const SizedBox(height: 5),
        TextFormField(
          key: widget.formFieldKey,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _isObscure : false,
          validator: widget.validator,
          readOnly: widget.readOnly, 
          onTap: widget.onTap, 
          decoration: InputDecoration(
            hintText: widget.hintText ?? '',
            prefixIcon: Icon(widget.icon, color: Colors.green),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      ],
    );
  }
}

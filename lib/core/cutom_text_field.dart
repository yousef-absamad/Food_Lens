// import 'package:flutter/material.dart';

// class CustomTextField extends StatefulWidget {
//   final String hintText;
//   final TextEditingController controller;
//   final TextInputType keyboardType;
//   final bool isPassword;
//   final IconData icon;
//   final GlobalKey<FormFieldState>? formFieldKey; 
//   final String? Function(String?)? validator;
//   final String textFieldName;

//   const CustomTextField({ 
//     super.key,
//     required this.hintText,
//     required this.controller,
//     this.keyboardType = TextInputType.text,
//     this.isPassword = false,
//     required this.icon,
//     this.validator,
//     required this.formFieldKey,
//     required this.textFieldName,
//   });

//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }

// class _CustomTextFieldState extends State<CustomTextField> {
//   bool _isObscure = true;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(widget.textFieldName , style: TextStyle(fontWeight: FontWeight.w400 , fontSize: 15),),
//         SizedBox(height: 5),
//         TextFormField(
//           key:widget.formFieldKey,
//           controller: widget.controller,
//           keyboardType: widget.keyboardType,
//           obscureText: widget.isPassword ? _isObscure : false,
//           validator: widget.validator,
//           decoration: InputDecoration(
//             hintText: widget.hintText,
//             prefixIcon: Icon(widget.icon, color: Colors.green),
//             suffixIcon: widget.isPassword
//                 ? IconButton(
//                     icon: Icon(
//                       _isObscure ? Icons.visibility_off : Icons.visibility,
//                       color: Colors.grey,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isObscure = !_isObscure;
//                       });
//                     },
//                   )
//                 : null,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.green),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.green),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: const BorderSide(color: Colors.green),
//             ),
//             filled: true,
//             fillColor: Colors.grey[200],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool readOnly; // تحديد إذا كان الحقل للقراءة فقط
  final VoidCallback? onTap; // دالة تُنفذ عند الضغط
  final IconData icon;
  final GlobalKey<FormFieldState>? formFieldKey; 
  final String? Function(String?)? validator;
  final String textFieldName;

  const CustomTextField({ 
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.readOnly = false, // افتراضيًا يمكن التعديل
    this.onTap, // افتراضيًا لا يوجد حدث عند الضغط
    required this.icon,
    this.validator,
    this.formFieldKey, // الآن غير مطلوب
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
        Text(widget.textFieldName , style: const TextStyle(fontWeight: FontWeight.w400 , fontSize: 15)),
        const SizedBox(height: 5),
        TextFormField(
          key: widget.formFieldKey,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _isObscure : false,
          validator: widget.validator,
          readOnly: widget.readOnly, // جعل الحقل للقراءة فقط إذا لزم الأمر
          onTap: widget.onTap, // تنفيذ الدالة عند الضغط إذا تم تمريرها
          decoration: InputDecoration(
            hintText: widget.hintText,
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

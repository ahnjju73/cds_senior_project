import 'package:cds_class/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  const CustomTextField({
    super.key,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    var baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Colors.black,
        width: 15.0,
      )
    );

    return TextFormField(
      cursorColor: MAIN_COLOR,

      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: '$hintText',
        hintStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          color: Color(0xff0000f0)
        ),
        // errorText: '',
        fillColor: Colors.white,
        filled: true,
        border: baseBorder,
      ),
    );
  }
}



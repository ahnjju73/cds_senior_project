import 'package:cds_class/common/const/colors.dart';
import 'package:flutter/material.dart';

//custom button
class CustomElevatedButton extends StatelessWidget {
  final String text;
  final size;
  final VoidCallback onPressed;

  const CustomElevatedButton({required this.text, required this.size, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: SUB_COLOR,
        minimumSize: Size(double.infinity, size),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text("$text",
        style: TextStyle(
          color: MAIN_COLOR,
          fontSize: 25
        ),
      ),
    );
  }
}
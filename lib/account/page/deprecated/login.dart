// import 'package:cds_class/account/page/signup.dart';
// import 'package:cds_class/common/component/custom_button.dart';
// import 'package:cds_class/common/component/custum_text_form_field.dart';
// import 'package:cds_class/common/const/colors.dart';
// import 'package:flutter/material.dart';
//
// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: MAIN_COLOR,
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Login',
//               style: TextStyle(
//                   fontFamily: 'Roboto',
//                   fontSize: 40,
//                   fontWeight: FontWeight.w100
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 50),
//               child: CustomTextField(
//                 hintText: 'Enter Email',
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 50),
//               child: CustomTextField(
//                 hintText: 'Enter Password',
//               ),
//             ),
//             CustomElevatedButton(text: 'start', size: 10.0, onPressed: (){}),
//             CustomElevatedButton(
//               text: 'sign up',
//               size: 10.0,
//               onPressed: (){
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => Signup())
//                 );
//               },
//             ),
//             Padding(padding: EdgeInsets.zero)
//           ],
//         )
//     );
//   }
// }

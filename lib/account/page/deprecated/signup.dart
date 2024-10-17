import 'dart:async';
import 'dart:convert';

import 'package:cds_class/account/model/User.dart';
import 'package:cds_class/account/util/check_validate.dart';
import 'package:cds_class/common/component/custom_button.dart';
import 'package:cds_class/common/component/custum_text_form_field.dart';
import 'package:cds_class/common/const/ErrorMessage.dart';
import 'package:cds_class/common/const/api_server.dart';
import 'package:cds_class/common/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  int time = 300;
  Timer? timer;
  bool isSend = false;
  bool isVerified = false;

  final _houses = ['red', 'blue', 'green', 'yellow'];
  String _selected_house = 'red';
  late final dWidth = MediaQuery.of(context).size.width;
  late final dHeight = MediaQuery.of(context).size.height;

  FocusNode _nameFNode = FocusNode();
  FocusNode _pwFNode = FocusNode();
  FocusNode _rePwFNode = FocusNode();
  FocusNode _emailFNode = FocusNode();
  FocusNode _codeFNode = FocusNode();
  FocusNode _gradeFNode = FocusNode();
  FocusNode _houseFNode = FocusNode();

  final _nameController =  TextEditingController();
  final _pwController =  TextEditingController();
  final _codeController =  TextEditingController();
  final _emailController =  TextEditingController();
  final _gradeController =  TextEditingController();
  final _houseController =  TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MAIN_COLOR,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign Up',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 40,
                  fontWeight: FontWeight.w100
              ),
            ),
            Form(
              key: _emailFormKey,
              child: Column(
                children: [
                  _emailInput(),
                  verifyButton(),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _nameInput(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: CustomTextField(
                      hintText: 'Enter Password',
                    ),
                  ),
                  DropdownButton(
                      value: _selected_house,
                      items: _houses.map(
                          (value){
                            return DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            );
                          }
                      ).toList(),
                      onChanged: (value){
                        setState(() {
                          _selected_house = value!;
                        });
                      }
                  ),
                  CustomElevatedButton(
                    text: 'sign up',
                    size: 10.0,
                    onPressed: () async{
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                    }
                    User user = User(email: _emailController.text, name: _nameController.text, password: 'password', house: 'house', grade: 'grade');
                    ApiClient.joinUser(user);

                  },),
                  Padding(padding: EdgeInsets.zero)
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget _nameInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextFormField(
        obscureText: true,
        focusNode: _nameFNode,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'name',
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Roboto',
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey,
                width: 3.0
            ),
          ),
          hintText: 'enter name',
          fillColor: Colors.white,
          filled: true,
        ),
        controller: _nameController,
        validator: (value) => CheckValidate().validateName(_nameFNode, value ?? ''),
      ),
    );
  }

  Widget _emailInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: Row(
        children: [
          SizedBox(
            width: dWidth / 1.8,
            child: TextFormField(
              focusNode: _emailFNode,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'email',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Roboto',
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey,
                      width: 3.0
                  ),
                ),
                hintText: 'enter email',
                fillColor: Colors.white,
                filled: true,
              ),
              controller: _emailController,
              validator: (value) => CheckValidate().validateEmail(_emailFNode, value ?? ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  fixedSize: Size((dWidth * 0.8 / 1.8) - 102, 30)
                ),
                onPressed: () async{
                  var validate = _emailFormKey.currentState!.validate();
                  if(validate){
                    _sendEmailVerification();
                  }
                },
                child: Text(
                    isSend ? '$time' : 'send'
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget verifyButton(){
    return Visibility(
      visible: isSend && !isVerified,
      child: Row(
        children: [
          SizedBox(
            width: dWidth / 1.8,
            child: TextFormField(
              focusNode: _codeFNode,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'verification code',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Roboto',
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey,
                      width: 3.0
                  ),
                ),
                hintText: 'enter verification',
                fillColor: Colors.white,
                filled: true,
              ),
              controller: _codeController,
              validator: (value) => CheckValidate().validateVeriCode(_codeFNode, value ?? ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    fixedSize: Size((dWidth * 0.8 / 1.8) - 102, 30)
                ),
                onPressed: () async{
                  var response = await http.put(Uri.parse(baseUrl + '/confirm/email-validation'),
                    body: {
                      'email' : _emailController.text,
                      'code' : _codeController.text
                    }
                  );
                  var statusCode = response.statusCode;
                  if(statusCode != 200){
                    var body = json.decode(utf8.decode(response.bodyBytes));
                    ErrorMessage error = ErrorMessage.fromJson(body);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.message),
                          duration: const Duration(seconds: 3),
                        )
                    );
                  }else{
                    setState(() {
                      isVerified = true;
                    });
                  }
                },
                child: Text(
                  '인증',
                )
            ),
          ),
        ],
      ),
    );
  }

  void _sendEmailVerification() async{
    var response = await http.put(Uri.parse(baseUrl + '/request/email-validation'),
      body: {
        'email' : _emailController.text,
      }
    );
    var statusCode = response.statusCode;
    if(statusCode != 200){
      var body = json.decode(utf8.decode(response.bodyBytes));
      ErrorMessage error = ErrorMessage.fromJson(body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message),
          duration: const Duration(seconds: 3),
        )
      );
    }else{
      countDown();
    }
  }

  void countDown(){
    timer = Timer.periodic(Duration(seconds: 1), (timer){
      if(time > 0){
        setState(() {
          isSend = true;
          time--;
        });
      }
    });
  }


}

import 'package:flutter/material.dart';

class CheckValidate{
  String? validateName(FocusNode focusNode, String v){
    if(v.isEmpty){
      focusNode.requestFocus();
      return '이름을 입력해주세요';
    }
    return null;
  }


  String? validateEmail(FocusNode focusNode, String value){
    if(value.isEmpty){
      focusNode.requestFocus();
      return '이메일을 입력하세요.';
    }else {
      RegExp regExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      if(value.split('@')[1] != 'daltonschool.kr'){
        return '달튼 학생만 가입이 가능합니다. 달튼 이메일을 사용해주세요';
      }
      if(!regExp.hasMatch(value)){
        focusNode.requestFocus();	//포커스를 해당 textformfield에 맞춘다.
        return '잘못된 이메일 형식입니다.';
      }
      // else if(!acceptEmails.contains(value.substring(value.indexOf("@") + 1))){
      //   return '해당 이메일은 허가된 주소가 아닙니다.';
      // }
      else{
        return null;
      }
    }
  }

  String? validatePassword(FocusNode focusNode, String value){
    if(value.isEmpty){
      focusNode.requestFocus();
      return '비밀번호를 입력하세요.';
    }else {
      Pattern pattern = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
      RegExp regExp = new RegExp(pattern.toString());
      if(!regExp.hasMatch(value)){
        focusNode.requestFocus();
        return '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
      }else{
        return null;
      }
    }
  }

  String? validateRePassword(FocusNode focusNode, String value, String password){
    if(value.isEmpty){
      focusNode.requestFocus();
      return '비밀번호를 입력하세요.';
    }else {
      if(password != value){
        focusNode.requestFocus();
        return '패스워드와 일치하지 않습니다.';
      }
    }
    return null;
  }


  String? validateGrade(FocusNode focusNode, String value){
    if(value.isEmpty){
      focusNode.requestFocus();
      return '학년을 입력하세요.';
    }else {
      var grade = int.parse(value);
      if(grade >= 9 && grade <= 12){
        return '9 ~ 12학년 학생만 가입이 가능합니다.';
      }
      return null;
    }
  }

  String? validateVeriCode(FocusNode focusNode, String value){
    if(value.isEmpty){
      focusNode.requestFocus();
      return '인증 코드를 입력하세요.';
    }else {

    }
    return null;
  }

  String? validateClassName(FocusNode fNode, String value){
    if(value.isEmpty){
      fNode.requestFocus();
      return 'Block 위치를 입력해주세요.';
    }else if(value.length > 6){
      fNode.requestFocus();
      return '6자를 넘지 마세요.';
    }
    return null;
  }

  String? validateCourseName(FocusNode fNode, String value){
    if(value.isEmpty){
      fNode.requestFocus();
      return 'Block 과목명을 입력해주세요.';
    }else if(value.length > 12){
      fNode.requestFocus();
      return '12자를 넘지 마세요.';
    }
    return null;
  }


}
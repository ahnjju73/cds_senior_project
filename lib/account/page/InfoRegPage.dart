import 'package:cds_class/account/util/check_validate.dart';
import 'package:cds_class/account/util/info_data.dart';
import 'package:cds_class/common/component/custom_button.dart';
import 'package:cds_class/common/const/colors.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class InfoRegPage extends StatefulWidget {
  const InfoRegPage({super.key});

  @override
  State<InfoRegPage> createState() => _InfoRegPageState();
}

class _InfoRegPageState extends State<InfoRegPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final _b1Controller = TextEditingController();
  final _b2Controller = TextEditingController();
  final _b3Controller = TextEditingController();
  final _b4Controller = TextEditingController();
  final _b5Controller = TextEditingController();
  final _b6Controller = TextEditingController();
  final _b7Controller = TextEditingController();


  final _b1classController = TextEditingController();
  final _b2classController = TextEditingController();
  final _b3classController = TextEditingController();
  final _b4classController = TextEditingController();
  final _b5classController = TextEditingController();
  final _b6classController = TextEditingController();
  final _b7classController = TextEditingController();


  FocusNode _nameNode = FocusNode();
  FocusNode _b1FNode = FocusNode();
  FocusNode _b2FNode = FocusNode();
  FocusNode _b3FNode = FocusNode();
  FocusNode _b4FNode = FocusNode();
  FocusNode _b5FNode = FocusNode();
  FocusNode _b6FNode = FocusNode();
  FocusNode _b7FNode = FocusNode();


  FocusNode _b1classFNode = FocusNode();
  FocusNode _b2classFNode = FocusNode();
  FocusNode _b3classFNode = FocusNode();
  FocusNode _b4classFNode = FocusNode();
  FocusNode _b5classFNode = FocusNode();
  FocusNode _b6classFNode = FocusNode();
  FocusNode _b7classFNode = FocusNode();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MAIN_COLOR,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                    child: TextFormField(
                      focusNode: _nameNode,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'name',
                        labelStyle: TextStyle(
                          color: SUB_COLOR,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey,
                              width: 3.0
                          ),
                        ),
                        hintText: 'enter your name',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      controller: nameController,
                      validator: (value) => CheckValidate().validateName(_nameNode, value ?? ''),
                    ),
                  ),
                  _blockInput(_b1Controller, _b1FNode, 'block 1', _b1classController, _b1classFNode),
                  _blockInput(_b2Controller, _b2FNode, 'block 2', _b2classController, _b2classFNode),
                  _blockInput(_b3Controller, _b3FNode, 'block 3', _b3classController, _b3classFNode),
                  _blockInput(_b4Controller, _b4FNode, 'block 4', _b4classController, _b4classFNode),
                  _blockInput(_b5Controller, _b5FNode, 'block 5', _b5classController, _b5classFNode),
                  _blockInput(_b6Controller, _b6FNode, 'block 6', _b6classController, _b6classFNode),
                  _blockInput(_b7Controller, _b7FNode, 'block 7', _b7classController, _b7classFNode),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
                    child: CustomElevatedButton(text: 'Submit',
                        size: 50.0,
                        onPressed: () async{
                          print('submit clicked! ${_formKey.currentState!.validate()}');
                          if(_formKey.currentState!.validate()){
                            _formKey.currentState!.save();
                          }
                          SaveData data = SaveData(
                              nameController.text,
                              _b1Controller.text, _b1classController.text,
                              _b2Controller.text, _b2classController.text,
                              _b3Controller.text, _b3classController.text,
                              _b4Controller.text, _b4classController.text,
                              _b5Controller.text, _b5classController.text,
                              _b6Controller.text, _b6classController.text,
                              _b7Controller.text, _b7classController.text
                          );
                          print('${data.toJson()}');
                          await saveData('block_info', data);
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => HomePage(data)
                          ));
                        }

                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _blockInput(TextEditingController classController, FocusNode classNode, String blockName, TextEditingController courseController, FocusNode courseNode){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
      child: Column(
        children: [
          TextFormField(
            focusNode: classNode,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: '$blockName course name',
              labelStyle: TextStyle(
                color: SUB_COLOR,
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey,
                    width: 3.0
                ),
              ),
              hintText: 'enter block class name',
              fillColor: Colors.white,
              filled: true,
            ),
            controller: classController,
            validator: (value) => CheckValidate().validateCourseName(classNode, value ?? ''),
          ),
          TextFormField(
            focusNode: courseNode,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: '$blockName class room',
              labelStyle: TextStyle(
                color: SUB_COLOR,
                fontSize: 20,
                fontFamily: 'Roboto',
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey,
                    width: 3.0
                ),
              ),
              hintText: 'enter class room',
              fillColor: Colors.white,
              filled: true,
            ),
            controller: courseController,
            validator: (value) => CheckValidate().validateClassName(courseNode, value ?? ''),
          ),
        ],
      ),
    );

  }
}

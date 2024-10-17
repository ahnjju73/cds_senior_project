import 'dart:collection';
import 'dart:io';

import 'package:cds_class/account/page/cafeteria.dart';
import 'package:cds_class/account/page/game.dart';
import 'package:cds_class/account/page/schedule.dart';
import 'package:cds_class/account/page/timetable.dart';
import 'package:cds_class/account/util/info_data.dart';
import 'package:cds_class/common/const/colors.dart';
import 'package:excel/excel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';



class HomePage extends StatefulWidget {
  final SaveData data;

  const HomePage(this.data);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<Widget> _navIndex = [
    GamePage(),
    Cafeteria(),
    // Timetable(),
    Schedule(widget.data),
  ];
  int bottomIndex = 0;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 35,
          backgroundColor: MAIN_COLOR,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer, color: Colors.white,),
              label: 'GAME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fastfood, color: Colors.white,),
              label: 'CAFETERIA',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today, color: Colors.white,),
              label: 'TIMETABLE',
            ),
          ],
          currentIndex: bottomIndex, // 지정 인덱스로 이동
          selectedItemColor: Colors.lightGreen,
          unselectedItemColor: Colors.white,
          onTap: (int page){
            setState(() {
              bottomIndex = page;
            });
          }, // 선언했던 onItemTapped
        ),
        backgroundColor: MAIN_COLOR,
        body:_navIndex.elementAt(bottomIndex)
      ),
    );
  }

}

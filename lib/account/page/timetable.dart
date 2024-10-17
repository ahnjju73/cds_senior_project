import 'package:cds_class/common/const/colors.dart';
import 'package:flutter/material.dart';

class Timetable extends StatefulWidget {
  const Timetable({super.key});

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  List<Block> blocks = [
    Block(1, 'Math'),
    Block(2, 'Physics'),
    Block(3, 'English'),
    Block(4, 'Chemistry'),
    Block(5, 'Computer Science'),
    Block(6, 'AI CS'),
    Block(7, 'Psychology'),
  ];
  final List<String> week = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  var kColumnLength = 20;
  double kFirstColumnHeight = 25;
  double kBoxSize = 67;
  late final dWidth = MediaQuery.of(context).size.width;
  late final dHeiht = MediaQuery.of(context).size.height;
  late final boxWidth = (dWidth - kColumnLength) / 5;



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children:[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ElevatedButton(
                //   onPressed: (){setState(() {
                //     kColumnLength = 26;
                //     kFirstColumnHeight = 25;
                //     kBoxSize = 67;
                //   });}, child: Text('press', style: TextStyle(color: Colors.white),),
                // ),
                SizedBox(
                  height: (kColumnLength / 2 * kBoxSize) + kFirstColumnHeight,
                  child: Row(
                    children: [
                      buildTimeColumn(),
                      ...buildDayColumn(0),
                      ...buildDayColumn(1),
                      ...buildDayColumn(2),
                      ...buildDayColumn(3),
                      ...buildDayColumn(4),
                    ],
                  ),
                ),
              ],
            ),
            ...block1(blocks[0]),
            ...block2(blocks[1]),
            ...block3(blocks[2]),
            ...block4(blocks[3]),
            ...block5(blocks[4]),
            ...block6(blocks[5]),
            ...block7(blocks[6]),
            ...house(),
            ...lab(),
            ...lunch(),
            ...sot(),
          ]
        ),
      ),
    );
  }


  Expanded buildTimeColumn() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: kFirstColumnHeight,
          ),
          ...List.generate(
            kColumnLength,
                (index) {
              if (index % 2 == 0) {
                return const Divider(
                  color: Colors.grey,
                  height: 0,
                );
              }
              return SizedBox(
                height: kBoxSize,
                child: Center(child: Text('${index ~/ 2 + 8}', style: TextStyle(color: Colors.white),)),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> buildDayColumn(int index) {
    return [
      const VerticalDivider(
        color: Colors.grey,
        width: 0,
      ),
      Expanded(
        flex: 4,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  child: SizedBox(
                    height: 25,
                    child: Text(
                      '${week[index]}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                ...List.generate(
                  kColumnLength,
                      (index) {
                    if (index % 2 == 0) {
                      return const Divider(
                        color: Colors.grey,
                        height: 0,
                      );
                    }
                    return SizedBox(
                      height: kBoxSize,
                      child: Container(
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ];
  }

  List<Widget> block1(Block b1){
    return [
      Positioned(
        child: Container(
          color: Colors.green,
          child: Center(
            child: Text(
                '${b1.courseName}'
            ),
          ),
        ),
        top: 25,
        left: 21,
        height: kBoxSize * 8/6,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: Colors.green,
          child: Center(
            child: Text(
                '${b1.courseName}'
            ),
          ),
        ),
        top: 25 + (16/6 * kBoxSize),
        left: 22 + boxWidth,
        height: kBoxSize * 7/6,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: Colors.green,
          child: Center(
            child: Text(
                '${b1.courseName}'
            ),
          ),
        ),
        top: 25 + (17/12 * kBoxSize),
        left: 22 + boxWidth * 3,
        height: kBoxSize * 7/6,
        width: boxWidth,
      ),
    ];
  }

  List<Widget> block2(Block b2){
    Color bColor = Color(0xFF8817FF);
    return [
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b2.courseName}'
            ),
          ),
        ),
        top: 25 + (17/12 * kBoxSize),
        left: 21,
        height: kBoxSize * 7/6,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b2.courseName}'
            ),
          ),
        ),
        top: 25 + (335 / 60 * kBoxSize),
        left: 22 + boxWidth,
        height: kBoxSize * 1.2,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b2.courseName}'
            ),
          ),
        ),
        top: 25 + (16/6 * kBoxSize),
        left: 22 + boxWidth * 3,
        height: kBoxSize * 7/6,
        width: boxWidth,
      ),
    ];
  }

  List<Widget> block3(Block b3){
    Color bColor = Color(0xFFF16F66);
    return [
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b3.courseName}'
            ),
          ),
        ),
        top: 25 + (16/6 * kBoxSize),
        left: 21,
        height: kBoxSize * 7/6,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b3.courseName}'
            ),
          ),
        ),
        top: 25 + (410 / 60 * kBoxSize),
        left: 22 + boxWidth,
        height: kBoxSize * 7/6,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b3.courseName}'
            ),
          ),
        ),
        top: 25 + (335/60 * kBoxSize),
        left: 22 + boxWidth * 3,
        height: kBoxSize * 7/6,
        width: boxWidth,
      ),
    ];
  }

  List<Widget> block4(Block b4){
    Color bColor = Color(0xFFFFD734);
    return [
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b4.courseName}'
            ),
          ),
        ),
        top: 25 + (335/60 * kBoxSize),
        left: 21,
        height: kBoxSize * 7/6,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b4.courseName}'
            ),
          ),
        ),
        top: 25,
        left: 22 + boxWidth * 2,
        height: kBoxSize * 8/6,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b4.courseName}'
            ),
          ),
        ),
        top: 25 + (410/60 * kBoxSize),
        left: 22 + boxWidth * 3,
        height: kBoxSize * 7/6,
        width: boxWidth,
      ),
    ];
  }

  List<Widget> block5(Block b5){
    Color bColor = Color(0xFFFF8D46);
    return [
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b5.courseName}'
            ),
          ),
        ),
        top: 25 + (410/60 * kBoxSize),
        left: 21,
        height: kBoxSize * 7/6,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b5.courseName}'
            ),
          ),
        ),
        top: 25 + (85/60 * kBoxSize),
        left: 22 + boxWidth * 2,
        height: kBoxSize * 7/6,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b5.courseName}'
            ),
          ),
        ),
        top: 25,
        left: 24 + boxWidth * 4,
        height: kBoxSize * 8/6,
        width: boxWidth,
      ),
    ];
  }

  List<Widget> block6(Block b6){
    Color bColor = Color(0xFF04FFE0);
    return [
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b6.courseName}'
            ),
          ),
        ),
        top: 25,
        left: 22 + boxWidth,
        height: kBoxSize * 8/6,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b6.courseName}'
            ),
          ),
        ),
        top: 25 + (160/60 * kBoxSize),
        left: 22 + boxWidth * 2,
        height: kBoxSize * 7/6,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b6.courseName}'
            ),
          ),
        ),
        top: 25 + kBoxSize * 85/60,
        left: 24 + boxWidth * 4,
        height: kBoxSize * 7/6,
        width: boxWidth,
      ),
    ];
  }
  List<Widget> block7(Block b7){
    Color bColor = Color(0xFFF321E9);
    return [
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b7.courseName}'
            ),
          ),
        ),
        top: 25 + (85/60 * kBoxSize),
        left: 22 + boxWidth,
        height: kBoxSize * 7/6,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b7.courseName}'
            ),
          ),
        ),
        top: 25,
        left: 22 + boxWidth * 3,
        height: kBoxSize * 8/6,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                '${b7.courseName}'
            ),
          ),
        ),
        top: 25 + kBoxSize * 160/60,
        left: 24 + boxWidth * 4,
        height: kBoxSize * 7/6,
        width: boxWidth,
      ),
    ];
  }

  List<Widget> house(){
    Color bColor = Colors.yellowAccent;
    return [
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'House'
            ),
          ),
        ),
        top: 25 + (235/60 * kBoxSize),
        left: 22,
        height: kBoxSize * 25/60,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'House'
            ),
          ),
        ),
        top: 25 + (235/60 * kBoxSize),
        left: 22 + boxWidth,
        height: kBoxSize * 25/60,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'Long House'
            ),
          ),
        ),
        top: 25 + (235/60 * kBoxSize),
        left: 22 + boxWidth * 2,
        height: kBoxSize * 40 /60,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'House'
            ),
          ),
        ),
        top: 25 + (235/60 * kBoxSize),
        left: 22 + boxWidth * 3,
        height: kBoxSize * 25/60,
        width: boxWidth,
      ),
    ];
  }

  List<Widget> lab(){
    Color bColor = Color(0xFFD3BD00);
    return [
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'Lab'
            ),
          ),
        ),
        top: 25 + (305/60 * kBoxSize),
        left: 22,
        height: kBoxSize * 25/60,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'Lab'
            ),
          ),
        ),
        top: 25 + (305/60 * kBoxSize),
        left: 22 + boxWidth,
        height: kBoxSize * 25/60,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'Long Lab'
            ),
          ),
        ),
        top: 25 + (375/60 * kBoxSize),
        left: 22 + boxWidth * 2,
        height: kBoxSize * 55 /60,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'Lab'
            ),
          ),
        ),
        top: 25 + (305/60 * kBoxSize),
        left: 22 + boxWidth * 3,
        height: kBoxSize * 25/60,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'Lab'
            ),
          ),
        ),
        top: 25 + (235/60 * kBoxSize),
        left: 24 + boxWidth * 4,
        height: kBoxSize * 30/60,
        width: boxWidth,
      ),
    ];
  }

  List<Widget> lunch(){
    Color bColor = Colors.white;
    return [
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'Lunch'
            ),
          ),
        ),
        top: 25 + (265/60 * kBoxSize),
        left: 22,
        height: kBoxSize * 40/60,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'Lunch'
            ),
          ),
        ),
        top: 25 + (265/60 * kBoxSize),
        left: 22 + boxWidth,
        height: kBoxSize * 40/60,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'Lunch'
            ),
          ),
        ),
        top: 25 + (280/60 * kBoxSize),
        left: 22 + boxWidth * 2,
        height: kBoxSize * 40 /60,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'Lunch'
            ),
          ),
        ),
        top: 25 + (265/60 * kBoxSize),
        left: 22 + boxWidth * 3,
        height: kBoxSize * 40/60,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'Lunch'
            ),
          ),
        ),
        top: 25 + (270/60 * kBoxSize),
        left: 24 + boxWidth * 4,
        height: kBoxSize * 40/60,
        width: boxWidth,
      ),
    ];
  }

  List<Widget> sot(){
    Color bColor = Colors.redAccent;
    return [
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'SOT1'
            ),
          ),
        ),
        top: 25 + (325/60 * kBoxSize),
        left: 22 + boxWidth * 2,
        height: kBoxSize * 45 /60,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'SOT2'
            ),
          ),
        ),
        top: 25 + (435/60 * kBoxSize),
        left: 22 + boxWidth * 2,
        height: kBoxSize * 45 /60,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'SOT3'
            ),
          ),
        ),
        top: 25 + (310/60 * kBoxSize),
        left: 24 + boxWidth * 4,
        height: kBoxSize * 40/60,
        width: boxWidth,
      ),
      Positioned(
        child: Container(
          color: bColor,
          child: Center(
            child: Text(
                'SOT4'
            ),
          ),
        ),
        top: 25 + (355/60 * kBoxSize),
        left: 24 + boxWidth * 4,
        height: kBoxSize * 45/60,
        width: boxWidth,
      ),
    ];
  }
}


class Block {
  int num;
  String courseName;

  Block(this.num, this.courseName);
}
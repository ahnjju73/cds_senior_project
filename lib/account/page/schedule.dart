import 'package:cds_class/account/util/info_data.dart';
import 'package:flutter/material.dart';

import '../util/calendar.dart';

class Schedule extends StatefulWidget {
  final SaveData data;
  const Schedule(this.data);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final List<String> week = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri',];
  int selected_weekday = DateTime.now().weekday - 5 < 0 ? DateTime.now().weekday : 1;
  late List<Block> blocks = [
    //b1
    Block(
      CourseInfo('${widget.data.b1Course}', '${widget.data.b1Class}'),
      [
        Course(
            1, 480, 80
        ),
        Course(
            2, 640, 70
        ),
        Course(
            4, 565, 70
        ),
      ]
    ),
    //b2
    Block(
        CourseInfo('${widget.data.b2Course}', '${widget.data.b2Class}'),
        [
          Course(
              1, 565, 70
          ),
          Course(
              2, 815, 70
          ),
          Course(
              4, 640, 70
          ),
        ]
    ),
    //b3
    Block(
        CourseInfo('${widget.data.b3Course}', '${widget.data.b3Class}'),
        [
          Course(
              1, 640, 70
          ),
          Course(
              2, 890, 70
          ),
          Course(
              4, 815, 70
          ),
        ]
    ),
    //b4
    Block(
        CourseInfo('${widget.data.b4Course}', '${widget.data.b4Class}'),
        [
          Course(
              1, 815, 70
          ),
          Course(
              3, 480, 80
          ),
          Course(
              4, 890, 70
          ),
        ]
    ),
    //b5
    Block(
        CourseInfo('${widget.data.b5Course}', '${widget.data.b5Class}'),
        [
          Course(
              1, 890, 70
          ),
          Course(
              3, 565, 70
          ),
          Course(
              5, 480, 80
          ),
        ]
    ),
    //b6
    Block(
        CourseInfo('${widget.data.b6Course} Science','${widget.data.b6Class}'),
        [
          Course(
              2, 480, 80
          ),
          Course(
              3, 640, 70
          ),
          Course(
              5, 565, 70
          ),
        ]
    ),
    //b7
    Block(
        CourseInfo('${widget.data.b7Course}', '${widget.data.b7Class}'),
        [
          Course(
              2, 565, 70
          ),
          Course(
              4, 480, 80
          ),
          Course(
              5, 640, 70
          ),
        ]
    ),
    // Block('Chemistry', 'House'),
    // Block('Computer Science', 'B2'),
    // Block('AI CS', 'B1'),
    // Block('Psychology', 'B4'),

    //house
    Block(
        CourseInfo('House', 'B1'),
        [
          Course(
              1, 715, 25
          ),
          Course(
              2, 715, 25
          ),
          Course(
              3, 715, 40
          ),
          Course(
              4, 715, 25
          ),
        ]
    ),
    //lunch
    Block(
        CourseInfo('Lunch', 'Cafe'),
        [
          Course(
              1, 745, 40
          ),
          Course(
              2, 745, 40
          ),
          Course(
              3, 760, 40
          ),
          Course(
              4, 745, 40
          ),
          Course(
              5, 750, 40
          ),
        ]
    ),
    //Lab
    Block(
        CourseInfo('Lab', 'Cafe'),
        [
          Course(
              1, 785, 25
          ),
          Course(
              2, 785, 25
          ),
          Course(
              3, 855, 55
          ),
          Course(
              4, 785, 25
          ),
          Course(
              5, 715, 30
          ),
        ]
    ),
    //sot1
    Block(
        CourseInfo('SOT1', 'SOT1'),
        [
          Course(
              3, 805, 45
          ),
        ]
    ),
    //sot2
    Block(
        CourseInfo('SOT2', 'SOT2'),
        [
          Course(
              3, 915, 45
          ),
        ]
    ),
    //sot3
    Block(
        CourseInfo('SOT3', 'SOT3'),
        [
          Course(
              5, 790, 40
          ),
        ]
    ),
    //sot4
    Block(
        CourseInfo('SOT4', 'SOT4'),
        [
          Course(
              5, 835, 45
          ),
        ]
    ),
  ];
  late final dWidth = MediaQuery.of(context).size.width;
  late final dHeight = MediaQuery.of(context).size.height;
  late String name;
  bool isUpdated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameUpdate();
  }

  @override
  Widget build(BuildContext context) {

    var weekdays = getWeekdays(DateTime.now(), 0).getRange(1, 6).toList();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: dHeight * 251 / 932,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(
                      'assets/images/schedule_bg1.jpg',
                      height: dHeight * 251 / 932,
                      width: dWidth,
                      fit: BoxFit.fill,
                      color: Color.fromARGB(128, 255, 255, 255),
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(isUpdated ? 'Hi $name!' : 'updating..',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 50,
                            fontFamily: 'Overlock_SC',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Center(
                        child: Text('SCHEDULE',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                              fontFamily: 'Overlock_SC',
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            ...List.generate(weekdays.length, (idx){
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: idx + 1 == selected_weekday ? Color.fromARGB(161, 255, 254, 163) : Color.fromARGB(0, 255, 255, 255),
                                ),
                                onPressed: (){
                                  setState(() {
                                    selected_weekday = idx + 1;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${week[idx]}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('${weekdays[idx].day}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ],
                                )
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  )
                ]
              ),
            ),
            SizedBox(
              height: 470 / 932 * dHeight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xFFD9D9D9),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...card(blocks),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void nameUpdate() async{
    if(!isUpdated) {
      await loadData('block_info').then((val) {
        setState(() {
          name = val!.name;
          isUpdated = true;
        });
      });
    }
  }



  List<Widget> card(List<Block> bs){
    List<Widget> cTimesWidget = [];
    List<Block> cTimes = [];
    Map<CourseInfo, Course> courses = {};
    for(Block b in bs){
      for(Course c in b.courses){
        if(c.weekday == selected_weekday){
          courses[b.info] = c;
        }
      }
    }
    for(CourseInfo key in courses.keys){
      cTimes.add(
        Block(key, [courses[key]!])
      );
    }
    cTimes.sort((a, b) => a.courses!.first.start - b.courses!.first.start);
    cTimesWidget = cTimes.map(
        (block){
          var min = DateTime.now().hour * 60 + DateTime.now().minute;
          return Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 18, right: 18),
            child: SizedBox(
              height: 94 / 932 * dHeight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: selected_weekday == DateTime.now().weekday && (courses[block.info]!.start <= min && min - courses[block.info]!.start <= courses[block.info]!.duration) ? Colors.yellowAccent : Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: SizedBox(
                        width: 1 / 5 * (dWidth - 36),
                        child: Text('${block.info.location}',
                          style: TextStyle(
                              fontFamily: 'Overlock_SC',
                              fontSize: 30
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${durationToString(courses[block.info]!.start)}  ~  ${durationToString(courses[block.info]!.start + courses[block.info]!.duration)}',
                            style: TextStyle(
                                fontFamily: 'Overlock_SC',
                                fontSize: 20
                            ),
                          ),
                          Text('${block.info.courseName}',
                            style: TextStyle(
                                fontFamily: 'Overlock_SC',
                                fontSize: 20
                            ),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
    ).toList();
    return cTimesWidget;
  }


  String durationToString(int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }


}

class Block {
  CourseInfo info;
  List<Course> courses;

  Block(this.info, this.courses);


}

class Course{
  int weekday;
  int start;
  int duration;

  Course(this.weekday, this.start, this.duration);
}

class CourseInfo{
  String courseName;
  String location;

  CourseInfo(this.courseName, this.location);

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    if(other.runtimeType != CourseInfo)
      return false;
    return this.courseName == (other as CourseInfo).courseName;
  }
}
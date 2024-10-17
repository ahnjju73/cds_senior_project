import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';

import '../util/calendar.dart';

class Cafeteria extends StatefulWidget {
  const Cafeteria({super.key});

  @override
  State<Cafeteria> createState() => _CafeteriaState();
}

class _CafeteriaState extends State<Cafeteria> {
  final List<String> week = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri',];
  int selected_weekday = DateTime.now().weekday - 5 < 0 ? DateTime.now().weekday : 1;
  bool isReady = false;
  List<Menu> menus =[];

  @override
  Widget build(BuildContext context) {
    var weekdays = getWeekdays(DateTime.now(), 0).getRange(1, 6).toList();
    read();
    return !isReady ? Center(child: CircularProgressIndicator()) :
      SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ..._dayMenus(menus[selected_weekday - 1])
            ],
          ),
        ),
      )
    ;
  }

  List<Widget> _dayMenus(Menu menu){
    return List.generate(4, (index){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          width: MediaQuery.of(context).size.width / 1.1,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Text(index == 0 ? 'Breakfast' : index == 1 ? 'Afternoon Snack' : index == 2 ? 'Lunch' : 'Dinner',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Text('${menu.meals[index]}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void read() async{
    if(!isReady) {
      http.Response response = await http.get(Uri.parse(
          'https://daltonschool.kr/school_life/cafeteria3_k.php?SelectedDay=${DateFormat('yyyy-MM-dd').format(DateTime.now())}&type=weekly'));
      dom.Document doc = parser.parse(response.body);

      List<dom.Element> keywordElements = doc.querySelectorAll('th');
      for(int i in List.generate(5, (index) => index + 1)){
        menus.add(Menu(List.generate(4, (index) => keywordElements[(i - 1) * 5 + 6 + index].text.replaceAll('none', '').trim()), i));
      }
      setState(() {
        isReady = true;
      });
    }
  }

}

class Menu{
  List<String> meals;
  int weekday;

  Menu(this.meals, this.weekday);

  @override
  String toString() {
    // TODO: implement toString
    String res = '';
    for(String meal in meals)
      res += '$meal\n\n\n';
    return res;
  }
}
import 'dart:io';
import 'dart:typed_data';

import 'package:cds_class/common/const/colors.dart';
import 'package:excel/excel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

const List<String> sports_list = <String> ['SOCCER BOYS', 'SOCCER GIRLS', 'BASKETBALL BOYS', 'BASKETBALL GIRLS', 'VOLLEYBALL BOYS', 'VOLLEYBALL GIRLS'];
final months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String dropDownVal = sports_list[0];
  List<Game> pastGames = [];
  List<Game> upcomingGames = [];
  List<Team> teams = [];
  int currentPageIndex = 0;
  int bottomIndex = 0;
  bool isStart = false;
  bool isLoaded = false;
  bool isCatChanged = true;
  late final dWidth = MediaQuery.of(context).size.width;
  late final dHeight = MediaQuery.of(context).size.height;
  var appDocDir;

  // 웹 페이지를 여는 함수
  void _launchURL(Uri _url) async {
    try {
      if (await canLaunchUrl(_url)) {
        await launchUrl(_url,
          mode: LaunchMode.inAppWebView
        );
      } else {
        throw 'Could not launch $_url';
      }
    } catch (e) {
      print("Error launching URL: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to open URL: $e")),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    readExcel(dropDownVal);
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Theme(
              data: Theme.of(context).copyWith(
                  canvasColor: MAIN_COLOR
              ),
              child: DropdownButton<String>(
                underline: SizedBox.shrink(),
                value: dropDownVal,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
                items: sports_list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropDownVal = value!;
                    isCatChanged = true;
                  });
                },
              ),
            ),
          ),
          Container(
            child: NavigationBar(
              height: 40,
              backgroundColor: MAIN_COLOR,
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              indicatorColor: SUB_COLOR,
              selectedIndex: currentPageIndex,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              destinations: const <Widget>[
                NavigationDestination(
                  icon: Icon(Icons.av_timer_outlined, color: Colors.white, size: 40,),
                  label: 'Past',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_month, color: Colors.white, size: 40,),
                  label: 'upcoming',
                ),
                NavigationDestination(
                  icon: ImageIcon(
                    AssetImage('assets/images/ranking.png'),
                    color: Colors.white,
                    size: 45,
                  ),
                  label: 'stands',
                ),
              ],
            ),
          ),
          isLoaded && !isCatChanged ? currentPageIndex == 0 ? _game_list_view(pastGames, true) :
          currentPageIndex == 1 ? _game_list_view(upcomingGames, false) :
          SingleChildScrollView(child: _standings(teams), scrollDirection: Axis.horizontal,) : // change to standing page
          Padding(
            padding: const EdgeInsets.only(top: 48.0),
            child: CircularProgressIndicator(color: Colors.white,),
          )
        ],
      ),
    );
  }


  void readExcel(String category) async {
    if(isCatChanged) {
      setState(() {
        isStart = true;
      });
      category = category.replaceFirst(' ', '_');
      final storageRef = FirebaseStorage.instance.ref();
      final scheduleUrl = await storageRef.child("${category}/schedule.xlsx").getDownloadURL();
      final standingUrl = await storageRef.child("${category}/standing.xlsx").getDownloadURL();
      appDocDir = await getApplicationDocumentsDirectory();
      await Directory('${appDocDir.absolute.path}/$category').create();
      final schedulePath = "${appDocDir.absolute.path}/$category/schedule.xlsx";
      final standingPath = "${appDocDir.absolute.path}/$category/standing.xlsx";
      final http.Response sRes = await http.get(Uri.parse(scheduleUrl));
      if (sRes.statusCode == 200) {
        final scheduleFile = File(schedulePath);
        await scheduleFile.writeAsBytes(sRes.bodyBytes);
      } else {
        throw 'Failed to download schedule file: ${sRes.statusCode}';
      }

      // 순위표 파일 다운로드 및 저장
      final http.Response stRes = await http.get(Uri.parse(standingUrl));
      if (stRes.statusCode == 200) {
        final standingFile = File(standingPath);
        await standingFile.writeAsBytes(stRes.bodyBytes);
        print('Standing file downloaded and saved at: $standingPath');
      } else {
        throw 'Failed to download standing file: ${stRes.statusCode}';
      }
      File scheduleFile = File(schedulePath);
      File standingFile = File(standingPath);

      // 파일을 바이트 데이터로 읽음
      Uint8List scBytes = await scheduleFile.readAsBytes();
      Uint8List stBytes = await standingFile.readAsBytes();

      // Excel 파일로 디코딩
      var scExcel = Excel.decodeBytes(scBytes);
      var stExcel = Excel.decodeBytes(stBytes);

      // 데이터 초기화
      upcomingGames = [];
      pastGames = [];
      teams = [];


      for (var table in scExcel.tables.keys) {
        for (var row in scExcel.tables[table]!.rows) {
          if (row[0]!.value.runtimeType == DateCellValue || row[0]!.value.runtimeType == TextCellValue) {
            var gameDate = row[0]!.value.runtimeType == TextCellValue ? DateFormat('yyyy-MMM-d').parse('${DateTime.now().year}-${row[0]!.value.toString().replaceAll(' ', '-')}') : null;
            DateCellValue? date = row[0]!.value.runtimeType == DateCellValue ? row[0]!.value as DateCellValue? : DateCellValue(year: gameDate!.year, month: gameDate.month, day: gameDate.day);
            if (row[1]?.value != null) {
              DateTime gameDate = date!.asDateTimeLocal();
              Game game = Game(gameDate,
                  row.length < 3 || row[2]?.value == null ? -1 : int.parse(row[2]!.value.toString()),
                  row.length < 3 || row[3]?.value == null ? -1 : int.parse(row[3]!.value.toString()),
                  row[1]!.value.toString().contains('@') ? row[1]!.value.toString().replaceAll('(F)', '').replaceAll('@', '').trim() : 'CDS',
                  row[1]!.value.toString().contains('@') ? 'CDS' : row[1]!.value.toString().replaceAll('(F)', '').replaceAll('@', '').trim()
              );
              if (DateTime.now().isBefore(gameDate)) {
                upcomingGames.add(game);
              } else {
                pastGames.add(game);
              }
            }
          }
        }
      }
      //순위파일
      for (var table in stExcel.tables.keys) {
        for (int r = 1; r < stExcel.tables[table]!.rows.length; r++) {
          var row = stExcel.tables[table]!.rows[r];
          if(dropDownVal.contains('SOCCER')){
            String teamName = row[0]!.value.toString();
            int win = int.parse(row[2]!.value.toString());
            int lose = int.parse(row[3]!.value.toString());
            int tie = int.parse(row[4]?.value.toString() ?? '0');
            int goals = int.parse(row[6]!.value.toString());
            int goalsAgainst = int.parse(row[7]!.value.toString());
            var team = Team(teamName: teamName, category: dropDownVal, win: win, lose: lose, tie: tie, goalGain: goals, goalAgainst: goalsAgainst);
            team.calculatePts();
            teams.add(team);
          }else if(dropDownVal.contains('BASKETBALL')){
            String teamName = row[0]!.value.toString();
            int win = int.parse(row[1]!.value.toString());
            int lose = int.parse(row[2]!.value.toString());
            int goals = int.parse(row[4]!.value.toString());
            int goalsAgainst = int.parse(row[5]!.value.toString());
            var team = Team(category: dropDownVal, teamName: teamName, win: win, lose: lose, tie: 0, goalGain: goals, goalAgainst: goalsAgainst);
            teams.add(team);
          }else{
            String teamName = row[0]!.value.toString();
            int win = int.parse(row[1]!.value.toString());
            int lose = int.parse(row[2]!.value.toString());
            int setWin = int.parse(row[4]!.value.toString());
            int setLose = int.parse(row[5]!.value.toString());
            var team = Team(category: dropDownVal, teamName: teamName, win: win, lose: lose, tie: 0, setWins: setWin, setLoses: setLose);
            teams.add(team);
          }
        }
      }

      // teams.sort((a, b) =>  b.point! - a.point!);
      setState(() {
        isStart = false;
        isLoaded = true;
        isCatChanged = false;
      });
    }
  }

  Widget _game_list_view(List<Game> games, bool isPast){
    return Expanded(
      child: SingleChildScrollView(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 10, bottom: 5),
          shrinkWrap: true,
          children: getGameList(games, isPast),
        ),
      ),
    );
  }

  Widget _standings(List<Team> teams){
    return teams[0].category.contains('SOCCER') ? _soccer_stand(teams) : teams[0].category.contains('BASKETBALL') ? _basketball_stand(teams) : _volley_stand(teams);
  }

  Widget _soccer_stand(List<Team> teams){
    return DataTable(
      columns: [
        DataColumn(label: Text('rank',
          style: TextStyle(
              color: Colors.white
          ),
        )),
        DataColumn(label: Text('team',
          style: TextStyle(
              color: Colors.white
          ),
        )),
        DataColumn(label: Text('win',
          style: TextStyle(
              color: Colors.white
          ),
        )),
        DataColumn(label: Text('lose',
          style: TextStyle(
              color: Colors.white
          ),
        )),
        DataColumn(label: Text('tie',
          style: TextStyle(
              color: Colors.white
          ),
        )),
        DataColumn(label: Text('GD',
          style: TextStyle(
              color: Colors.white
          ),
        )),
      ],
      rows: List.generate(teams.length, (i) =>
          DataRow(cells: [
            DataCell(Text('${i + 1}',
              style: TextStyle(
                  color: Colors.white
              ),
            )),
            DataCell(Text('${teams[i].teamName}',
              style: TextStyle(
                  color: Colors.white
              ),
            )),
            DataCell(Text('${teams[i].win}',
              style: TextStyle(
                  color: Colors.white
              ),
            )),
            DataCell(Text('${teams[i].lose}',
              style: TextStyle(
                  color: Colors.white
              ),
            )),
            DataCell(Text('${teams[i].tie}',
              style: TextStyle(
                  color: Colors.white
              ),
            )),
            DataCell(Text('${teams[i].goalGain! - teams[i].goalAgainst!}',
              style: TextStyle(
                  color: Colors.white
              ),
            )),
          ])
      ),
    );
  }

  Widget _basketball_stand(List<Team> teams){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1.2,
      child: DataTable(
        columns: [
          DataColumn(label: Text('rank',
            style: TextStyle(
                color: Colors.white
            ),
          )),
          DataColumn(label: Text('team',
            style: TextStyle(
                color: Colors.white
            ),
          )),
          DataColumn(label: Text('win',
            style: TextStyle(
                color: Colors.white
            ),
          )),
          DataColumn(label: Text('lose',
            style: TextStyle(
                color: Colors.white
            ),
          )),
          DataColumn(label: Text('game pct',
            style: TextStyle(
                color: Colors.white
            ),
          )),
          DataColumn(label: Text('GD',
            style: TextStyle(
                color: Colors.white
            ),
          )),
        ],
        rows: List.generate(teams.length, (i) =>
            DataRow(cells: [
              DataCell(Text('${i + 1}',
                style: TextStyle(
                    color: Colors.white
                ),
              )),
              DataCell(Text('${teams[i].teamName}',
                style: TextStyle(
                    color: Colors.white
                ),
              )),
              DataCell(Text('${teams[i].win}',
                style: TextStyle(
                    color: Colors.white
                ),
              )),
              DataCell(Text('${teams[i].lose}',
                style: TextStyle(
                    color: Colors.white
                ),
              )),
              DataCell(Text('${teams[i].win / (teams[i].win + teams[i].lose)}',
                style: TextStyle(
                    color: Colors.white
                ),
              )),
              DataCell(Text('${teams[i].goalGain! - teams[i].goalAgainst!}',
                style: TextStyle(
                    color: Colors.white
                ),
              )),
            ])
        ),
      ),
    );
  }

  Widget _volley_stand(List<Team> teams){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1.2,
      child: DataTable(
        columnSpacing: 30,
        columns: [
          DataColumn(label: Text('rank',
            style: TextStyle(
                color: Colors.white
            ),
          )),
          DataColumn(label: Text('team',
            style: TextStyle(
                color: Colors.white
            ),
          )),
          DataColumn(label: Text('win',
            style: TextStyle(
                color: Colors.white
            ),
          )),
          DataColumn(label: Text('lose',
            style: TextStyle(
                color: Colors.white
            ),
          )),
          DataColumn(label: Text('set wins',
            style: TextStyle(
                color: Colors.white
            ),
          )),
          DataColumn(label: Text('set loses',
            style: TextStyle(
                color: Colors.white
            ),
          )),
        ],
        rows: List.generate(teams.length, (i) =>
            DataRow(cells: [
              DataCell(Text('${i + 1}',
                style: TextStyle(
                    color: Colors.white
                ),
              )),
              DataCell(Text('${teams[i].teamName}',
                style: TextStyle(
                    color: Colors.white
                ),
              )),
              DataCell(Text('${teams[i].win}',
                style: TextStyle(
                    color: Colors.white
                ),
              )),
              DataCell(Text('${teams[i].lose}',
                style: TextStyle(
                    color: Colors.white
                ),
              )),
              DataCell(Text('${teams[i].setWins}',
                style: TextStyle(
                    color: Colors.white
                ),
              )),
              DataCell(Text('${teams[i].setLoses}',
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
            ])
        ),
      ),
    );
  }

  List<Widget> getGameList(List<Game> games, bool isPast){
    List<Widget> gameWidgets = [];
    for (int i = 0; i < games.length; i++) {
      gameWidgets.add(
          isPast ? _pastGameView(games[i]) : _upcomingGameView(games[i], i)
      );
    }
    // gameWidgets = List.from(gameWidgets.reversed);
    return gameWidgets;
  }

  Widget _pastGameView(Game game) {
    File? home = File('${appDocDir.absolute.path}/logos/${game.home}.png').existsSync()? File('${appDocDir.absolute.path}/logos/${game.home}.png') : null;
    File? away = File('${appDocDir.absolute.path}/logos/${game.away}.png').existsSync()? File('${appDocDir.absolute.path}/logos/${game.away}.png') : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0, left: 12, right: 12),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text('${game.date.year} - ${months[game.date.month - 1]} - ${game.date.day.toString().padLeft(2, '0')}',
                style: TextStyle(
                    fontFamily: 'Nova_Square',
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  home == null ?
                    Column(
                      children: [
                        Image.asset('assets/images/no_img.png', width: dWidth / 4.5,),
                        Text('${game.home}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontFamily: 'Nova_Square',
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ) :
                    Image.file(home, width: dWidth / 4,),
                  game.isTie() ?
                  Text(game.home_score == -1 ? '' : 'TIE',
                    style: TextStyle(
                        fontFamily: 'Nova_Square',
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                    ),
                  ):
                  Column(
                    children: [
                      Text('${game.homeWins() ? 'HOME' : 'AWAY'}',
                        style: TextStyle(
                            fontFamily: 'Nova_Square',
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text('WINS',
                        style: TextStyle(
                            fontFamily: 'Nova_Square',
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  away == null ?
                    Column(
                      children: [
                        Image.asset('assets/images/no_img.png', width: dWidth / 4.5,),
                        Text('${game.away}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontFamily: 'Nova_Square',
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ) :
                    Image.file(away, width: dWidth / 4,),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                child: Text(game.home_score == -1 ? 'UPDATING...' : '${game.home_score}    :    ${game.away_score}',
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'Overlock_SC',
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _upcomingGameView(Game game, int index) {
    File home = File('${appDocDir.absolute.path}/logos/${game.home}.png');
    File away = File('${appDocDir.absolute.path}/logos/${game.away}.png');
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0, left: 12, right: 12),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  home == null ?
                  Column(
                    children: [
                      Image.asset('assets/images/no_img.png', width: dWidth / 4,),
                      Text('${game.home}',
                        style: TextStyle(
                            fontFamily: 'Nova_Square',
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ) :
                  Image.file(home, width: dWidth / 3.5,),
                  Column(
                    children: [
                      Text('${game.date.year}',
                        style: TextStyle(
                            fontFamily: 'Nova_Square',
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text('${months[game.date.month - 1]}',
                        style: TextStyle(
                            fontFamily: 'Nova_Square',
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text('${game.date.day.toString().padLeft(2, '0')}',
                        style: TextStyle(
                            fontFamily: 'Nova_Square',
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  away == null ?
                  Column(
                    children: [
                      Image.asset('assets/images/no_img.png', width: dWidth / 4,),
                      Text('${game.away}',
                        style: TextStyle(
                            fontFamily: 'Nova_Square',
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ) :
                  Image.file(away, width: dWidth / 3.5,),
                ],
              ),
            ),
            //vote Url
            index == 0 ?
                dropDownVal.contains('SOCCER') ?
                webOpen('soccer') : dropDownVal.contains('VOLLEY') ?
                webOpen('volleyball') :
                webOpen('basketball') :
                Container()
          ],
        ),
      ),
    );
  }

  Widget webOpen(String game){
    final url = Uri.parse(game.contains('soccer') ? 'https://forms.gle/7qNPfJETxJ9Qxx5k9' : game.contains('volley') ? 'https://forms.gle/qWoPsjmjJxeNR3ku5' : 'https://forms.gle/UF18nUq6cv1jPPwi9');
    return InkWell(
      onTap: (){
        print('clicked!');
        _launchURL(url);
        },  // 텍스트 클릭 시 웹 페이지 열기
      child: Text(
        'Move Vote ${game.toUpperCase()} Page',
        style: TextStyle(
          fontSize: 18,
          color: Colors.blue,
          decoration: TextDecoration.underline, // 밑줄 표시
        ),
      ),
    );
  }

}

class Game{
  DateTime date;
  int home_score;
  int away_score;
  String home;
  String away;

  Game(this.date, this.home_score, this.away_score, this.home, this.away);

  @override
  String toString() {
    // TODO: implement toString
    return '$date  $home: $home_score $away: $away_score\n';
  }

  isTie() => home_score == away_score;
  homeWins() => home_score > away_score;
  winTeam() => home_score > away_score ? home : away;
}

class Team{
  String category;
  String teamName;
  int? point;
  int win;
  int lose;
  int tie;
  int? setWins;
  int? setLoses;
  int? goalGain;
  int? goalAgainst;


  Team({
    required this.category,
    required this.teamName,
    required this.win,
    required this.lose,
    required this.tie,
    this.goalGain,
    this.goalAgainst,
    this.setWins,
    this.setLoses,

  });

  @override
  String toString() {
    // TODO: implement toString
    return '$teamName\nwin: $win lost: $lose pt gain: $goalGain pt lose: $goalAgainst';
  }

  void calculatePts(){
    if(category.contains('SOCCER')){
      point = 3 * win + tie;
    }else if(category.contains('BASKETBALL')){
      point = win - lose;
    }else{
      point = win - lose;
    }
  }
}
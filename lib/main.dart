import 'dart:async';
import 'dart:io';

import 'package:cds_class/account/page/InfoRegPage.dart';
import 'package:cds_class/account/page/home_page.dart';
import 'package:cds_class/account/util/info_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      home: Splash(),
    )
  );
}

class Splash extends StatefulWidget {
  const Splash({super.key, });

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // This widget is the root of your application.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateLogos();

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 10,
              ),
              Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Image.asset('assets/images/logo_center.png'),
                  )
              ),
              // const CircularProgressIndicator(color: Colors.red,),
              Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: Image.asset('assets/images/logo_bottom.png'),
                  )
              ),
            ],
          )
      ),
    );
  }


  void updateLogos() async{
    final storageRef = FirebaseStorage.instance.ref().child('logos/');
    final listResult = await storageRef.listAll();
    for (var item in listResult.items) {
      // The items under storageRef.
      final imageUrl = await item.getDownloadURL();
      final appDocDir = await getApplicationDocumentsDirectory();
      await Directory('${appDocDir.absolute.path}/logos').create();
      final filePath = "${appDocDir.absolute.path}/logos/${item.name}";
      final http.Response response = await http.get(Uri.parse(imageUrl));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
    }

    // final imageUrl = await storageRef.child("").getDownloadURL();
    // final appDocDir = await getApplicationDocumentsDirectory();
    // await Directory('${appDocDir.absolute.path}/logos').create();

    await loadData('block_info').then((val){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => val == null ? InfoRegPage() : HomePage(val)
      ));
    });
  }

}











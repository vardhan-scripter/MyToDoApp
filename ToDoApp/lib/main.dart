import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todotask/screens/homepage.dart';
import 'package:todotask/screens/task_save_dialog.dart';
import 'package:todotask/model/taskdata.dart';
import 'package:todotask/screens/loginpage.dart';
import 'package:get_it/get_it.dart';
import 'package:todotask/services/authservice.dart';
import 'package:todotask/utils/constants.dart';

void setup(){
  GetIt.I.registerLazySingleton<AuthService>(() => AuthService());
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final getDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(getDocumentDirectory.path);
  Hive.registerAdapter(TaskDataAdapter());
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: LoginPage(),

    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(onPressed: (){
        }),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hii'),
      ),
      body: Center(
        child: RaisedButton(onPressed: (){
          SystemNavigator.pop();
        }),
      ),
    );
  }
}






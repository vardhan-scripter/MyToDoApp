
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:todotask/components/customalertdialog.dart';
import 'package:todotask/model/apiresponse.dart';
import 'package:todotask/model/getTaskData.dart';
import 'package:todotask/screens/task_save_dialog.dart';
import 'package:todotask/services/authservice.dart';
import 'package:get_it/get_it.dart';
import 'package:todotask/utils/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //get the instance for the AuthService from (getIt)
  AuthService _authService = GetIt.I<AuthService>();

  //get the instance for apiResponse
  ApiResponse<List<GetTaskData>> _getTaskListItems;
  ApiResponse<bool> _deleteResponse, _toggleResponse;
  Color colorTheme = Color.fromRGBO(73, 83, 153, 1);

  //variable
  int totalTasks;

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
  //logic for back Press button
  Future<bool> _onBackPressed() async{
    return await showDialog(context: context,
        builder: (context){
          return CupertinoAlertDialog(
            title: Text('Alert',style: kTaskTextStyle.copyWith(
                color: Colors.amber[800],
                fontSize: 18.0,
                fontWeight: FontWeight.bold
            ),),
            content: Text('Do you really want to exit the app'),
            actions: <Widget>[
              FlatButton(onPressed: (){
                Navigator.pop(context,false);
              }, child: Text('No')),
              FlatButton(onPressed: (){
                SystemNavigator.pop();
              }, child: Text('Yes')),
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: ClipperClass(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.deepPurple.withOpacity(0.8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30, bottom: 10, left: 6, right: 6),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              child: Icon(
                                Icons.format_list_bulleted,
                                color: colorTheme,
                              ),
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            StreamBuilder<Object>(
                              stream: _authService.getTodoListItems(),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  ApiResponse<List<GetTaskData>> taskData = snapshot.data;
                                  return Text(
                                    'Total todo\'s ${taskData.data.length}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600),
                                  );
                                }else{
                                  return Text(
                                    'todo\'s ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600),
                                  );
                                }

                              }
                            ),
                          ],
                        ),
                        Spacer(),
                        ActionChip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.deepPurple.withOpacity(0.7),
                              child: Icon(
                                Icons.power_settings_new,
                                color: Colors.white,
                              ),
                            ),
                            label: Text('Exit'),
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return CustomAlertDialog(
                                      onPressed: () async {
                                        SharedPreferences _prefs =
                                            await SharedPreferences.getInstance();
                                        _prefs.clear();
                                        // ignore: deprecated_member_use
                                        _prefs.commit();
                                        Navigator.pop(context, true);
                                      },
                                      alertMessage:
                                          'Do you really want to logout',
                                    );
                                  }).then((logout) {
                                if (logout) {
                                  Navigator.pop(context);
                                }
                              });
                            }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: _authService.getTodoListItems(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.active:
                            case ConnectionState.waiting:
                              return SpinKitChasingDots(
                                color: colorTheme,
                                size: 50,
                              );
                            case ConnectionState.done:
                              if (snapshot.hasData) {
                                _getTaskListItems = snapshot.data;
                                return ListView.builder(
                                    itemCount: _getTaskListItems?.data?.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 6.0, horizontal: 10.0),
                                        elevation: 5.0,
                                        color: Colors.green[50],
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0.0, vertical: 6.0),
                                          child: ListTile(
                                            title: Text(
                                              _getTaskListItems.data[index].name,
                                              style: kTaskTextStyle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0),
                                            ),
                                            subtitle: Text(
                                              DateFormat.yMMMMd().format(
                                                  DateTime.parse(_getTaskListItems
                                                      .data[index].date)),
                                              style: kTaskTextStyle,
                                            ),
                                            leading: Checkbox(
                                                checkColor: Colors.white,
                                                activeColor: Colors.deepPurple.withOpacity(0.7),
                                                value: _getTaskListItems.data[index].done, onChanged: (newValue) async{
                                              _toggleResponse = await _authService.updateToggle(itemId: _getTaskListItems.data[index].sId);
                                              if(_toggleResponse.data){
                                                setState(() {
                                                });
                                              }else{
                                                Toast.show('${_toggleResponse.message}', context);
                                              }
                                            }),
                                            trailing: IconButton(
                                                icon: Icon(
                                                  Icons.cancel,
                                                  size: 32,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () async {
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return CustomAlertDialog(
                                                          onPressed: () async {
                                                            _deleteResponse = await _authService.deleteTodoItem(itemId: _getTaskListItems.data[index].sId);
                                                            if (_deleteResponse.data) {
                                                              Navigator.pop(context, true);
                                                            } else {
                                                              Toast.show('${_deleteResponse.message}', context);
                                                              Navigator.pop(context, false);
                                                            }
                                                          },
                                                          alertMessage:
                                                          'Do you really want to delete?',
                                                        );
                                                      }).then((isDeleted) {
                                                    if (isDeleted) {
                                                      setState(() {});
                                                    }
                                                  });
                                                }),
                                            onTap: () {
                                              //edit text dialog
                                              showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return TaskSaveDialog(
                                                      indexId: _getTaskListItems
                                                          .data[index].sId,
                                                    );
                                                  }).then((result) {
                                                if (result) {
                                                  setState(() {});
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                return Center(
                                  child: Text(
                                    'You don\'t have any todo\'s yet',
                                    style: kTaskTextStyle,
                                  ),
                                );
                              }
                          }
                          return null;
                        }),
                  )
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple.withOpacity(0.7),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return TaskSaveDialog();
                }).then((result) {
              if (result) {
                setState(() {});
              }
            });
          },
          child: Icon(
            Icons.edit,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  IconData getIcon(bool status) {
    if (!status) {
      return Icons.info_outline;
    } else {
      return Icons.check_circle;
    }
  }

  Color getColor(bool status) {
    if (!status) {
      return Colors.amber;
    } else {
      return Colors.green;
    }
  }

//  String getTime(String timeStamp) {
//    DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(timeStamp);
//    String date = DateFormat("yyyy-MM-dd hh:mm:ss").format(tempDate);
//    var formatter = DateFormat('yyyy-mm-dd EEEEE');
//    var dateTime =
//        new DateTime.fromMicrosecondsSinceEpoch(int.parse(timeStamp));
//    String time = formatter.format(dateTime);
//    return date;
//  }
}


class ClipperClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height / 4);
    path.quadraticBezierTo(
        3, size.height / 6.2, size.width / 6, size.height / 6.2);
    // path.quadraticBezierTo(size.width-(size.width/28), size.height/6, size.width, size.height/8.2);
    path.lineTo(size.width, size.height / 6.2);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}



import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:toast/toast.dart';
import 'package:todotask/components/customtextformfield.dart';
import 'package:todotask/model/apiresponse.dart';
import 'package:todotask/model/getTaskData.dart';
import 'package:todotask/model/insertTaskData.dart';
import 'package:todotask/model/taskdata.dart';
import 'package:todotask/services/authservice.dart';
import 'package:todotask/utils/constants.dart';
import 'package:get_it/get_it.dart';

class TaskSaveDialog extends StatefulWidget {
  final TaskData taskData;
  final String indexId;

  TaskSaveDialog({this.taskData, this.indexId});

  @override
  _TaskSaveDialogState createState() => _TaskSaveDialogState();
}

class _TaskSaveDialogState extends State<TaskSaveDialog> {
  Color colorTheme= Color.fromRGBO(73, 83, 153, 1);
  //task status
  final coffeeNames = ['pending', 'completed'];
  final _formKey = GlobalKey<FormState>();

  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEditing = false;
  TaskData task;
  //String taskStatus;
  bool isError=false;
  //loading indicator
  bool isLoading = false;

  //get the instance of the AuthService from (getIt)
  AuthService _authService = GetIt.I<AuthService>();
  //get the instance for the ApiResponse
  ApiResponse<bool> _insertResponse,_updateResponse;
  ApiResponse<GetTaskData> _getTaskDataResponse;



  @override
  void initState() {
    super.initState();
    if (widget.indexId != null) {
      isEditing = true;
      _getTodoItem();
      //task = widget.taskData;
     // taskStatus = task.status;
     // taskNameController.text = task.taskName;
      // statusController.text = task.status;
      //taskStatus = task.status;
    } else {
      //taskStatus = null;
    }
  }

  _getTodoItem() async{
    setState(() {
      isLoading = true;
    });
    _getTaskDataResponse = await _authService.getTodoItem(itemId: widget.indexId);
    taskNameController.text = _getTaskDataResponse.data.name;
    descriptionController.text = _getTaskDataResponse.data.description;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 30.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: isLoading ? Center(child: SpinKitChasingDots(
          color: colorTheme,
          size: 50.0,
        )) : Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                isEditing ? 'Editing the Task' : 'Create New Task',
                style: TextStyle(
                    color: Colors.indigoAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Container(
                  height: isError?70:50,
                  child: TextFormField(
                      controller: taskNameController,
                      validator: (taskName) =>
                          taskName.isEmpty ? 'please enter task' : null,
                      style: kTaskTextStyle,
                      decoration:
                          kTaskTextFormField.copyWith(labelText: 'Title')),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 15.0),
                child: Container(
                  height: 155.0,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 4,
                    maxLines: null,
                    controller: descriptionController,
                      validator: (taskName) =>
                          taskName.isEmpty ? 'Please Enter desciption' : null,
                      style: kTaskTextStyle,
                      decoration:
                          kTaskTextFormField.copyWith(labelText: 'Description'),
                          ),
                ),
              ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.03,
            ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    MaterialButton(
                      color: Colors.orange[50],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12.0),
                        child: Text(
                          'Cancle',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    MaterialButton(
                        color: Colors.green[50],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 12.0),
                          child: Text(
                            isEditing?'Update':'Save',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () async{
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            if (widget.indexId != null) {
                              InsertTaskData taskData = InsertTaskData(name: taskNameController.text,description: descriptionController.text);
                              _updateResponse = await _authService.updateTodo(taskData:taskData, itemId:_getTaskDataResponse.data.sId);
                              if(_updateResponse.data){
                                Toast.show('${_updateResponse.message}', context);
                                Navigator.pop(context,true);
                              }else{
                                Toast.show('${_updateResponse.message}', context);
                                Navigator.pop(context,false);
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              InsertTaskData taskData = InsertTaskData(name: taskNameController.text,description: descriptionController.text);
                             _insertResponse =  await _authService.insertNewTodo(taskData:taskData);
                             if(_insertResponse.data){
                               Toast.show('${_insertResponse.message}', context);
                               Navigator.pop(context,true);
                             }else{
                               Toast.show('${_insertResponse.message}', context);
                               Navigator.pop(context,false);
                             }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }else{
                            setState(() {
                              isError = !isError;
                            });
                          }
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

//  void saveTask(TaskData task) {
//    // print('Task Name:${task.taskName}');
//    final taskBox = Hive.box('todo');
//    taskBox.add(task);
//  }
//
//  void updateTask(TaskData task) {
//    final taskBox = Hive.box('todo');
//    taskBox.putAt(int.parse(widget.indexId), task);
//  }
//
//  void updateTitle() {
//    task.taskName = taskNameController.text;
//  }
}

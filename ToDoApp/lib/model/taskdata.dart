import 'package:hive/hive.dart';
part 'taskdata.g.dart';
@HiveType(typeId: 0)
class TaskData{
  @HiveField(0)
  String taskName;
  @HiveField(1)
  String status;
  TaskData({this.taskName, this.status});
}
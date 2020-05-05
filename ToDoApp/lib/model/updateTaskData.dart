
class UpdateTaskData {
  String _id;
  String name;
  String description;

  UpdateTaskData(this._id,{this.name, this.description});

  UpdateTaskData.fromJson(Map<String, dynamic> json) {
    _id = json['_id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this._id;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
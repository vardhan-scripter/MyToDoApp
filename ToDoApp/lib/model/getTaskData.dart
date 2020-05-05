
class GetTaskData {
  bool done;
  String date;
  String sId;
  String name;
  String description;
  String email;
  int iV;

  GetTaskData(
      {this.done,
        this.date,
        this.sId,
        this.name,
        this.description,
        this.email,
        this.iV});

  GetTaskData.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    date = json['date'];
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    email = json['email'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['done'] = this.done;
    data['date'] = this.date;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['email'] = this.email;
    data['__v'] = this.iV;
    return data;
  }

}
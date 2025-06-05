class BeginnerLessonsModel {
  List<BeginnerLessonModel>? beginnerLessons;
  bool? success;

  BeginnerLessonsModel({this.beginnerLessons, this.success});

  BeginnerLessonsModel.fromJson(Map<String, dynamic> json) {
    if (json['beginnerLessons'] != null) {
      beginnerLessons = <BeginnerLessonModel>[];
      json['beginnerLessons'].forEach((v) {
        beginnerLessons!.add(new BeginnerLessonModel.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.beginnerLessons != null) {
      data['beginnerLessons'] =
          this.beginnerLessons!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class BeginnerLessonModel {
  String? sId;
  int? index;
  String? level;
  String? title;
  String? description;
  List<String>? content;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? status;

  BeginnerLessonModel({
    this.sId,
    this.index,
    this.level,
    this.title,
    this.description,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.status,
  });

  BeginnerLessonModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    index = json['index'];
    level = json['level'];
    title = json['title'];
    description = json['description'];
    content = json['content'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['index'] = this.index;
    data['level'] = this.level;
    data['title'] = this.title;
    data['description'] = this.description;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['status'] = this.status;
    return data;
  }
}

class LessonsModel {
  List<LessonModel>? lessons;
  bool? success;

  LessonsModel({this.lessons, this.success});

  LessonsModel.fromJson(Map<String, dynamic> json) {
    if (json['lessons'] != null) {
      lessons = <LessonModel>[];
      json['lessons'].forEach((v) {
        lessons!.add(LessonModel.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (lessons != null) {
      data['lessons'] = lessons!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class LessonModel {
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

  LessonModel({
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

  LessonModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['index'] = index;
    data['level'] = level;
    data['title'] = title;
    data['description'] = description;
    data['content'] = content;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['status'] = status;
    return data;
  }
}

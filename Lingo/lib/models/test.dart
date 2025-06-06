class TestModel {
  String? sId;
  String? title;
  String? description;
  List<Questions>? questions;
  int? iV;

  TestModel({this.sId, this.title, this.description, this.questions, this.iV});

  TestModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['title'] = title;
    data['description'] = description;
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    data['__v'] = iV;
    return data;
  }
}

class Questions {
  String? questionText;
  List<String>? options;
  String? correctAnswer;
  String? sId;

  Questions({this.questionText, this.options, this.correctAnswer, this.sId});

  Questions.fromJson(Map<String, dynamic> json) {
    questionText = json['questionText'];
    options = json['options'].cast<String>();
    correctAnswer = json['correctAnswer'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['questionText'] = questionText;
    data['options'] = options;
    data['correctAnswer'] = correctAnswer;
    data['_id'] = sId;
    return data;
  }
}

class Answer {
  String? questionId;
  String? selectedAnswer;

  Answer({required this.questionId, required this.selectedAnswer});

  Answer.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    selectedAnswer = json['selectedAnswer'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['questionId'] = questionId;
    json['selectedAnswer'] = selectedAnswer;
    return json;
  }
}

class TestsWithStatus {
  List<TestWithStatus>? tests;
  bool? success;

  TestsWithStatus({this.tests, this.success});

  TestsWithStatus.fromJson(Map<String, dynamic> json) {
    if (json['availableTests'] != null) {
      tests = <TestWithStatus>[];
      json['availableTests'].forEach((v) {
        tests!.add(TestWithStatus.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['availableTests'] = tests?.map((test) {
      return test.toJson();
    });
    return json;
  }
}

class TestWithStatus {
  String? id;
  String? title;
  String? description;
  bool? attempted;

  TestWithStatus({this.id, this.title, this.description, this.attempted});

  TestWithStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    attempted = json['attempted'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['title'] = title;
    json['description'] = description;
    json['attempted'] = attempted;
    return json;
  }
}

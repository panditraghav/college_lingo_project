class ReportModel {
  List<TestReports>? testReports;
  bool? success;

  ReportModel({this.testReports, this.success});

  ReportModel.fromJson(Map<String, dynamic> json) {
    if (json['testReports'] != null) {
      testReports = <TestReports>[];
      json['testReports'].forEach((v) {
        testReports!.add(new TestReports.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.testReports != null) {
      data['testReports'] = this.testReports!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class TestReports {
  String? testTitle;
  String? sId;
  String? attemptedAt;
  int? score;
  int? correct;
  int? incorrect;

  TestReports({
    this.testTitle,
    this.sId,
    this.attemptedAt,
    this.score,
    this.correct,
    this.incorrect,
  });

  TestReports.fromJson(Map<String, dynamic> json) {
    testTitle = json['testTitle'];
    sId = json['_id'];
    attemptedAt = json['attemptedAt'];
    score = json['score'];
    correct = json['correct'];
    incorrect = json['incorrect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['testTitle'] = this.testTitle;
    data['_id'] = this.sId;
    data['attemptedAt'] = this.attemptedAt;
    data['score'] = this.score;
    data['correct'] = this.correct;
    data['incorrect'] = this.incorrect;
    return data;
  }
}

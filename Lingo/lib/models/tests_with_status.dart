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
}

class TestWithStatus {
  String? id;
  String? title;
  String? description;
  bool? attempted;

  TestWithStatus({this.id, this.title, this.description, this.attempted});

  TestWithStatus.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    attempted = json['attempted'];
  }
}

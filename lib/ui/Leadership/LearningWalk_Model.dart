

class Learningwalknew {
  Status? status;
  Data? data;

  Learningwalknew({this.status, this.data});

  Learningwalknew.fromJson(Map<String, dynamic> json) {
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (status != null) {
      data['status'] = status!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Status {
  int? code;
  String? message;

  Status({this.code, this.message});

  Status.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}

class Data {
  String? message;
  Details? details;

  Data({this.message, this.details});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    details =
        json['details'] != null ? Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (details != null) {
      data['details'] = details!.toJson();
    }
    return data;
  }
}

class Details {
  List<Response>? response;
  List<String>? lwfocus;

  Details({this.response,this.lwfocus});

  Details.fromJson(Map<String, dynamic> json) {
    lwfocus = json['prev_focus_list'].cast<String>();
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? sId;
  String? name;
  List<Batches>? batches;

  Response({this.sId, this.name, this.batches});

  Response.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    if (json['batches'] != null) {
      batches = <Batches>[];
      json['batches'].forEach((v) {
        batches!.add(Batches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    if (batches != null) {
      data['batches'] = batches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Batches {
  String? sessionId;
  String? curriculumId;
  String? classId;
  String? batchId;
  int? batchSortOrder;
  int? classSortOrder;
  String? classs;
  String? batch;
  List<Teachers>? teachers;

  Batches(
      {this.sessionId,
      this.curriculumId,
      this.classId,
      this.batchId,
      this.batchSortOrder,
      this.classSortOrder,
      this.classs,
      this.batch,
      this.teachers});

  Batches.fromJson(Map<String, dynamic> json) {
    sessionId = json['session_id'];
    curriculumId = json['curriculum_id'];
    classId = json['class_id'];
    batchId = json['batch_id'];
    batchSortOrder = json['batch_sort_order'];
    classSortOrder = json['class_sort_order'];
    classs = json['class'];
    batch = json['batch'];
    if (json['teachers'] != null) {
      teachers = <Teachers>[];
      json['teachers'].forEach((v) {
        teachers!.add(Teachers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['session_id'] = sessionId;
    data['curriculum_id'] = curriculumId;
    data['class_id'] = classId;
    data['batch_id'] = batchId;
    data['batch_sort_order'] = batchSortOrder;
    data['class_sort_order'] = classSortOrder;
    data['class'] = classs;
    data['batch'] = batch;
    if (teachers != null) {
      data['teachers'] = teachers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Teachers {
  String? userId;
  String? name;

  Teachers({this.userId, this.name});

  Teachers.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    return data;
  }
}

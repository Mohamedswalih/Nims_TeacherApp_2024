final String tableNotes = 'Lesson';

class Lessonfields {
  static final List<String> values = [
    /// Add all fields
    id, teachername, observername,teacherid,schoolid,observerid,subjectname,subjectid,topic,classid,batchid,classname,
    academicyear,areas_for_improvement,strengths,remedial_measures,role_ids,upper_hierarchy,session_id,curriculum_id,isJoin,tempnam
  ];

  static final String id = '_id';
  static final String teachername = 'teachername';
  static final String observername = 'observername';
  static final String teacherid = 'teacherid';
  static final String schoolid = 'schoolid';
  static final String observerid = 'observerid';
  static final String subjectname = 'subjectname';
  static final String subjectid = 'subjectid';
  static final String topic = 'topic';
  static final String classid = 'classid';
  static final String batchid = 'batchid';
  static final String classname = 'classname';
  static final String academicyear = 'academicyear';
  static final String areas_for_improvement = 'areas_for_improvement';
  static final String strengths = 'strengths';
  static final String remedial_measures = 'remedial_measures';
  static final String role_ids = 'role_ids';
  static final String upper_hierarchy ='upper_hierarchy';
  static final String session_id = 'session_id';
  static final String curriculum_id = 'curriculum_id';
  static final String isJoin = "isJoin";
  static final String tempnam = 'tempname';
}

class Lesson {
  final int? id;
  final String? teachername;
  final String? teacherid;
  final String? observername;
  final String? schoolid;
  final String? observerid;
  final String? subjectname;
  final String? subjectid;
  final String? topic;
  final String? classid;
  final String? batchid;
  final String? classname;
  final String? academicyear;
  var areas_for_improvement;
  var  strengths;
  final String? remedial_measures;
  final String? role_ids;
  final String? upper_hierarchy;
  final String? session_id;
  final String? curriculum_id;
  final String? isJoin;
  final String? tempnam;


  Lesson({
    this.id,
    required this.teachername,
    required this.observername,
    this.teacherid,
    this.schoolid,
    this.observerid,
    this.subjectname,
    this.subjectid,
    this.topic,
    this.classid,
    this.batchid,
    this.classname,
    this.academicyear,
    this.areas_for_improvement,
    this.strengths,
    this.remedial_measures,
    this.role_ids,
    this.upper_hierarchy,
    this.session_id,
    this.curriculum_id,
    this.isJoin,
    this.tempnam
  });

  Lesson copy({
    int? id,
    String? teachername,
    String? observername,
    String? teacherid,
    String? schoolid,
    String? observerid,
    String? subjectname,
    String? subjectid,
    String? topic,
    String? classid,
    String? batchid,
    String? classname,
    String? academicyear,
    var areas_for_improvement,
    var strengths,
    String? remedial_measures,
    String? role_ids,
    String? upper_hierarchy,
    String? session_id,
    String? curriculum_id,
    String? isJoin,
    String? tempnam
  }) =>
      Lesson(
          id: id ?? this.id,
          teachername: teachername ?? this.teachername,
          observername: observername ?? this.observername,
          teacherid: teacherid ?? this.teacherid,
          observerid: observerid ?? this.observerid,
          schoolid: schoolid ?? this.schoolid,
          topic: topic ?? this.topic,
          subjectname: subjectname ?? this.subjectname,
          classid: classid ?? this.classid,
          batchid: batchid ?? this.batchid,
          classname: classname ?? this.classname,
          academicyear: academicyear ?? this.academicyear,
          areas_for_improvement: areas_for_improvement ?? this.areas_for_improvement,
          strengths: strengths ?? this.strengths,
          remedial_measures: remedial_measures ?? this.remedial_measures,
          role_ids:  role_ids ?? this. role_ids,
          upper_hierarchy: upper_hierarchy ?? this.upper_hierarchy,
          session_id: session_id ?? this.session_id,
          curriculum_id: curriculum_id ?? this.curriculum_id,
          isJoin: isJoin ?? this.isJoin,
          tempnam: tempnam ?? this.tempnam
      );

  static Lesson fromJson(Map<String, Object?> json) => Lesson(
      id: json[Lessonfields.id] as int?,
      teachername: json[Lessonfields.teachername] as String,
      observername: json[Lessonfields.observername] as String,
      teacherid: json[Lessonfields.teacherid] as String,
      observerid: json[Lessonfields.observerid] as String,
      schoolid: json[Lessonfields.schoolid] as String,
      subjectname: json[Lessonfields.subjectname] as String,
      subjectid: json[Lessonfields.subjectid] as String,
      topic: json[Lessonfields.topic] as String,
      classid: json[Lessonfields.classid] as String,
      batchid: json[Lessonfields.batchid] as String,
      classname: json[Lessonfields.classname] as String,
      academicyear: json[Lessonfields.academicyear] as String,
      areas_for_improvement: json[Lessonfields.areas_for_improvement] ,
      strengths: json[Lessonfields.strengths],
      remedial_measures: json[Lessonfields.remedial_measures] as String,
      role_ids:json[Lessonfields.role_ids] as String,
      upper_hierarchy: json[Lessonfields.upper_hierarchy] as String,
      session_id: json[Lessonfields.session_id] as String,
      curriculum_id: json[Lessonfields.curriculum_id] as String,
      isJoin: json[Lessonfields.isJoin] as String,
      tempnam: json[Lessonfields.tempnam] as String

  );

  Map<String, Object?> toJson() => {
    Lessonfields.id: id,
    Lessonfields.teachername: teachername,
    Lessonfields.observername: observername,
    Lessonfields.teacherid: teacherid,
    Lessonfields.observerid: observerid,
    Lessonfields.subjectname: subjectname,
    Lessonfields.subjectid: subjectid,
    Lessonfields.topic: topic,
    Lessonfields.schoolid: schoolid,
    Lessonfields.classname: classname,
    Lessonfields.classid: classid,
    Lessonfields.batchid: batchid,
    Lessonfields.academicyear: academicyear,
    Lessonfields.areas_for_improvement: areas_for_improvement,
    Lessonfields.strengths: strengths,
    Lessonfields.remedial_measures: remedial_measures,
    Lessonfields.role_ids: role_ids,
    Lessonfields.upper_hierarchy: upper_hierarchy,
    Lessonfields.session_id: session_id,
    Lessonfields.curriculum_id:  curriculum_id,
    Lessonfields.isJoin:  isJoin,
    Lessonfields.tempnam: tempnam
  };
}

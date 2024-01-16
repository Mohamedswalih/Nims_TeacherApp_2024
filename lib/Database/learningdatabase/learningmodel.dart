final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    /// Add all fields
    id,app,added_by,added_date,observation_date,teacher_name,teacher_id,school_id,class_id,batch_id,observer_roles,
    academic_year,lw_focus,qs_to_puple,session_id,curriculum_id,qs_to_teacher,what_went_well,even_better_if,notes,sender_id,
  ];

  static final String id = '_id';
  static final String academic_year = 'academic_year';
  static final String added_date = 'added_date';
  static final String observation_date = 'observation_date';
  static final String teacher_name = 'teacher_name';
  static final String teacher_id = 'teacher_id';
  static final String school_id = 'school_id';
  static final String added_by = 'added_by';
  static final String class_id = 'class_id';
  static final String batch_id = 'batch_id';
  static final String observer_roles = 'observer_roles';
  static  var lw_focus = 'lw_focus';
  static  var qs_to_puple = 'qs_to_puple';
  static  var qs_to_teacher = 'qs_to_teacher';
  static  var what_went_well = 'what_went_well';
  static  var even_better_if = 'even_better_if';
  static  var notes = 'notes';
  static final String session_id = 'session_id';
  static final String sender_id = 'sender_id';
  static final String curriculum_id = 'curriculum_id';
  static final String app = 'app';
}

class Note {
  final int? id;
  final int? app;
  final String? added_date;
  final String? observation_date;
  final String? teacher_name;
  final String? teacher_id;
  final String? school_id;
  final String? added_by;
  final String? class_id;
  final String? batch_id;
  final String? observer_roles;
  var lw_focus;
  final String? academic_year;
  var qs_to_puple;
  var qs_to_teacher;
  var what_went_well;
  var even_better_if;
  var notes;
  final String? session_id;
  final String? sender_id;
  final String? curriculum_id;


  Note({
    this.id,
    this.app,
    this.teacher_name,
    this.added_date,
    this.observation_date,
    this.teacher_id,
    this.school_id,
    this.added_by,
    this.class_id,
    this.batch_id,
    this.observer_roles,
    this.lw_focus,
    this.academic_year,
    this.qs_to_puple,
    this.qs_to_teacher,
    this.what_went_well,
    this.even_better_if,
    this.notes,
    this.session_id,
    this.sender_id,
    this.curriculum_id,
  });

  Note copy({
    int? id,
    int? app,
    String? added_date,
    String? observation_date,
    String? teacher_name,
    String? teacher_id,
    String? school_id,
    String? added_by,
    String? class_id,
    String? batch_id,
    String? observer_roles,
    var lw_focus,
    String? academic_year,
    var qs_to_puple,
    var qs_to_teacher,
    var what_went_well,
    var even_better_if,
    var notes,
    String? session_id,
    String? sender_id,
    String? curriculum_id,
  }) =>
      Note(
          id: id ?? this.id,
          app: app ?? this.app,
          teacher_name: teacher_name ?? this.teacher_name,
          added_date: added_date ?? this.added_date,
          observation_date: observation_date ?? this.observation_date,
          teacher_id: teacher_id ?? this.teacher_id,
          added_by: added_by ?? this.added_by,
          school_id: school_id ?? this.school_id,
          class_id: class_id ?? this.class_id,
          batch_id: batch_id ?? this.batch_id,
          observer_roles: observer_roles ?? this.observer_roles,
          lw_focus:  lw_focus ?? this.lw_focus,
          academic_year:  academic_year ?? this.academic_year,
          qs_to_puple: qs_to_puple ?? this.qs_to_puple,
          qs_to_teacher: qs_to_teacher ?? this.qs_to_teacher,
          what_went_well: what_went_well ?? this.what_went_well,
          even_better_if: even_better_if ?? this.even_better_if,
          notes: notes ?? this.notes,
          session_id: session_id ?? this.session_id,
          sender_id: sender_id ?? this.sender_id,
          curriculum_id: curriculum_id ?? this.curriculum_id,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
      id: json[NoteFields.id] as int?,
      app: json[NoteFields.app] as int?,
      teacher_name: json[NoteFields.teacher_name] as String,
      added_date: json[NoteFields.added_date] as String,
      observation_date: json[NoteFields.observation_date] as String,
      teacher_id: json[NoteFields.teacher_id] as String,
      added_by: json[NoteFields.added_by] as String,
      school_id: json[NoteFields.school_id] as String,
      class_id: json[NoteFields.class_id] as String,
      batch_id: json[NoteFields.batch_id] as String,
      observer_roles: json[NoteFields.observer_roles] as String,
      lw_focus: json[NoteFields.lw_focus] ,
      academic_year: json[NoteFields.academic_year] as String,
      qs_to_puple: json[NoteFields.qs_to_puple],
      qs_to_teacher: json[NoteFields.qs_to_teacher],
      what_went_well: json[NoteFields.what_went_well],
      even_better_if: json[NoteFields.even_better_if],
      notes: json[NoteFields.notes],
      session_id: json[NoteFields.session_id] as String,
      sender_id: json[NoteFields.sender_id] as String,
      curriculum_id: json[NoteFields.curriculum_id] as String,
  );

  Map<String, Object?> toJson() => {
    NoteFields.id: id,
    NoteFields.app: app,
    NoteFields.teacher_name: teacher_name,
    NoteFields.added_date: added_date,
    NoteFields.observation_date: observation_date,
    NoteFields.teacher_id: teacher_id,
    NoteFields.added_by: added_by,
    NoteFields.school_id: school_id,
    NoteFields.class_id: class_id,
    NoteFields.batch_id: batch_id,
    NoteFields.observer_roles: observer_roles,
    NoteFields.lw_focus: lw_focus,
    NoteFields.academic_year: academic_year,
    NoteFields.qs_to_puple: qs_to_puple,
    NoteFields.qs_to_teacher: qs_to_teacher,
    NoteFields.what_went_well: what_went_well,
    NoteFields.even_better_if: even_better_if,
    NoteFields.notes: notes,
    NoteFields.session_id: session_id,
    NoteFields.sender_id: sender_id,
    NoteFields.curriculum_id:  curriculum_id,
  };
}

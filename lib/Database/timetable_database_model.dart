final String timetableValues = "timetable";

class TimeTableDatabaseField {
  static final List<String> values = [
    id,
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    defaultData
  ];
  static final String id = '_id';
  static var monday = 'monday';
  static var tuesday = 'tuesday';
  static var wednesday = 'wednesday';
  static var thursday = 'thursday';
  static var friday = 'friday';
  static var saturday = 'saturday';
  static var defaultData = 'defaultData';
}

class TimeTableData {
  final int? id;
  var monday;
  var tuesday;
  var wednesday;
  var thursday;
  var friday;
  var saturday;
  var defaultData;

  TimeTableData(
      {this.id,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday, this.defaultData});

  TimeTableData copy(
          {int? id,
          String? onlyTeacherData,
          String? otherTeacherData,
          String? employeeUnderHead}) =>
      TimeTableData(
          id: id ?? this.id,
          monday: monday ?? this.monday,
          tuesday: tuesday ?? this.tuesday,
          wednesday: wednesday ?? this.wednesday,
          thursday: thursday ?? this.thursday,
          friday: friday ?? this.friday,
          saturday: saturday ?? this.saturday,
          defaultData: defaultData ?? this.defaultData);

  static TimeTableData fromJson(Map<String, Object?> json) => TimeTableData(
      id: json[TimeTableDatabaseField.id] as int?,
      monday: json[TimeTableDatabaseField.monday],
      tuesday: json[TimeTableDatabaseField.tuesday],
      wednesday: json[TimeTableDatabaseField.wednesday],
      thursday: json[TimeTableDatabaseField.thursday],
      friday: json[TimeTableDatabaseField.friday],
      saturday: json[TimeTableDatabaseField.saturday],
      defaultData: json[TimeTableDatabaseField.defaultData]);

  Map<String, Object?> toJson() => {
    TimeTableDatabaseField.id: id,
    TimeTableDatabaseField.monday: monday,
    TimeTableDatabaseField.tuesday: tuesday,
    TimeTableDatabaseField.wednesday: wednesday,
    TimeTableDatabaseField.thursday: thursday,
    TimeTableDatabaseField.friday: friday,
    TimeTableDatabaseField.saturday: saturday,
    TimeTableDatabaseField.defaultData: defaultData
      };
}

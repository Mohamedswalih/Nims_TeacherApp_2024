
final String tableValues = "loginCredentialDetails";

class LoginDatabaseField {
  static final List<String> values = [
    id,
    onlyTeacherData,
    otherTeacherData,
    employeeUnderHead
  ];
  static final String id = '_id';
  static  var onlyTeacherData = 'onlyTeacherData';
  static  var otherTeacherData = 'otherTeacherData';
  static  var employeeUnderHead = 'employeeUnderHead';
}

class LoginData {
  final int? id;
  var onlyTeacherData;
  var otherTeacherData;
  var employeeUnderHead;

   LoginData(
      {this.id,
      this.onlyTeacherData,
      this.otherTeacherData,
      this.employeeUnderHead});

  LoginData copy({int? id, String? onlyTeacherData, String? otherTeacherData, String? employeeUnderHead})=> LoginData(
    id: id ?? this.id,
    onlyTeacherData: onlyTeacherData ?? this.onlyTeacherData,
    otherTeacherData: otherTeacherData ?? this.otherTeacherData,
    employeeUnderHead: employeeUnderHead ?? this.employeeUnderHead
  );

  static LoginData fromJson(Map<String, Object?> json) =>LoginData(
    id: json[LoginDatabaseField.id] as int?,
    onlyTeacherData: json[LoginDatabaseField.onlyTeacherData],
    otherTeacherData: json[LoginDatabaseField.otherTeacherData],
    employeeUnderHead: json[LoginDatabaseField.employeeUnderHead]
  );

  Map<String, Object?> toJson() => {
    LoginDatabaseField.id: id,
    LoginDatabaseField.onlyTeacherData: otherTeacherData,
    LoginDatabaseField.otherTeacherData: otherTeacherData,
    LoginDatabaseField.employeeUnderHead: employeeUnderHead,
  };
}

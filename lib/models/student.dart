import 'department.dart';

enum Gender { male, female }

class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String departmentId;
  final int grade;
  final Gender gender;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.departmentId,
    required this.grade,
    required this.gender,
  });

  Department get department =>
      predefinedDepartments.firstWhere((d) => d.id == departmentId);
}

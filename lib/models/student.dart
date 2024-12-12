enum Department { finance, law, it, medical }
enum Gender { male, female }

class Student {
  final String firstName;
  final String lastName;
  final Department department;
  final int grade;
  final Gender gender;

  Student({
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.grade,
    required this.gender,
  });
}

final departmentIcons = {
  Department.finance: '\u{1F4B8}', 
  Department.law: '\u{2696}',
  Department.it: '\u{1F4BB}', 
  Department.medical: '\u{2695}',
};

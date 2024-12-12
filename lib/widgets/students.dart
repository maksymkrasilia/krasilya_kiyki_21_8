import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';

class StudentsScreen extends StatelessWidget {
  StudentsScreen({Key? key}) : super(key: key);

  final List<Student> students = [
    Student(
      firstName: 'Ivan',
      lastName: 'Petrov',
      department: Department.it,
      grade: 95,
      gender: Gender.male,
    ),
    Student(
      firstName: 'Maria',
      lastName: 'Ivanenko',
      department: Department.finance,
      grade: 88,
      gender: Gender.female,
    ),
    Student(
      firstName: 'Alexander',
      lastName: 'Koval',
      department: Department.law,
      grade: 76,
      gender: Gender.male,
    ),
    Student(
      firstName: 'Natalia',
      lastName: 'Shevchenko',
      department: Department.medical,
      grade: 92,
      gender: Gender.female,
    ),
    Student(
      firstName: 'Andriy',
      lastName: 'Sydorenko',
      department: Department.it,
      grade: 60,
      gender: Gender.male,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return StudentItem(student: students[index]);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';
import 'new_student.dart';

class StudentsScreen extends StatefulWidget {
  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student> _students = [
    Student(firstName: 'Ivan', lastName: 'Petrov', department: Department.it, grade: 95, gender: Gender.male),
    Student(firstName: 'Maria', lastName: 'Ivanenko', department: Department.finance, grade: 88, gender: Gender.female),
  ];

  void _addOrEditStudent([Student? student]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return NewStudent(
          student: student,
          onSave: (newStudent) {
            setState(() {
              if (student != null) {
                _students[_students.indexOf(student)] = newStudent;
              } else {
                _students.add(newStudent);
              }
            });
          },
        );
      },
    );
  }

  void _deleteStudent(int index) {
    final removedStudent = _students[index];
    setState(() {
      _students.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removedStudent.firstName} was removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _students.insert(index, removedStudent);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
      ),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(_students[index]),
            onDismissed: (_) => _deleteStudent(index),
            background: Container(color: Colors.red),
            child: InkWell(
              onTap: () => _addOrEditStudent(_students[index]),
              child: StudentItem(student: _students[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addOrEditStudent(),
        label: const Text('Add Student'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

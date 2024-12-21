import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../providers/students_provider.dart';
import '../widgets/new_student.dart';

class StudentsView extends ConsumerWidget {
  const StudentsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => NewStudent(
                  onSave: (newStudent) {
                    ref.read(studentsProvider.notifier).addStudent(newStudent);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: students.isEmpty
          ? const Center(child: Text('Empty'))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];

                return ListTile(
                  title: Text('${student.firstName} ${student.lastName}'),
                  subtitle: Text(student.department.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref.read(studentsProvider.notifier).removeStudent(index);
                      final globalRef = ProviderScope.containerOf(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${student.firstName} removed'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              globalRef
                                  .read(studentsProvider.notifier)
                                  .undoRemove();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => NewStudent(
                        student: student,
                        onSave: (updatedStudent) {
                          ref
                              .read(studentsProvider.notifier)
                              .updateStudent(index, updatedStudent);
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';
import '../models/department.dart';

class DepartmentsView extends ConsumerWidget {
  const DepartmentsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studentsProvider);
    if(state.loadingFromServer) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: predefinedDepartments.length,
      itemBuilder: (context, index) {
        final department = predefinedDepartments[index];
        final studentCount = state.currentList
            .where((student) => student.departmentId == department.id)
            .length;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [department.color.withOpacity(0.6), department.color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(department.icon, size: 40, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                department.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '$studentCount Students',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        );
      },
    );
  }
}

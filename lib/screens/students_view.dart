import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';
import '../widgets/new_student.dart';

class StudentsView extends ConsumerWidget {
  const StudentsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studentsProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.err != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.err!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    if(state.loadingFromServer) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const NewStudent(),
              );
            },
          ),
        ],
      ),
      body: state.currentList.isEmpty
          ? const Center(child: Text('Empty'))
          : ListView.builder(
              itemCount: state.currentList.length,
              itemBuilder: (context, index) {
                final student = state.currentList[index];
                final department = student.getDepartmentById(student.departmentId);
                return ListTile(
                  title: Text('${student.firstName} ${student.lastName}'),
                  subtitle: Text(department.name),
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
                                  .undo();
                            },
                          ),
                        ),
                      ).closed.then((value) {
                        if (value != SnackBarClosedReason.action) {
                          globalRef.read(studentsProvider.notifier).undoFirebase();
                        }
                      });
                    },
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => NewStudent(selectedIndex: index,),
                    );
                  },
                );
              },
            ),
    );
  }
}

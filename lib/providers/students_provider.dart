import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier() : super([]);

  Student? _lastRemoved;
  int? _lastRemovedIndex;

  void addStudent(Student student) {
    state = [...state, student];
  }

  void updateStudent(int index, Student updatedStudent) {
    final updatedList = [...state];
    updatedList[index] = updatedStudent;
    state = updatedList;
  }

  void removeStudent(int index) {
    _lastRemoved = state[index];
    _lastRemovedIndex = index;
    state = [...state.sublist(0, index), ...state.sublist(index + 1)];
  }

  void undoRemove() {
    if (_lastRemoved != null && _lastRemovedIndex != null) {
      state = [
        ...state.sublist(0, _lastRemovedIndex!),
        _lastRemoved!,
        ...state.sublist(_lastRemovedIndex!),
      ];
      _lastRemoved = null;
      _lastRemovedIndex = null;
    }
  }

  int countStudentsInDepartment(String departmentId) {
    return state.where((student) => student.departmentId == departmentId).length;
  }
}

final studentsProvider = StateNotifierProvider<StudentsNotifier, List<Student>>(
  (ref) => StudentsNotifier(),
);

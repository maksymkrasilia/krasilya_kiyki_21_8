import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsState {
  final List<Student> currentList;
  final bool loadingFromServer;
  final String? err;

  StudentsState({
    required this.currentList,
    required this.loadingFromServer,
    this.err,
  });

  StudentsState copyWith({
    List<Student>? students,
    bool? isLoading,
    String? errorMessage,
  }) {
    return StudentsState(
      currentList: students ?? this.currentList,
      loadingFromServer: isLoading ?? this.loadingFromServer,
      err: errorMessage ?? this.err,
    );
  }
}

class StudentsNotifier extends StateNotifier<StudentsState> {
  StudentsNotifier() : super(StudentsState(currentList: [], loadingFromServer: false));

  Student? _lastRemoved;
  int? _lastRemovedIndex;

  Future<void> loadStudents() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final students = await Student.remoteGetList();
      state = state.copyWith(students: students, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> addStudent(
    String firstName,
    String lastName,
    departmentId,
    gender,
    int grade,
  ) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final student = await Student.remoteCreate(
          firstName, lastName, departmentId, gender, grade);
      state = state.copyWith(
        students: [...state.currentList, student],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> editStudent(
    int index,
    String firstName,
    String lastName,
    departmentId,
    gender,
    int grade,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updatedStudent = await Student.remoteUpdate(
        state.currentList[index].id,
        firstName,
        lastName,
        departmentId,
        gender,
        grade,
      );
      final updatedList = [...state.currentList];
      updatedList[index] = updatedStudent;
      state = state.copyWith(students: updatedList, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void removeStudent(int index) {
    _lastRemoved = state.currentList[index];
    _lastRemovedIndex = index;
    final updatedList = [...state.currentList];
    updatedList.removeAt(index);
    state = state.copyWith(students: updatedList);
  }

  void undo() {
    if (_lastRemoved != null && _lastRemovedIndex != null) {
      final updatedList = [...state.currentList];
      updatedList.insert(_lastRemovedIndex!, _lastRemoved!);
      state = state.copyWith(students: updatedList);
    }
  }

  Future<void> undoFirebase() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (_lastRemoved != null) {
        await Student.remoteDelete(_lastRemoved!.id);
        _lastRemoved = null;
        _lastRemovedIndex = null;
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final studentsProvider =
    StateNotifierProvider<StudentsNotifier, StudentsState>((ref) {
  final notifier = StudentsNotifier();
  notifier.loadStudents();
  return notifier;
});

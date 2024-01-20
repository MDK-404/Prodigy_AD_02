
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/model.dart';

class Notifierx extends StateNotifier<List<Notes>> {
  Notifierx() : super([]);

  void addNote(Notes note) {
    state = [...state, note];
  }
  void removeNote(Notes note) {
    state = state.where((_note) => _note != note).toList();
  }
  void updateNote(Notes oldNote, Notes newNote) {
    state = state.map((note) => note == oldNote ? newNote : note).toList();
  }

}
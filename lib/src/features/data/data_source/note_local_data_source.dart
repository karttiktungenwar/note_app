import 'package:noteapp/src/core/database/app_database.dart';
import 'package:noteapp/src/features/data/model/note_model.dart';

abstract class NoteLocalDataSource {
  Future<List<NoteModel>> getNotes();
  Future<void> addNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(String id);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final AppDatabase appDatabase;

  NoteLocalDataSourceImpl({required this.appDatabase});

  @override
  Future<List<NoteModel>> getNotes() async {
     final notes = appDatabase.appBox.values
            .map((e) => NoteModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        return notes.cast<NoteModel>();
  }

  @override
  Future<void> addNote(NoteModel note) async {
    await appDatabase.appBox.put(note.id, note.toJson());
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    await appDatabase.appBox.put(note.id, note.toJson());
  }

  @override
  Future<void> deleteNote(String id) async {
    await appDatabase.appBox.delete(id);
  }
}
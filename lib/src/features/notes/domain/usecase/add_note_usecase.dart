import 'package:dartz/dartz.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/features/notes/domain/entity/note.dart';
import 'package:noteapp/src/features/notes/domain/repository/note_repository.dart';

class AddNoteUsecase {
  final NoteRepository repository;

  AddNoteUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Note note) async {
    return await repository.addNote(note);
  }
}
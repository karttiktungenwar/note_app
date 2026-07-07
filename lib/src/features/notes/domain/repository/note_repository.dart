import 'package:dartz/dartz.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/features/notes/domain/entity/note.dart';

abstract class NoteRepository {
  Future<Either<Failure, List<Note>>> getNotes();
  Future<Either<Failure, Unit>> addNote(Note note);
  Future<Either<Failure, Unit>> updateNote(Note note);
  Future<Either<Failure, Unit>> deleteNote(String id);
  Future<Either<Failure, List<Note>>> getSearchNotes(String query);
}
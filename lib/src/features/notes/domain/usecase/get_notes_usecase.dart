import 'package:dartz/dartz.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/features/notes/domain/entity/note.dart';
import 'package:noteapp/src/features/notes/domain/repository/note_repository.dart';

class GetNotesUsecase {
  final NoteRepository repository;

  GetNotesUsecase(this.repository);

  Future<Either<Failure,List<Note>>> call() async {
    return await repository.getNotes();
  }
}
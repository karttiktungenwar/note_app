import 'package:dartz/dartz.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/features/domain/repository/note_repository.dart';

class DeleteNoteUsecase {
  final NoteRepository repository;

  DeleteNoteUsecase(this.repository);

  Future<Either<Failure, Unit>> call(String id) async {
    return await repository.deleteNote(id);
  }
}
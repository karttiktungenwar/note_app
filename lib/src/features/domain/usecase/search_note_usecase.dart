import 'package:dartz/dartz.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/features/domain/entity/note.dart';
import 'package:noteapp/src/features/domain/repository/note_repository.dart';

class SearchNoteUsecase {
  final NoteRepository repository;

  SearchNoteUsecase(this.repository);

  Future<Either<Failure,List<Note>>> call(String query) async {
    return await repository.getSearchNotes(query);
  }
}
import 'package:dartz/dartz.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/features/data/data_source/note_local_data_source.dart';
import 'package:noteapp/src/features/data/model/note_model.dart';
import 'package:noteapp/src/features/domain/entity/note.dart';
import 'package:noteapp/src/features/domain/repository/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource localDataSource;

  NoteRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    try {
      final models = await localDataSource.getNotes();

      if (models.isEmpty) {
        return Left(
            NoDataFailure(message: 'No notes found')
        );
      }

      return Right(
        models.map((e) => e.toEntity()).toList(),
      );
    }catch (e) {
      return Left(
        CacheFailure(message: e.toString()),
      );
    }

  }

  @override
  Future<Either<Failure, Unit>> addNote(Note note) async {
    try {
      await localDataSource.addNote(
        NoteModel(
          id: note.id,
          title: note.title,
          content: note.content,
          createdAt: note.createdAt,
        ),
      );

      return Right(unit);
    } catch (e) {
      return Left(
        CacheFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> updateNote(Note note) async {
    try {
      await localDataSource.updateNote(
        NoteModel(
          id: note.id,
          title: note.title,
          content: note.content,
          createdAt: note.createdAt,
        ),
      );

      return Right(unit);
    } catch (e) {
      return Left(
        CacheFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNote(String id) async {
    try {
      await localDataSource.deleteNote(id);
      return Right(unit);
    } catch (e) {
      return Left(
        CacheFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getSearchNotes(String query) async{
    try {
      final models = await localDataSource.getNotes();

      if (models.isEmpty) {
        return Left(
            NoDataFailure(message: 'No notes found')
        );
      }

      final filtered = models.where((note) {
        final title = note.title.toLowerCase();
        final content = note.content.toLowerCase();
        final q = query.toLowerCase();

        return title.contains(q) || content.contains(q);
      }).toList();

      if (filtered.isEmpty) {
        return Left(
          NoDataFailure(message: 'No matching notes found'),
        );
      }

      return Right(filtered.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(
        CacheFailure(message: e.toString()),
      );
    }
  }


}

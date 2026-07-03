import 'package:get_it/get_it.dart';
import 'package:noteapp/src/core/constants/app_constants.dart';
import 'package:noteapp/src/core/database/app_database.dart';
import 'package:noteapp/src/features/data/data_source/note_local_data_source.dart';
import 'package:noteapp/src/features/data/repository/note_repository_impl.dart';
import 'package:noteapp/src/features/domain/repository/note_repository.dart';
import 'package:noteapp/src/features/domain/usecase/add_note_usecase.dart';
import 'package:noteapp/src/features/domain/usecase/delete_note_usecase.dart';
import 'package:noteapp/src/features/domain/usecase/get_notes_usecase.dart';
import 'package:noteapp/src/features/domain/usecase/search_note_usecase.dart';
import 'package:noteapp/src/features/domain/usecase/update_note_usecase.dart';
import 'package:noteapp/src/features/presentation/bloc/note_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // Bloc
  sl.registerFactory(() => NoteBloc(
    addNote: sl(),
    deleteNote: sl(),
    getNotes: sl(),
    updateNote: sl(),
    searchNote: sl(),
  ));

  // AppDatabase
  sl.registerLazySingleton<AppDatabase>(
        () => AppDatabaseImpl(hivePathSuffix: AppConstants.hiveBoxName),
  );
  await sl<AppDatabase>().init();

  // Use cases
  sl.registerLazySingleton(() => AddNoteUsecase(sl()));
  sl.registerLazySingleton(() => DeleteNoteUsecase(sl()));
  sl.registerLazySingleton(() => GetNotesUsecase(sl()));
  sl.registerLazySingleton(() => UpdateNoteUsecase(sl()));
  sl.registerLazySingleton(() => SearchNoteUsecase(sl()));

  // Repository
  sl.registerLazySingleton<NoteRepository>(
          () => NoteRepositoryImpl(localDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<NoteLocalDataSource>(
          () => NoteLocalDataSourceImpl(appDatabase: sl<AppDatabase>()));
}
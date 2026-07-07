import 'package:get_it/get_it.dart';
import 'package:noteapp/src/core/constants/app_constants.dart';
import 'package:noteapp/src/core/database/app_database.dart';
import 'package:noteapp/src/core/network/api_service.dart';
import 'package:noteapp/src/features/login/data/data_source/login_auth_remote_data_source.dart';
import 'package:noteapp/src/features/login/data/repository/login_auth_respository_impl.dart';
import 'package:noteapp/src/features/login/domain/repository/login_auth_respository.dart';
import 'package:noteapp/src/features/login/domain/usecase/login_auth_usecase.dart';
import 'package:noteapp/src/features/login/presentation/bloc/login_auth_bloc.dart';
import 'package:noteapp/src/features/notes/data/data_source/note_local_data_source.dart';
import 'package:noteapp/src/features/notes/data/repository/note_repository_impl.dart';
import 'package:noteapp/src/features/notes/domain/repository/note_repository.dart';
import 'package:noteapp/src/features/notes/domain/usecase/add_note_usecase.dart';
import 'package:noteapp/src/features/notes/domain/usecase/delete_note_usecase.dart';
import 'package:noteapp/src/features/notes/domain/usecase/get_notes_usecase.dart';
import 'package:noteapp/src/features/notes/domain/usecase/search_note_usecase.dart';
import 'package:noteapp/src/features/notes/domain/usecase/update_note_usecase.dart';
import 'package:noteapp/src/features/notes/presentation/bloc/note_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {

  //ApiService
  sl.registerLazySingleton<ApiService>(
        () => ApiServiceImpl(baseUrl: AppConstants.baseURL),
  );

  // AppDatabase
  sl.registerLazySingleton<AppDatabase>(
        () => AppDatabaseImpl(hivePathSuffix: AppConstants.hiveBoxName),
  );
  await sl<AppDatabase>().init();

  _setupLoginAuth();
  _setupNotes();
}

void _setupLoginAuth() async {
  //Bloc
  sl.registerFactory(() => LoginAuthBloc(
      loginAuthUsecase: sl()));

  // RemoteDataSource
  sl.registerLazySingleton<LoginAuthRemoteDataSource>(
          () => LoginAuthRemoteDataSource(apiService: sl<ApiService>()));

  // Repository
  sl.registerLazySingleton<LoginAuthRepository>(
          () => LoginAuthRepositoryImpl(loginAuthRemoteDataSource: sl<LoginAuthRemoteDataSource>()));

  // Use cases
  sl.registerLazySingleton(() => LoginAuthUsecase(loginAuthRepository: sl<LoginAuthRepository>()));
}

void _setupNotes() async{

  // Bloc
  sl.registerFactory(() => NoteBloc(
    addNote: sl(),
    deleteNote: sl(),
    getNotes: sl(),
    updateNote: sl(),
    searchNote: sl(),
  ));

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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:noteapp/src/core/constants/app_constants.dart';
import 'package:noteapp/src/core/database/app_database.dart';
import 'package:noteapp/src/core/local_storage/secure_storage_service.dart';
import 'package:noteapp/src/core/network/api_service.dart';
import 'package:noteapp/src/features/login/data/data_source/login_auth_local_data_source.dart';
import 'package:noteapp/src/features/login/data/data_source/login_auth_remote_data_source.dart';
import 'package:noteapp/src/features/login/data/repository/login_auth_repository_impl.dart';
import 'package:noteapp/src/features/login/domain/repository/login_auth_repository.dart';
import 'package:noteapp/src/features/login/domain/usecase/login_auth_get_token_usecase.dart';
import 'package:noteapp/src/features/login/domain/usecase/login_auth_save_token_usecase.dart';
import 'package:noteapp/src/features/login/domain/usecase/login_auth_usecase.dart';
import 'package:noteapp/src/features/login/domain/usecase/logout_auth_usecase.dart';
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
  sl<AppDatabase>().init();

  // 1. Android Specific Options
  const androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  // 2. iOS Specific Options
  const iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
    synchronizable: false,
  );

  // 3. Instantiate FlutterSecureStorage with both options
  final secureStorage = FlutterSecureStorage(
    aOptions: androidOptions,
    iOptions: iosOptions,
  );

  // 4. Register Service
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(secureStorage),
  );

  _setupLoginAuth();
  _setupNotes();

  await sl.allReady();
}

void _setupLoginAuth() {
  sl.registerLazySingleton<LoginAuthRemoteDataSource>(
    () => LoginAuthRemoteDataSourceImpl(apiService: sl<ApiService>()),
  );

  sl.registerLazySingleton<LoginAuthLocalDataSource>(
        () => LoginAuthLocalDataSourceImpl(secureStorageService: sl<SecureStorageService>()),
  );

  sl.registerLazySingleton<LoginAuthRepository>(
    () => LoginAuthRepositoryImpl(
      loginAuthRemoteDataSource: sl<LoginAuthRemoteDataSource>(),
      loginAuthLocalDataSource: sl<LoginAuthLocalDataSource>()
    ),
  );

  sl.registerLazySingleton(
    () => LoginAuthUsecase(loginAuthRepository: sl<LoginAuthRepository>()),
  );
  sl.registerLazySingleton(
        () => LoginAuthGetTokenUsecase(loginAuthRepository: sl<LoginAuthRepository>()),
  );
  sl.registerLazySingleton(
        () => LoginAuthSaveTokenUsecase(loginAuthRepository: sl<LoginAuthRepository>()),
  );
  sl.registerLazySingleton(
        () => LogoutAuthUsecase(loginAuthRepository: sl<LoginAuthRepository>()),
  );

  sl.registerFactory(
    () => LoginAuthBloc(
        loginAuthUsecase: sl<LoginAuthUsecase>(),
        loginAuthGetTokenUsecase: sl<LoginAuthGetTokenUsecase>(),
        loginAuthSaveTokenUsecase: sl<LoginAuthSaveTokenUsecase>(),
        logoutAuthUsecase: sl<LogoutAuthUsecase>(),
    ),
  );
}

void _setupNotes() {
  sl.registerLazySingleton<NoteLocalDataSource>(
    () => NoteLocalDataSourceImpl(appDatabase: sl<AppDatabase>()),
  );

  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(localDataSource: sl<NoteLocalDataSource>()),
  );

  sl.registerLazySingleton(() => AddNoteUsecase(sl<NoteRepository>()));
  sl.registerLazySingleton(() => DeleteNoteUsecase(sl<NoteRepository>()));
  sl.registerLazySingleton(() => GetNotesUsecase(sl<NoteRepository>()));
  sl.registerLazySingleton(() => UpdateNoteUsecase(sl<NoteRepository>()));
  sl.registerLazySingleton(() => SearchNoteUsecase(sl<NoteRepository>()));

  sl.registerFactory(
    () => NoteBloc(
      addNote: sl<AddNoteUsecase>(),
      deleteNote: sl<DeleteNoteUsecase>(),
      getNotes: sl<GetNotesUsecase>(),
      updateNote: sl<UpdateNoteUsecase>(),
      searchNote: sl<SearchNoteUsecase>(),
    ),
  );
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/src/core/enums/status.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/features/login/domain/entity/request/login_auth_entity_req.dart';
import 'package:noteapp/src/features/login/domain/entity/response/login_auth_entity_resp.dart';
import 'package:noteapp/src/features/login/domain/usecase/login_auth_get_token_usecase.dart';
import 'package:noteapp/src/features/login/domain/usecase/login_auth_save_token_usecase.dart';
import 'package:noteapp/src/features/login/domain/usecase/login_auth_usecase.dart';
import 'package:noteapp/src/features/login/domain/usecase/logout_auth_usecase.dart';

part 'login_auth_state.dart';
part 'login_auth_event.dart';

class LoginAuthBloc extends Bloc<LoginAuthEvent, LoginAuthState> {
  final LoginAuthUsecase loginAuthUsecase;
  final LoginAuthGetTokenUsecase loginAuthGetTokenUsecase;
  final LoginAuthSaveTokenUsecase loginAuthSaveTokenUsecase;
  final LogoutAuthUsecase logoutAuthUsecase;

  LoginAuthBloc({
    required this.loginAuthUsecase,
    required this.loginAuthGetTokenUsecase,
    required this.loginAuthSaveTokenUsecase,
    required this.logoutAuthUsecase,
  })
      : super(
    const LoginAuthState(
      status: Status.initial,
      getTokenStatus: Status.initial,
      saveTokenStatus: Status.initial,
      logoutStatus: Status.initial,
    ),
  ) {
    on<GetLoginAuthEvent>(_onGetLoginAuth);
    on<GetLoginAuthTokenEvent>(_onGetLoginAuthToken);
    on<SaveLoginAuthTokenEvent>(_onSaveLoginAuthToken);
    on<LogoutEvent>(_onLogoutEvent);
  }

  // Handler for GetLoginAuthEvent
  Future<void> _onGetLoginAuth(
      GetLoginAuthEvent event,
      Emitter<LoginAuthState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await loginAuthUsecase.getLoginAuth(req: event.req);

    result.fold(
          (failure) => emit(
        state.copyWith(
          status: Status.error,
          failure: failure,
        ),
      ),
          (loginAuthEntityResp) => emit(
        state.copyWith(
          status: Status.success,
          loginAuthEntityResp: loginAuthEntityResp,
        ),
      ),
    );
  }

  // Handler for GetLoginAuthTokenEvent
  Future<void> _onGetLoginAuthToken(
      GetLoginAuthTokenEvent event,
      Emitter<LoginAuthState> emit,
      ) async {
    emit(state.copyWith(getTokenStatus: Status.loading));

    final result = await loginAuthGetTokenUsecase.getToken();

    result.fold(
          (failure) => emit(
        state.copyWith(
          getTokenStatus: Status.error,
          failure: failure,
        ),
      ),
          (token) => emit(
        state.copyWith(
          getTokenStatus: Status.success,
          token: token,
        ),
      ),
    );
  }

  // Handler for SaveLoginAuthTokenEvent
  Future<void> _onSaveLoginAuthToken(
      SaveLoginAuthTokenEvent event,
      Emitter<LoginAuthState> emit,
      ) async {
    emit(state.copyWith(saveTokenStatus: Status.loading));

    final result = await loginAuthSaveTokenUsecase.saveToken(token: event.token);

    result.fold(
          (failure) => emit(
        state.copyWith(
          saveTokenStatus: Status.error,
          failure: failure,
        ),
      ),
          (_) => emit(
        state.copyWith(
          saveTokenStatus: Status.success,
          successMessage: "Token saved successfully",
        ),
      ),
    );
  }

  // Handler for LogoutEvent
  Future<void> _onLogoutEvent(
      LogoutEvent event,
      Emitter<LoginAuthState> emit,
      ) async {
    emit(state.copyWith(logoutStatus: Status.loading));

    final result = await logoutAuthUsecase.logout();

    result.fold(
          (failure) => emit(
        state.copyWith(
          logoutStatus: Status.error,
          failure: failure,
        ),
      ),
          (_) => emit(
        state.copyWith(
          logoutStatus: Status.success,
          successMessage: "Logged out successfully",
        ),
      ),
    );
  }
}
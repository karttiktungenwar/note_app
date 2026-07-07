import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/src/core/enums/status.dart';
import 'package:noteapp/src/core/error/failure.dart';
import 'package:noteapp/src/features/login/domain/entity/request/login_auth_entity_req.dart';
import 'package:noteapp/src/features/login/domain/entity/response/login_auth_entity_resp.dart';
import 'package:noteapp/src/features/login/domain/usecase/login_auth_usecase.dart';

part 'login_auth_state.dart';
part 'login_auth_event.dart';

class LoginAuthBloc extends Bloc<LoginAuthEvent, LoginAuthState> {
  final LoginAuthUsecase loginAuthUsecase;

  LoginAuthBloc({required this.loginAuthUsecase}) : super(const LoginAuthState(status: Status.initial)) {
    on<GetLoginAuthEvent>(_onGetLoginAuth);
  }
  Future<void> _onGetLoginAuth(
      GetLoginAuthEvent event,
      Emitter<LoginAuthState> emit,
      ) async {
    emit(state.copyWith(status: Status.loading));

    final result = await loginAuthUsecase.getLoginAuth(req: event.req);

    result.fold(
          (failure) {
        emit(state.copyWith(
          status: Status.error,
          failure: failure,
        ));
      },
          (loginAuthEntityResp) {
        emit(state.copyWith(
          status: Status.success,
          loginAuthEntityResp: loginAuthEntityResp,
        ));
      },
    );
  }
}
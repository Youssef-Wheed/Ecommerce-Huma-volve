import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;

  AuthCubit(this._loginUseCase, this._registerUseCase)
      : super(const AuthState());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      await _loginUseCase(email: email, password: password);
      emit(const AuthState(status: AuthStatus.success));
    } catch (e) {
      emit(
        AuthState(
          status: AuthStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      await _registerUseCase(name: name, email: email, password: password);
      emit(const AuthState(status: AuthStatus.success));
    } catch (e) {
      emit(
        AuthState(
          status: AuthStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
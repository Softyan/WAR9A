import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/base_state.dart';
import '../../../data/status_auth.dart';
import '../../../utils/export_utils.dart';

part 'main_screen_state.dart';
part 'main_screen_cubit.mapper.dart';

@injectable
class MainScreenCubit extends Cubit<MainScreenState> {
  StreamSubscription<AuthState>? authSubscription;
  final GoTrueClient _auth;
  MainScreenCubit(this._auth) : super(const MainScreenState());

  void init() {
    authSubscription?.cancel();
    authSubscription = _auth.onAuthStateChange.listen((event) {
      logger.d("AuthStateChange: ${event.event}");
      final session = event.session;
      logger.i("Session: ${session != null}");

      if (session == null) {
        emit(state.copyWith(
            statusAuth: StatusAuth.register,
            message: "Your session has expired"));
      }

      if (event.event == AuthChangeEvent.signedOut) {
        emit(state.copyWith(
            statusAuth: StatusAuth.register,
            message: "You have been logged out"));
      }
    });
  }

  void selectedTab(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  @override
  Future<void> close() {
    authSubscription?.cancel();
    return super.close();
  }
}

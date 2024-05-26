import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../models/news.dart';
import '../../../models/user.dart';
import '../../../repository/home_repository.dart';
import '../../../repository/profile_repository.dart';
import '../../../res/export_res.dart';
import '../components/card_profile.dart';
import '../components/menu_dashboard.dart';
import '../components/news_home.dart';

part 'home_state.dart';
part 'home_cubit.mapper.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;
  final ProfileRepository _profileRepository;
  final List<Widget> _contents = [];

  HomeCubit(this._homeRepository, this._profileRepository)
      : super(const HomeState());

  void init() async {
    await _getCurrentUser();
    await _getNews();
    _getBaseContents();
  }

  void _getBaseContents() {
    final user = state.user;
    final news = state.news;

    _contents.add(Center(
      child: Assets.images.logo2Primary.svg(),
    ));
    if (user != null) {
      _contents.add(CardProfile(user: user));
    }
    _contents.add(const MenuDashboard());
    if (news.isNotEmpty) {
    _contents.add(NewsHome(news: news));
    }
    emit(state.copyWith(contents: _contents));
  }

  Future<void> _getCurrentUser() async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _profileRepository.getCurrentUser();

    final newState = result.when(
      result: (data) =>
          state.copyWith(statusState: StatusState.idle, user: data),
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }

  Future<void> _getNews() async {
    emit(state.copyWith(statusState: StatusState.loading));

    final result = await _homeRepository.getNews();

    final newState = result.when(
      result: (data) =>
          state.copyWith(statusState: StatusState.idle, news: data),
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }
}

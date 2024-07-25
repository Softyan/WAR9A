import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../data/base_state.dart';
import '../../../models/enums/role.dart';
import '../../../models/item_dashboard.dart';
import '../../../models/news.dart';
import '../../../models/user.dart';
import '../../../repository/news_repository.dart';
import '../../../repository/profile_repository.dart';
import '../../../res/export_res.dart';
import '../../../utils/export_utils.dart';
import '../../add_news/add_news_screen.dart';
import '../../data_surat/add_data_surat_screen.dart';
import '../../data_surat/data_surat_screen.dart';
import '../../data_warga/data_warga_screen.dart';
import '../../form_surat/form_pengajuan_surat_screen.dart';
import '../../pengajuan/pengajuan_surat_screen.dart';
import '../components/card_profile.dart';
import '../components/menu_dashboard.dart';
import '../components/news_home.dart';

part 'home_state.dart';
part 'home_cubit.mapper.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final NewsRepository _newsRepository;
  final ProfileRepository _profileRepository;
  final List<Widget> _contents = [];

  HomeCubit(this._newsRepository, this._profileRepository)
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

    final contentDashboard = _getMenuDashboard(user?.role);

    _contents.add(MenuDashboard(
      contents: contentDashboard,
    ));

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

    final result = await _newsRepository.getNews();

    final newState = result.when(
      result: (data) => state.copyWith(
          statusState: StatusState.idle, news: data.take(5).toList()),
      error: (message) =>
          state.copyWith(message: message, statusState: StatusState.failure),
    );
    emit(newState);
  }

  List<ItemDashboard> _getMenuDashboard(Role? role) {
    logger.d("role: $role");
    return switch (role) {
      Role.rw || Role.rt => _contentsRTRW,
      Role.sekretaris => _contentsSekre,
      _ => _contentsWarga
    };
  }

  List<ItemDashboard> get _contentsRTRW => [
        ItemDashboard(
            title: "Pengajuan Surat",
            path: Assets.icons.pengajuanSurat.path,
            destination: const PengajuanSuratScreen()),
        ItemDashboard(
            title: "Data Warga",
            path: Assets.icons.dataWarga.path,
            destination: const DataWargaScreen()),
        ItemDashboard(
            title: "Data Surat",
            path: Assets.icons.dataSurat.path,
            destination: const DataSuratScreen()),
      ];

  List<ItemDashboard> get _contentsSekre => [
        ItemDashboard(
            title: "Data Surat",
            path: Assets.icons.dataSurat.path,
            destination: const DataSuratScreen()),
        ItemDashboard(
            title: "Tambah Surat",
            path: Assets.icons.icAddSurat.path,
            destination: const AddDataSuratScreen()),
        ItemDashboard(
            title: "Tambah Berita",
            path: Assets.icons.icAddNews.path,
            destination: const AddNewsScreen()),
      ];

  List<ItemDashboard> get _contentsWarga => [
        ItemDashboard(
            title: "Data Pengajuan",
            path: Assets.icons.pengajuanSurat.path,
            destination: const PengajuanSuratScreen()),
        ItemDashboard(
            title: "Ajukan Surat",
            path: Assets.icons.icAjukanSurat.path,
            destination: const FormPengajuanSuratScreen()),
        ItemDashboard(
            title: "Status Pengajuan",
            path: Assets.icons.icStatusPengajuan.path,
            destination: null),
      ];
}

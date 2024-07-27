import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../models/item_content.dart';
import '../../models/surat.dart';
import '../../res/export_res.dart';
import '../../utils/export_utils.dart';
import 'add_data_surat_screen.dart';
import 'cubit/data_surat_cubit.dart';
import 'item_data_surat.dart';

class DetailDataSuratScreen extends StatefulWidget {
  final Surat surat;
  const DetailDataSuratScreen({super.key, required this.surat});

  @override
  State<DetailDataSuratScreen> createState() => _DetailDataSuratScreenState();
}

class _DetailDataSuratScreenState extends State<DetailDataSuratScreen> {
  late DataSuratCubit _dataSuratCubit;
  late Surat _newSurat;
  @override
  void initState() {
    super.initState();
    _dataSuratCubit = getIt<DataSuratCubit>();
    _newSurat = widget.surat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget("Detail Data Surat"),
      body: BlocConsumer<DataSuratCubit, DataSuratState>(
        bloc: _dataSuratCubit,
        listener: (context, state) {
          if (state.isSuccess) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.success));
            AppRoute.back();
          }
          if (state.isError) {
            context.snackbar.showSnackBar(
                SnackbarWidget(state.message, state: SnackbarState.error));
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const LoadingWidget();
          }
          return ListWidget(
            _contents,
            isSeparated: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemBuilder: (context, item, index) => item,
            separatorBuilder: (context, item, index) => const SpacerWidget(16),
          );
        },
      ),
    );
  }

  List<Content> get _dataSuratContent => [
        Content(
            title: "Asal Surat",
            text: _newSurat.from,
            path: Assets.icons.icNama.path),
        Content(
          title: "Nomor Surat",
          text: _newSurat.noSurat,
          path: Assets.icons.icNomorSurat.path,
        ),
        Content(
          title: "Perihal",
          text: _newSurat.perihal,
          path: Assets.icons.icPerihal.path,
        )
      ];

  List<Widget> get _contents => [
        ListWidget(
          _dataSuratContent,
          isSeparated: true,
          shrinkWrap: true,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, item, index) => ItemDataSurat(data: item),
          separatorBuilder: (context, item, index) => const SpacerWidget(8),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 0.5)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: _newSurat.suratUrls.first,
              progressIndicatorBuilder: (context, url, progress) => Center(
                child: CircularProgressIndicator.adaptive(
                  value: progress.progress,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 200,
                decoration: BoxDecoration(
                    color: War9aColors.greyF2,
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(child: Text("Can't loaded Image")),
              ),
            ),
          ),
        ),
        const SpacerWidget(8),
        Column(
          children: [
            Button("Edit", width: context.mediaSize.width, onPressed: () async {
              final updatedSurat = await AppRoute.to(AddDataSuratScreen(
                surat: _newSurat,
              ));
              setState(() {
                _newSurat = updatedSurat;
              });
            }),
            const SpacerWidget(16),
            Button("Hapus",
                width: context.mediaSize.width,
                backgroundColor: War9aColors.red,
                onPressed: () => _dataSuratCubit.deleteSurat(_newSurat.id)),
          ],
        ),
        const SpacerWidget(16),
      ];
}

import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../di/injection.dart';
import '../../models/item_content.dart';
import '../../models/pengajuan_surat.dart';
import '../../utils/export_utils.dart';
import '../../utils/global_helpers.dart';

class SuratPengajuanTemplate {
  // SuratPengajuanTemplate._();
  Future<Uint8List> suratPengajuanPDf(PengajuanSurat pengajuanSurat) async {
    final PengajuanSurat(:rt, :createdAt, :noSurat) = pengajuanSurat;
    final pdf = Document();
    pdf.addPage(Page(build: (context) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(children: [
              Text("RUKUN TETANGGA 00$rt"),
              Text("RUKUN WARGA 09"),
              Text("KELURAHAN MARUNDA KECAMATAN CILINCING"),
              Text("Sekertariat : Jl Sungai Tiram , Kp Nelayan No 23"),
              Text("No Telp : 089323213123, Email : ......................."),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text("Kode Pos : 14150")),
              Divider(),
            ]),
            Column(children: [
              Text("SURAT PENGANTAR"),
              Text("NOMOR : ${noSurat.ifEmpty()}"),
              SizedBox(height: 16),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                      "Yang bertanda tangan di bawah ini, mengerangkan bahwa : ")),
              SizedBox(height: 16),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                      itemBuilder: (Context context, int index) {
                        final Content(:title, :text) =
                            _contents(pengajuanSurat)[index];
                        return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 2, child: Text(title)),
                              Flexible(child: Text(":${"\t" * 3}")),
                              Expanded(flex: 3, child: Text(text))
                            ]);
                      },
                      itemCount: _contents(pengajuanSurat).length)),
              SizedBox(height: 16),
              Text(
                  "Demikian surat  pengantar ini dibuat untuk dapat dipergunakan sebagaimana mestinya dan yang berkepentingan untuk menjadi maklum.")
            ]),
            Divider(color: PdfColors.white),
            SizedBox(height: 32),
            Row(children: [
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Text("KETUA RW 09"),
                    SizedBox(height: 32),
                    Text("(.................................)")
                  ])),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Text(
                        "Bekasi, ${(createdAt ?? DateTime.now()).formatWithoutTime}"),
                    Text("KETUA RT 0$rt"),
                    SizedBox(height: 32),
                    Text("(.................................)")
                  ]))
            ])
          ]);
    }));
    return pdf.save();
  }

  List<Content> _contents(PengajuanSurat pengajuanSurat) {
    final PengajuanSurat(
      :name,
      :birthDate,
      :jenisKelamin,
      :nik,
      :alamat,
      :keperluan,
      :agama,
      :pekerjaan,
      :tempat
    ) = pengajuanSurat;
    return [
      Content(title: "Nama", text: name.capitalEachWord().ifEmpty()),
      Content(
          title: "Tempat, Tanggal Lahir",
          text:
              "${tempat.capitalEachWord().ifEmpty()}, ${birthDate?.formatWithoutTime.ifEmpty()}"),
      Content(
          title: "Jenis Kelamin",
          text: getIt<GlobalHelpers>().genderMapping(jenisKelamin)),
      Content(title: "Agama", text: agama.capitalize().ifEmpty()),
      Content(title: "Pekerjaan", text: pekerjaan.capitalize().ifEmpty()),
      Content(title: "Nomor KTP", text: nik),
      Content(title: "Alamat", text: alamat.capitalEachWord().ifEmpty()),
      Content(title: "Keperluan", text: keperluan.capitalize().ifEmpty()),
    ];
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../../di/injection.dart';
import '../../models/item_content.dart';
import '../../models/pengajuan_surat.dart';
import '../../utils/export_utils.dart';

@singleton
class SuratPengajuanTemplate {
  Future<Uint8List> suratPengajuanPDf(PengajuanSurat pengajuanSurat) async {
    final PengajuanSurat(
      :rt,
      :createdAt,
      :noSurat,
      :ttdRt,
      :ttdRw,
      :nameRt,
      :nameRw
    ) = pengajuanSurat;
    final pdf = Document();

    final imgTtdRt = await _getImageTtd(ttdRt);
    final imgTtdRw = await _getImageTtd(ttdRw);

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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Text(
                        "Jakarta, ${(createdAt ?? DateTime.now()).formatWithoutTime}",
                        style: const TextStyle(color: PdfColors.white)),
                    Text("KETUA RW 09"),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: imgTtdRw ?? SizedBox(height: 32)),
                    Text(nameRw.isNotEmpty
                        ? nameRw
                        : "(.................................)")
                  ])),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Text(
                        "Jakarta, ${(createdAt ?? DateTime.now()).formatWithoutTime}"),
                    Text("KETUA RT 0$rt"),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: imgTtdRt ?? SizedBox(height: 32)),
                    Text(nameRt.isNotEmpty
                        ? nameRt
                        : "(.................................)")
                  ]))
            ])
          ]);
    }));
    return pdf.save();
  }

  Future<void> downloadPdf(PengajuanSurat pengajuanSurat) async {
    try {
      String? directoryPath = await FilePicker.platform.getDirectoryPath();

      if (directoryPath == null || directoryPath.isEmpty) {
        throw "Directory not found";
      }

      final fileName =
          "Pengajuan-Surat-${DateTime.now().formattedDate(pattern: "ddMMyy")}${pengajuanSurat.id}";
      final file = File("$directoryPath/$fileName.pdf");
      final resultPdf = await suratPengajuanPDf(pengajuanSurat);
      if (file.existsSync()) {
        await file.delete();
      }
      final locateFile = await file.writeAsBytes(resultPdf);
      logger.d(locateFile.path);
    } catch (e) {
      logger.e(e);
    }
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

  Future<Image?> _getImageTtd(String ttd) async {
    const size = 100.0;
    if (ttd.isEmpty) return null;
    if (ttd.isUrl()) {
      return Image(await networkImage(ttd), width: size, height: size);
    } else {
      return Image(MemoryImage(File(ttd).readAsBytesSync()),
          width: size, height: size, fit: BoxFit.cover);
    }
  }
}

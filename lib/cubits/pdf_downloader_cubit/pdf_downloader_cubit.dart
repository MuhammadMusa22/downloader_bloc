import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:external_path/external_path.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

part 'pdf_downloader_state.dart';

class PdfDownloaderCubit extends Cubit<PdfDownloaderState> {
  final List<String> _exPath = [];

  PdfDownloaderCubit() : super(PdfDownloaderInitial());

  final String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<bool> getStoragePermission() async {
    try {
      bool permissionStatus = await Permission.storage.request().isGranted;
      if (permissionStatus) {
        return true;
      } else {
        PermissionStatus permissionStatus = await Permission.storage.request();
        if (permissionStatus.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  downloadPdf({required String pdfUrl}) async {
    emit(PdfDownloading());
    bool storagePermission = await getStoragePermission();
    if (storagePermission) {
      await getPublicDirectoryPath();
      await loadPdfFromNetwork(pdfUrl);
    } else {
      emit(PermissionError());
    }
  }

  /// To get public storage directory path like Downloads, Picture, Movie etc.
  Future<void> getPublicDirectoryPath() async {
    String path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    _exPath.add(path);
  }

  Future<File> loadPdfFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return _storeFile(url, bytes);
  }

  Future<File> _storeFile(String url, List<int> bytes) async {
    const folderName = "Pdf Download Test";
    String filename = basename(url);

    int indexOfDot = filename.lastIndexOf('.');
    String fileExtension = filename.substring(indexOfDot, filename.length);
    filename = filename.substring(0, indexOfDot);
    filename = filename + getRandomString(2);
    filename = filename + fileExtension;
    final path = Directory("${_exPath[0]}/$folderName");
    late File file;
    if ((await path.exists())) {
      file = File('${path.path}/$filename');
      writeFile(file, bytes);
    } else {
      Directory directory = await path.create();
      file = File('${directory.path}/$filename');
      writeFile(file, bytes);
    }
    return file;
  }

  writeFile(File file, List<int> bytes) async {
    try {
      await file.writeAsBytes(bytes, flush: true);
      emit(PdfDownloaded(path: file.path));
    } on FileSystemException catch (fileException) {
      if (fileException.osError!.errorCode == 17) {
        emit(FileExist());
      }
    } catch (e) {
      emit(PdfDownloadingFailed());
    }
  }
}

part of 'pdf_downloader_cubit.dart';

abstract class PdfDownloaderState {}

class PdfDownloaderInitial extends PdfDownloaderState {}

class PdfDownloading extends PdfDownloaderState {}

class PdfDownloadingFailed extends PdfDownloaderState {}

class PdfDownloaded extends PdfDownloaderState {
  final String path;

  PdfDownloaded({required this.path});
}

class PermissionError extends PdfDownloaderState {}

class FileExist extends PdfDownloaderState {}

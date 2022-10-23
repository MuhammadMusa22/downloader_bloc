import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';

import '../../cubits/pdf_downloader_cubit/pdf_downloader_cubit.dart';
import '../widgets/snack_bar.dart';

class PdfDownloader extends StatefulWidget {
  final String pdfUrl;

  const PdfDownloader({required this.pdfUrl, Key? key}) : super(key: key);

  @override
  State<PdfDownloader> createState() => _PdfDownloaderState();
}

class _PdfDownloaderState extends State<PdfDownloader> {
  late PdfDownloaderCubit pdfDownloaderCubit;

  initCubits() {
    pdfDownloaderCubit = context.read<PdfDownloaderCubit>();
  }

  @override
  void initState() {
    super.initState();
    initCubits();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Pdf Viewer',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              pdfDownloaderCubit.downloadPdf(pdfUrl: widget.pdfUrl);
            },
            icon: BlocBuilder<PdfDownloaderCubit, PdfDownloaderState>(
              builder: (context, state) {
                if (state is PdfDownloading) {
                  return const CircularProgressIndicator(
                    color: Colors.blueAccent,
                  );
                }
                return const Icon(
                  Icons.download,
                  color: Colors.black,
                  size: 30,
                );
              },
            ),
          )
        ],
      ),
      body: BlocListener<PdfDownloaderCubit, PdfDownloaderState>(
        listener: (context, state) {
          if (state is PdfDownloaded) {
            CustomSnackBar.showSnackBar(message: 'Pdf Downloaded at ${state.path}', context: context);
          } else if (state is PdfDownloadingFailed) {
            CustomSnackBar.showSnackBar(message: 'Pdf Downloading Failed', context: context);
          } else if (state is PermissionError) {
            CustomSnackBar.showSnackBar(message: 'Permissions Not Allowed', context: context);
          } else if (state is FileExist) {
            CustomSnackBar.showSnackBar(message: 'File Already Exist', context: context);
          }
        },
        child: SafeArea(
          child: SizedBox(
            height: size.height,
            child: SfPdfViewer.network(
              widget.pdfUrl,
              pageLayoutMode: PdfPageLayoutMode.continuous,
              scrollDirection: PdfScrollDirection.vertical,
              canShowPaginationDialog: false,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:downloader/cubits/pdf_downloader_cubit/pdf_downloader_cubit.dart';
import 'package:downloader/views/screens/pdf_downloader_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PdfDownloaderCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const PdfDownloader(pdfUrl: 'https://www.africau.edu/images/default/sample.pdf'),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:neuroapp_task6/Provider/ImageUploadProvider.dart';
import 'package:neuroapp_task6/Provider/UserProvider.dart';
import 'package:neuroapp_task6/views/ImageUploadView.dart';
import 'package:neuroapp_task6/views/UserPage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ImageUploadProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
    // ChangeNotifierProvider(
    //   create: (_) => UserProvider(),
    //   child: const
    MaterialApp(debugShowCheckedModeBanner: false, home: ImageUploadView());
  }
}

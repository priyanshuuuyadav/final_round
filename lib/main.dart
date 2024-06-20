import 'package:final_assignment_app/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'controllers/news_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Final Assignment App',
      home: HomeScreen(),
      initialBinding: InitialBinding(),
    );
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NewsController()); // Register your controller here
  }
}
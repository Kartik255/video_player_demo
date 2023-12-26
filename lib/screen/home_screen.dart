import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player_demo/controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (HomeController controller) {
      return Scaffold(
        body: Center(
          child: MaterialButton(
            color: Colors.blue,
            onPressed: () => controller.requestPermissions(Permission.audio),
            child: const Text(
              "Go for Audios & Videos",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
  }
}

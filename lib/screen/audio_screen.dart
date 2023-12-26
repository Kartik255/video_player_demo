import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player_demo/controller/home_controller.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {

  HomeController homeController = Get.put(HomeController());
/*
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    homeController.requestPermissions();
  }*/
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (HomeController controller) {
        return controller.isLoading
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: controller.audioFiles.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(controller.audioFiles[index].path),
                  onTap: () {
                    // Implement audio playback logic here
                  },
                ),
              );
      },
    );
  }
}

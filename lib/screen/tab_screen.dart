import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player_demo/controller/audio_manager.dart';
import 'package:video_player_demo/controller/home_controller.dart';
import 'package:video_player_demo/screen/audio_screen.dart';
import 'package:video_player_demo/screen/video_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {

  HomeController homeController = Get.put(HomeController());
  AudioPlayerManager manager = AudioPlayerManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    manager = AudioPlayerManager();
    manager.init();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent,
          title: const Text(
            "Home Screen",
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Audio"),
              Tab(text: "Video"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AudioScreen(manager: manager!),
            const VideoScreen(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    manager.dispose();
    super.dispose();
  }
}

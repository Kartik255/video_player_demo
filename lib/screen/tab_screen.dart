import 'package:flutter/material.dart';
import 'package:video_player_demo/screen/audio_screen.dart';
import 'package:video_player_demo/screen/video_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
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
        body: const TabBarView(
          children: [
            AudioScreen(),
            VideoScreen(),
          ],
        ),
      ),
    );
  }
}

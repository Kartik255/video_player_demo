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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    homeController.permissionManage();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (HomeController controller) {
        return controller.isLoading
            ? Container(
                alignment: Alignment.center,
                height: 100,
                width: 100,
                child: const CircularProgressIndicator(),
              )
            : controller.listToShowAudio.isEmpty
                ? const Center(
                    child: Text("No Data Found!", style: TextStyle(color: Colors.blue)),
                  )
                : ListView.builder(
                    itemCount: controller.listToShowAudio.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(controller.listToShowAudio[index].path),
                      onTap: () {
                        // Implement audio playback logic here
                      },
                    ),
                  );
      },
    );
  }
}

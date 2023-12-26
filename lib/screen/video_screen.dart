import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player_demo/controller/home_controller.dart';
import 'package:video_player_demo/screen/video_preview_screen.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
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
            : controller.listToShowVideo.isEmpty
                ? const Center(
                    child: Text("No Data Found!", style: TextStyle(color: Colors.blue)),
                  )
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: controller.listToShowVideoThumb.length,
                      itemBuilder: (context, index) => Card(
                        elevation: 5,
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Image.memory(controller.listToShowVideoThumb[index]),
                          ),
                          title: Text(controller.listToShowVideo[index].path.split('/').last),
                          trailing: InkWell(
                            onTap: () => Get.to(
                                  () => VideoPreviewScreen(videoUrl: controller.listToShowVideo[index].path),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue.withOpacity(0.2),
                              child: const Icon(Icons.play_arrow),
                            ),
                          ),
                        ),
                      ),
                    ),
                );
      },
    );
  }
}

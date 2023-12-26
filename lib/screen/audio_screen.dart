import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player_demo/controller/audio_manager.dart';
import 'package:video_player_demo/controller/home_controller.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key, required this.manager});

  final AudioPlayerManager manager;

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> with WidgetsBindingObserver {
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    homeController.permissionManage();
    // widget.manager.init();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    homeController.isPlaying = false;
    homeController.initt();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      homeController.player.stop();
    }
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
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: controller.listToShowAudio.length,
                      itemBuilder: (context, index) => Card(
                        elevation: 5,
                        child: ListTile(
                          leading: const CircleAvatar(
                            // backgroundColor: Colors.blue.withOpacity(0.2),
                            child: Icon(Icons.music_note_sharp),
                          ),
                          title: Text(controller.listToShowAudio[index].path.split('/').last),
                          trailing: InkWell(
                            onTap: () {
                              homeController.player.stop();
                              homeController.player.setFilePath(controller.listToShowAudio[index].path);
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false, // user must tap button!
                                builder: (BuildContext context) {
                                  return GetBuilder(builder: (HomeController controller) {
                                    return AlertDialog(
                                      title: Text(controller.listToShowAudio[index].path.split('/').last),
                                      content: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            StreamBuilder(
                                              stream: widget.manager.durationState,
                                              builder: (context, snapshot) {
                                                final durationState = snapshot.data;
                                                final progress = durationState?.progress ?? Duration.zero;
                                                final buffered = durationState?.buffered ?? Duration.zero;
                                                final total = durationState?.total ?? Duration.zero;
                                                return ProgressBar(
                                                  progress: progress,
                                                  buffered: buffered,
                                                  total: total,
                                                  onSeek: (duration) {
                                                    homeController.player.seek(duration);
                                                  },
                                                );
                                              },
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                controller.isPlaying
                                                    ? IconButton(
                                                        onPressed: () => controller.updatePlaying(),
                                                        style: const ButtonStyle(
                                                          backgroundColor: MaterialStatePropertyAll(Colors.blue),
                                                        ),
                                                        icon: const Icon(Icons.pause, color: Colors.white),
                                                      )
                                                    : IconButton(
                                                        onPressed: () {
                                                          controller.player.play();
                                                          controller.isPlaying = true;
                                                          controller.update();
                                                        },
                                                        style: const ButtonStyle(
                                                          backgroundColor: MaterialStatePropertyAll(Colors.blue),
                                                        ),
                                                        icon: const Icon(Icons.play_arrow, color: Colors.white),
                                                      ),
                                                IconButton(
                                                  onPressed: () {
                                                    controller.player.stop();
                                                    controller.player.setFilePath(controller.listToShowAudio[index].path);
                                                    controller.isPlaying = false;
                                                    controller.update();
                                                  },
                                                  style: const ButtonStyle(
                                                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                                                  ),
                                                  icon: const Icon(Icons.stop, color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                },
                              );
                            },
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

  @override
  void dispose() {
    widget.manager.dispose();
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    homeController.player.dispose();
    super.dispose();
  }

  Future<void> _showMusicDialog(HomeController controller) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                StreamBuilder(
                  stream: widget.manager.durationState,
                  builder: (context, snapshot) {
                    final durationState = snapshot.data;
                    final progress = durationState?.progress ?? Duration.zero;
                    final buffered = durationState?.buffered ?? Duration.zero;
                    final total = durationState?.total ?? Duration.zero;
                    return ProgressBar(
                      progress: progress,
                      buffered: buffered,
                      total: total,
                      onSeek: (duration) {
                        homeController.player.seek(duration);
                      },
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.isPlaying
                        ? IconButton(
                            onPressed: () {
                              controller.player.pause();
                              controller.isPlaying = false;
                              controller.update();
                            },
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Colors.blue),
                            ),
                            icon: const Icon(Icons.pause, color: Colors.white),
                          )
                        : IconButton(
                            onPressed: () {
                              controller.player.play();
                              controller.isPlaying = true;
                              controller.update();
                            },
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Colors.blue),
                            ),
                            icon: const Icon(Icons.play_arrow, color: Colors.white),
                          ),
                    IconButton(
                      onPressed: () {
                        controller.player.stop();
                        controller.player
                            .setAsset("assets/songs/PAISA - Seven Hundred Fifty (Official song )- kushal pokhrel(MP3_160K).mp3");
                        controller.isPlaying = false;
                        controller.update();
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      ),
                      icon: const Icon(Icons.stop, color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:get/get.dart' as g;
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player_demo/controller/home_controller.dart';

const url = 'assets/songs/PAISA - Seven Hundred Fifty (Official song )- kushal pokhrel(MP3_160K).mp3';

class AudioPlayerManager {
  HomeController homeController = g.Get.put(HomeController());
  Stream<DurationState>? durationState;

  void init() {
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        homeController.player.positionStream,
        homeController.player.playbackEventStream,
            (position, playbackEvent) => DurationState(
          progress: position,
          buffered: playbackEvent.bufferedPosition,
          total: playbackEvent.duration,
        ));
    // homeController.player.setFilePath(url);
  }

  void dispose() {
    homeController.player.dispose();
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });
  final Duration progress;
  final Duration buffered;
  final Duration? total;
}
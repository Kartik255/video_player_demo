import 'dart:io';
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class HomeController extends GetxController {
  bool isLoading = false;
  final Directory _photoDirLong = Directory('/storage/emulated/0/Download');
  final Directory _photoDir = Directory('/storage/emulated/0/Download');
  List<FileSystemEntity> datalist = [];
  Permission storagePermission = Permission.audio;
  Permission manageStoragePermission = Permission.manageExternalStorage;
  Directory finalDirectory = Directory("");
  String tempPath = "";
  List<FileSystemEntity> listToShowAudio = [];
  List<FileSystemEntity> listToShowVideo = [];
  List<Uint8List> listToShowVideoThumb = [];
  List<FileSystemEntity> audioFiles = [];
  bool isPlaying = false;
  final player = AudioPlayer();

  permissionManage() async {
    isLoading = true;
    [
      Permission.audio,
      Permission.videos,
    ].request().then((value) async {
      if (await _photoDir.exists()) {
        tempPath = _photoDir.path;
        print("_photoDir.path :: ${_photoDir.path}");
        print("_photoDir.path :: ${tempPath}");
        fetchData();
      } else if (await _photoDirLong.exists()) {
        manageStoragePermission.request().then((value) async {
          tempPath = _photoDirLong.path;
          print("_photoDirLong.path :: ${_photoDirLong.path}");
          print("_photoDirLong.path :: ${tempPath}");
          fetchData();
        });
      }
    });

    /* if (await storagePermission.isDenied) {
      storagePermission.request().then((value) async {
        if (await _photoDir.exists()) {
          tempPath = _photoDir.path;
          print("_photoDir.path :: ${_photoDir.path}");
          print("_photoDir.path :: ${tempPath}");
          fetchData();
        } else if (await _photoDirLong.exists()) {
          manageStoragePermission.request().then((value) async {
            tempPath = _photoDirLong.path;
            print("_photoDirLong.path :: ${_photoDirLong.path}");
            print("_photoDirLong.path :: ${tempPath}");
            fetchData();
          });
        }
      });
    } else {
      fetchData();
    }*/
  }

  fetchData() async {
    datalist.clear();
    print("path :: $tempPath");
    finalDirectory = Directory(tempPath);
    datalist = finalDirectory.listSync();
    print(datalist);
    update();
    imageTap();
  }

  imageTap() {
    listToShowAudio.clear();
    listToShowVideo.clear();
    listToShowVideoThumb.clear();
    datalist.map((e) async {
      if(e.path.toString().endsWith(".mp3")
          || e.path.toString().endsWith(".aac")
          || e.path.toString().endsWith(".Ogg Vorbis")
          || e.path.toString().endsWith(".ALAC")
          || e.path.toString().endsWith(".WAV")
          || e.path.toString().endsWith(".AIFF")
          || e.path.toString().endsWith(".DSD")
          || e.path.toString().endsWith(".PCM")
          || e.path.toString().endsWith(".FLAC")
      ){
        listToShowAudio.add(e);
        isLoading = false;
        update();
      } else if(e.path.toString().endsWith(".mp4")
          || e.path.toString().endsWith(".MOV")
          || e.path.toString().endsWith(".AVI")
          || e.path.toString().endsWith(".WMV")
          || e.path.toString().endsWith(".AVCHD")
          || e.path.toString().endsWith(".FLV")
          || e.path.toString().endsWith(".F4V")
          || e.path.toString().endsWith(".SWF")
          || e.path.toString().endsWith(".MKV")
          || e.path.toString().endsWith(".WEBM")
          || e.path.toString().endsWith(".HTML5")
      ){
        listToShowVideoThumb.add(await videoThumb(path: e.path));
        isLoading = false;
        print("listToShowVideoThumb  :: ${listToShowVideoThumb.length}");
        print("listToShowVideoThumb  :: ${listToShowVideoThumb}");
        listToShowVideo.add(e);
        update();
      }
    }).toList();
    update();
  }

  videoThumb({required String path}) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
    isLoading = false;
    update();
    return uint8list;
  }

  Future<void> initt() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    player.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      // await player.setAsset("assets/songs/PAISA - Seven Hundred Fifty (Official song )- kushal pokhrel(MP3_160K).mp3");
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  updatePlaying(){
    player.pause();
    isPlaying = false;
    update();
  }

}

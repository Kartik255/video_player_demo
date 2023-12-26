import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  List<FileSystemEntity> audioFiles = [];
  bool isLoading = false;

  //  requestPermission() async {
  //   var status = await Permission.storage.request();
  //   if (status.isGranted) {
  //     getFiles();
  //   } else{
  //     requestPermission();
  //   }
  // }

  // Future<void> requestPermissions() async {
  //   Map<Permission, PermissionStatus> statuses = await[
  //     Permission.audio,
  //     Permission.videos,
  //   ].request();
  //   print("Permission:: ${statuses[Permission.audio]}");
  //   print("Permission:: ${statuses[Permission.videos]}");
  //   if (Platform.isAndroid) {
  //     final androidInfo = await DeviceInfoPlugin().androidInfo;
  //     print("Permission::${androidInfo.version.sdkInt} ");
  //     if (statuses[Permission.audio] != PermissionStatus.granted) {
  //       print("permission:: Denied");
  //       // requestPermissions();
  //     } else {
  //       // getFiles();
  //       print("permission:: Granted");
  //     }
  //   }
  // }

  Future<bool> requestPermissions(Permission setting) async {
    // setting.request() will return the status ALWAYS
    // if setting is already requested, it will return the status
    // final _result = await setting.request();
    // if(Platform.isAndroid){
    //   switch (_result) {
    //     case PermissionStatus.granted:
    //     case PermissionStatus.limited:
    //       return getFiles();
    //     case PermissionStatus.denied:
    //     case PermissionStatus.restricted:
    //     case PermissionStatus.permanentlyDenied:
    //       return requestPermissions(Permission.audio);
    //     case PermissionStatus.provisional:
    //       // TODO: Handle this case.
    //   }
    // }
      bool permissionGranted = false;
      DeviceInfoPlugin plugin = DeviceInfoPlugin();
      AndroidDeviceInfo android = await plugin.androidInfo;

      if (android.version.sdkInt < 33) {
        if (await Permission.storage.request().isGranted) {
          permissionGranted = true;
        } else if (await Permission.storage.request().isPermanentlyDenied) {
          Map<Permission, PermissionStatus> statuses = await [
            Permission.storage,
          ].request();

          if(statuses[Permission.storage]!.isGranted){
            permissionGranted = true;
          }else{
            permissionGranted = false;
            await openAppSettings();
          }
        }
      } else {
        permissionGranted = true;
        getFiles();
      }

      return permissionGranted;
  }

  void getFiles() async {
    isLoading = true;
    Directory directory = Directory('/storage/emulated/0/');
    if (await directory.exists()) {
      List<FileSystemEntity> files = directory.listSync();
      // Process the list of files
    } else {
      print('Directory does not exist');
    }
    String mp3Path = directory.toString();
    print("mp3Path:: $mp3Path");
    audioFiles = directory.listSync(recursive: true, followLinks: false);
    print("list :: $audioFiles");
    List<FileSystemEntity> _files;
    List<FileSystemEntity> _songs = [];
    // _files = directory.listSync(recursive: true, followLinks: false);
    // for(FileSystemEntity entity in _files) {
    //   String path = entity.path;
    //   if(path.endsWith('.mp3'))
    //     _songs.add(entity);
    // }
    // print(_songs);
    // print(_songs.length);
    isLoading = false;
    update();
  }
}

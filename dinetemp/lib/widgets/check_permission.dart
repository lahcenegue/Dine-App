import 'package:permission_handler/permission_handler.dart';

class CheckPermission {
  Future<bool> isStoragePermission() async {
    PermissionStatus isStorage = await Permission.storage.status;
    PermissionStatus isAccesLc = await Permission.accessMediaLocation.status;
    PermissionStatus isMangEx = await Permission.manageExternalStorage.status;
    if (!isMangEx.isGranted || isAccesLc.isGranted || isStorage.isGranted) {
      await Permission.storage.request();
      await Permission.accessMediaLocation.request();
      await Permission.manageExternalStorage.request();
      if (!isMangEx.isGranted || !isAccesLc.isGranted || !isStorage.isGranted) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}

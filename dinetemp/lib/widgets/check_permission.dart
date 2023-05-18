import 'package:dinetemp/main.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkPermissions() async {
  print('isPermission : $isPermission');
  bool permission = false;
  PermissionStatus isStorage = await Permission.storage.status;
  PermissionStatus isAccesLc = await Permission.accessMediaLocation.status;
  PermissionStatus isMangEx = await Permission.manageExternalStorage.status;
  print('storage: ${isStorage.isGranted}');
  print('isAccesLc: ${isAccesLc.isGranted}');
  print('isMangEx: ${isMangEx.isGranted}');
  if (!isStorage.isGranted) {
    await Permission.storage.request();
  } else if (!isAccesLc.isGranted) {
    await Permission.accessMediaLocation.request();
  } else if (!isMangEx.isGranted) {
    await Permission.manageExternalStorage.request();
  } else {
    permission = true;
  }
  print('permision check: $permission');
  isPermission = permission;
  return permission;
}

import '../data/sqldb.dart';

Future<bool> checkFavorite({required String id}) async {
  SqlDb sqlDb = SqlDb();
  bool isFavorite = false;
  List<Map> response =
      await sqlDb.readData("SELECT * FROM contentmodel WHERE id_content = $id");

  if (response.isEmpty) {
    isFavorite = false;
  } else {
    isFavorite = true;
  }
  return isFavorite;
}

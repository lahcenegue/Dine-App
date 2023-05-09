import '../data/sqldb.dart';

Future<bool> deleteFavorite({required String id}) async {
  SqlDb sqlDb = SqlDb();
  bool isFavorite = false;
  int delete =
      await sqlDb.deleteData("DELETE FROM contentmodel WHERE id_content= $id");
  if (delete.isFinite) {
    isFavorite = false;
  }

  return isFavorite;
}

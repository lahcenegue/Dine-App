import '../data/sqldb.dart';

Future<bool> addFavorite({required String id, title}) async {
  SqlDb sqlDb = SqlDb();
  bool isFavorite = false;
  int response = await sqlDb.insertData('''
                                     INSERT INTO contentmodel ("id_content" , "name")
                                     VALUES ("$id", "$title")
                                      ''');

  if (response > 0) {
    isFavorite = true;
  }
  return isFavorite;
}

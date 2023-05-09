import 'package:flutter/material.dart';

import '../data/sqldb.dart';
import 'add_favorite.dart';
import 'check_favorite.dart';
import 'delete_favorite.dart';

class ButtonFavorite extends StatefulWidget {
  final String id;
  final String title;
  const ButtonFavorite({
    super.key,
    required this.id,
    required this.title,
  });

  @override
  State<ButtonFavorite> createState() => _ButtonFavoriteState();
}

class _ButtonFavoriteState extends State<ButtonFavorite> {
  bool isFavorite = false;
  SqlDb sqlDb = SqlDb();

  @override
  void initState() {
    checkFavorite(id: widget.id).then((value) => setState(
          () {
            isFavorite = value;
          },
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isFavorite ? 'deleted' : 'add')));
        if (isFavorite == false) {
          addFavorite(id: widget.id, title: widget.title).then((value) {
            setState(
              () {
                isFavorite = true;
              },
            );
          });
        } else {
          deleteFavorite(id: widget.id).then(
            (value) => setState(
              () {
                isFavorite = false;
              },
            ),
          );
        }
      },
      icon: Icon(
        Icons.favorite_rounded,
        color: isFavorite ? Colors.red : Colors.white,
      ),
    );
  }
}

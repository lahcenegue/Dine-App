import 'package:dinetemp/data/categories_api.dart';
import 'package:dinetemp/models/categories_model.dart';
import 'package:dinetemp/view_model/categories_view_model.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  List<CategoriesViewModel>? listCateg;

//Categories list
  Future<void> fetchCategories() async {
    List<CategoriesModel> jsonMapCat = await CategoriesApi().loadData();

    jsonMapCat.removeWhere((element) => element.category == 'page');

    listCateg =
        jsonMapCat.map((e) => CategoriesViewModel(categories: e)).toList();
    notifyListeners();
  }
}

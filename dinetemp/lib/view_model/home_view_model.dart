import 'package:dinetemp/data/categories_api.dart';
import 'package:dinetemp/data/subcategories_api.dart';
import 'package:dinetemp/models/categories_model.dart';
import 'package:dinetemp/view_model/categories_view_model.dart';
import 'package:dinetemp/view_model/subcategories_view_model.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  List<CategoriesViewModel>? listCateg;
  List<SubCategoriesViewModel>? listSubCateg;
  List<SubMatterViewModel>? listSubMatter;

//Categories list
  Future<void> fetchCategoriesList() async {
    List<CategoriesModel> jsonMapCat = await CategoriesApi().loadData();

    jsonMapCat.removeWhere((element) => element.category == 'page');

    listCateg =
        jsonMapCat.map((e) => CategoriesViewModel(categories: e)).toList();
    notifyListeners();
  }

  //SubCategories List
  Future<void> fetchSubCategoriesList(String catid) async {
    List jsonMap = await SubCategoriesApi(catId: catid).loadSubCat();

    listSubCateg =
        jsonMap.map((e) => SubCategoriesViewModel(subcategories: e)).toList();

    notifyListeners();
  }

  // Matter List
  Future<void> fetchSubMatterList(String catid) async {
    List jsonMatter = await SubCategoriesApi(catId: catid).loadSubMatter();
    listSubMatter =
        jsonMatter.map((e) => SubMatterViewModel(matterModel: e)).toList();

    notifyListeners();
  }
}

import 'package:dinetemp/data/categories_api.dart';
import 'package:dinetemp/data/content_api.dart';
import 'package:dinetemp/data/subcategories_api.dart';
import 'package:dinetemp/models/categories_model.dart';
import 'package:dinetemp/view_model/categories_view_model.dart';
import 'package:dinetemp/view_model/subcategories_view_model.dart';
import 'package:flutter/material.dart';

import '../models/content_model.dart';
import 'content_view_model.dart';

class HomeViewModel extends ChangeNotifier {
  List<CategoriesViewModel>? listCateg;
  List<SubCategoriesViewModel>? listSubCateg;
  List<SubMatterViewModel>? listSubMatter;
  ContentViewModel? contentData;

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

  // Contents Data
  Future<void> fetchContentData(String catid) async {
    ContentModel jsonContent = await ContentApi(catId: catid).loadContentData();
    contentData = ContentViewModel(contentModel: jsonContent);

    notifyListeners();
  }
}

import 'package:dinetemp/main.dart';
import 'package:flutter/material.dart';

import '../view_model/home_view_model.dart';
import 'categorie_detail.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  HomeViewModel hvm = HomeViewModel();

  @override
  void initState() {
    super.initState();
    hvm.fetchCategoriesList();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    hvm.fetchCategoriesList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    hvm.addListener(() {
      setState(() {});
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: hvm.listCateg == null || hvm.listCateg!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: refreshData,
              child: ListView.builder(
                physics: const ScrollPhysics(),
                itemCount: hvm.listCateg!.length,
                itemBuilder: (buildContext, index) {
                  return Container(
                    margin: const EdgeInsets.only(
                      right: 25,
                      left: 25,
                      top: 10,
                      bottom: 10,
                    ),
                    padding: const EdgeInsets.only(right: 45),
                    decoration: BoxDecoration(
                      color: const Color(0xffF1F0FD),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          offset: const Offset(3, 4),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        hvm.listCateg![index].name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_back_ios_new),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategorieDetail(
                              catId: hvm.listCateg![index].id,
                              name: hvm.listCateg![index].name,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}

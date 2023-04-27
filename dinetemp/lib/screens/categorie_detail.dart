import 'package:dinetemp/constants/conatant.dart';
import 'package:dinetemp/screens/subcategorie_list.dart';
import 'package:dinetemp/screens/submatters_list.dart';
import 'package:dinetemp/view_model/home_view_model.dart';
import 'package:flutter/material.dart';

class CategorieDetail extends StatefulWidget {
  final String catId;
  final String name;

  const CategorieDetail({
    Key? key,
    required this.name,
    required this.catId,
  }) : super(key: key);

  @override
  State<CategorieDetail> createState() => _CategorieDetailState();
}

class _CategorieDetailState extends State<CategorieDetail> {
  HomeViewModel hvm = HomeViewModel();
  @override
  void initState() {
    super.initState();
    hvm.fetchSubCategoriesList(widget.catId);
    hvm.fetchSubMatterList(widget.catId);
  }

  @override
  Widget build(BuildContext context) {
    hvm.addListener(() {
      setState(() {});
    });

    if (hvm.listSubCateg == null || hvm.listSubMatter == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
          length:
              hvm.listSubCateg!.isEmpty || hvm.listSubMatter!.isEmpty ? 1 : 2,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              shadowColor: Colors.white,
              title: Text(widget.name),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(AppBar().preferredSize.height),
                child: Container(
                  color: const Color(0xFFfafafa),
                  height: 50,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      color: Colors.grey[200],
                    ),
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                        color: kMainColor,
                      ),
                      tabs: hvm.listSubCateg!.isEmpty
                          ? [
                              const Tab(
                                text: 'المواد',
                              )
                            ]
                          : hvm.listSubMatter!.isEmpty
                              ? [
                                  const Tab(text: 'الأقسام'),
                                ]
                              : [
                                  const Tab(text: 'الأقسام'),
                                  const Tab(text: 'المواد'),
                                ],
                    ),
                  ),
                ),
              ),
            ),
            body: hvm.listSubCateg!.isEmpty
                ? TabBarView(
                    children: [
                      // المواد
                      SubMattersList(
                        catName: widget.name,
                        catId: widget.catId,
                      ),
                    ],
                  )
                : hvm.listSubMatter!.isEmpty
                    ? TabBarView(
                        children: [
                          //الاقسام
                          SubCategoriesList(
                            catId: widget.catId,
                          ),
                        ],
                      )
                    : TabBarView(
                        children: [
                          //الاقسام
                          SubCategoriesList(
                            catId: widget.catId,
                          ),

                          // المواد
                          SubMattersList(
                            catId: widget.catId,
                            catName: widget.name,
                          ),
                        ],
                      ),
          ),
        ),
      );
    }
  }
}

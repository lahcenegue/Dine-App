import 'package:dinetemp/view_model/home_view_model.dart';
import 'package:flutter/material.dart';

class SubMattersList extends StatefulWidget {
  final String catId;

  final String catName;
  const SubMattersList({
    super.key,
    required this.catId,
    required this.catName,
  });

  @override
  State<SubMattersList> createState() => _SubMattersListState();
}

class _SubMattersListState extends State<SubMattersList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  HomeViewModel hvm = HomeViewModel();
  @override
  void initState() {
    super.initState();
    hvm.fetchSubMatterList(widget.catId);
  }

  Future refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    hvm.fetchSubMatterList(widget.catId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    hvm.addListener(() {
      setState(() {});
    });

    return hvm.listSubMatter == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: refreshData,
            child: ListView.builder(
              itemCount: hvm.listSubMatter!.length,
              itemBuilder: (buildContext, index) {
                return Container(
                  margin: const EdgeInsets.only(
                    right: 25,
                    left: 25,
                    top: 16,
                  ),
                  padding: const EdgeInsets.only(right: 27),
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
                      hvm.listSubMatter![index].name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_back_ios_new),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => CategorieDetail(
                      //       catId: hvm.listSubCateg![index].id,
                      //       name: hvm.listSubCateg![index].name,
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                );
              },
            ),
          );
  }
}

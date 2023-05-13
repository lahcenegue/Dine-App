import 'package:flutter/material.dart';

class DownloadList extends StatelessWidget {
  final String title;
  const DownloadList({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
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
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
        trailing:
            IconButton(onPressed: () {}, icon: const Icon(Icons.download)),
      ),
    );
  }
}

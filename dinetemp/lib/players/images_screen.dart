import 'package:flutter/material.dart';

class ImagesScreen extends StatefulWidget {
  final String title;
  final List<String> imagesLinks;
  const ImagesScreen({
    super.key,
    required this.title,
    required this.imagesLinks,
  });

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(10),
          itemCount: widget.imagesLinks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return Image.network(
              widget.imagesLinks[index],
              fit: BoxFit.fill,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, exception, stackTrace) {
                return Column(
                  children: const [
                    Center(
                      child: Icon(
                        Icons.error,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('حدث خطأ عند تحميل الصور، يرجى إعادة المحاولة'),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

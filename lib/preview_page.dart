import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/repository/repository.dart';

class PreviewPage extends StatelessWidget {
  final String imageUrl;
  final int imageID;

  const PreviewPage({
    super.key,
    required this.imageUrl,
    required this.imageID,
  });

  @override
  Widget build(BuildContext context) {
    Repository repository = Repository();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          repository.downloadImage(imageUrl: imageUrl, imageId: imageID, context: context);
        },
        backgroundColor: const Color.fromRGBO(230, 10, 10, .5),
        foregroundColor: const Color.fromRGBO(255, 255, 255, .5),
        child: const Icon(Icons.download),
      ),
      body: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}

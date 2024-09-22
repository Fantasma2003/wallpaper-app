import 'dart:convert';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:wallpaper_app/modal/modal.dart';
import 'package:http/http.dart' as http;

class Repository {
  final String apiKey =
      'yEjZfMewiYlr0Az9qXNvPptu5rWzcoqtpoDJOtjyCMG1QvMcxwU0iW0Z';
  final String baseURL = 'https://api.pexels.com/v1/';

  // Returns default images
  Future<List<Images>> getImagesList({required int? pageNumber}) async {
    String url = '';

    if (pageNumber == null) {
      url = '${baseURL}curated?per_page=80';
    } else {
      url = '${baseURL}curated?per_page=80&page=$pageNumber';
    }

    List<Images> imageList = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': apiKey,
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = jsonDecode(response.body);
        for (final json in jsonData["photos"] as Iterable) {
          final image = Images.fromJson(json);
          imageList.add(image);
        }
      }
    } catch (_) {}

    return imageList;
  }

  // Returns images by their ID
  Future<Images> getImageById({required int id}) async {
    final url = '${baseURL}photos/$id';
    Images image = Images.emptyConstructor();

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': apiKey,
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = jsonDecode(response.body);
        image = Images.fromJson(jsonData);
      }
    } catch (_) {}

    return image;
  }

  // Returns images based on what was searched
  Future<List<Images>> getImagesSearch({required String query}) async {
    String url = '${baseURL}search?query=$query&per_page=80';
    List<Images> imageList = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': apiKey,
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final jsonData = json.decode(response.body);
        for (final json in jsonData["photos"] as Iterable) {
          final image = Images.fromJson(json);
          imageList.add(image);
        }
      }
    } catch (_) {}

    return imageList;
  }

  Future<void> downloadImage({
    required String imageUrl,
    required int imageId,
    required BuildContext context,
  }) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        final bytes = response.bodyBytes;
        final directory = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS);

        final file = File('$directory/$imageId.png');
        await file.writeAsBytes(bytes);

        MediaScanner.loadMedia(path: file.path);

        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text("File's been saved at ${file.path}"),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (_) {}
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaper_app/preview_page.dart';
import 'package:wallpaper_app/repository/repository.dart';

import 'modal/modal.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Repository repo = Repository();
  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  late Future<List<Images>> imageList;
  int pageNumber = 1;
  final List<String> categories = [
    'Nature',
    'Abstract',
    'Technology',
    'Mountains',
    'Cars',
    'Bikes',
    'People',
  ];

  void getImageBySearch({required String query}) {
    imageList = repo.getImagesSearch(query: query);
    setState(() {});
  }

  @override
  void initState() {
    imageList = repo.getImagesList(pageNumber: pageNumber);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Wallpaper',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue,
                fontSize: 22,
              ),
            ),
            Text(
              'App',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.orange,
                fontSize: 22,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 25),
                    labelText: 'Search',
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: IconButton(
                        onPressed: () =>
                            getImageBySearch(query: textEditingController.text),
                        icon: const Icon(Icons.search),
                      ),
                    )),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp('[a-zA-Z0-9]'),
                  ),
                ],
                onSubmitted: (value) => getImageBySearch(query: value),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 40,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      getImageBySearch(query: categories[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: Center(
                            child: Text(categories[index]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: imageList,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: MasonryGridView.count(
                          itemCount: snapshot.data?.length,
                          controller: scrollController,
                          shrinkWrap: true,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          crossAxisCount: 2,
                          itemBuilder: (context, index) {
                            double height = (index % 10 + 1) * 100;

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PreviewPage(
                                      imageUrl: snapshot.data![index].imagePortrait,
                                      imageID: snapshot.data![index].imageID,
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  height: height > 300 ? 300 : height,
                                  fit: BoxFit.cover,
                                  imageUrl: snapshot.data![index].imagePortrait,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (snapshot.data!.isNotEmpty) const SizedBox(height: 10),
                      if (snapshot.data!.isNotEmpty)
                        MaterialButton(
                          onPressed: () async {
                            pageNumber++;
                            imageList =
                                repo.getImagesList(pageNumber: pageNumber);
                            setState(() {});
                          },
                          minWidth: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: const Center(child: Text('Load More...')),
                        ),
                      if (snapshot.data!.isEmpty)
                        const Center(
                          child: Text('No Image associated'),
                        )
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

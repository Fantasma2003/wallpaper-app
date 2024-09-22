class Images {
  final int imageID;
  final String imageAlt;
  final String imagePortrait;

  Images({
    required this.imageID,
    required this.imageAlt,
    required this.imagePortrait,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      imageID: json["id"] as int,
      imageAlt: json["alt"] as String,
      imagePortrait: json["src"]["portrait"] as String,
    );
  }

  Images.emptyConstructor({
    this.imageID = 0,
    this.imageAlt = '',
    this.imagePortrait = '',
  });
}

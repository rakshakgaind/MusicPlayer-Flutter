// To parse this JSON data, do
//
//     final ArtistPlayListScreenModel = ArtistPlayListScreenModelFromJson(jsonString);

import 'dart:convert';

ArtistPlayListScreenModel ArtistPlayListScreenModelFromJson(String str) => ArtistPlayListScreenModel.fromJson(json.decode(str));

String ArtistPlayListScreenModelToJson(ArtistPlayListScreenModel data) => json.encode(data.toJson());

class ArtistPlayListScreenModel {
  ArtistPlayListScreenModel({
    this.href,
    this.items,
    this.limit,
    this.next,
    this.offset,
    this.previous,
    this.total,
  });

  String? href;
  List<Item>? items;
  int? limit;
  String? next;
  int? offset;
  dynamic previous;
  int? total;

  factory ArtistPlayListScreenModel.fromJson(Map<String, dynamic> json) => ArtistPlayListScreenModel(
    href: json["href"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    limit: json["limit"],
    next: json["next"],
    offset: json["offset"],
    previous: json["previous"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "href": href,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    "limit": limit,
    "next": next,
    "offset": offset,
    "previous": previous,
    "total": total,
  };
}

class Item {
  Item({
    this.albumGroup,
    this.albumType,
    this.artists,
    this.availableMarkets,
    this.externalUrls,
    this.href2,
    this.id,
    this.images,
    this.name,
    this.releaseDate,
    this.releaseDatePrecision,
    this.totalTracks,
    this.type,
    this.uri,
  });

  String? albumGroup;
  String? albumType;
  String? type;
  List<Artist>? artists;
  List<String>? availableMarkets;
  ExternalUrls? externalUrls;
  String? href2;
  String? id;
  List<Image>? images;
  String? name;
  String? releaseDate;
  ReleaseDatePrecision? releaseDatePrecision;
  int? totalTracks;
  String? uri;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    albumGroup: json["album_group"],
    albumType: json["album_type"],
    type: json["type"],
    artists: json["artists"] == null ? [] : List<Artist>.from(json["artists"]!.map((x) => Artist.fromJson(x))),
    availableMarkets: json["available_markets"] == null ? [] : List<String>.from(json["available_markets"]!.map((x) => x)),
    externalUrls: json["external_urls"] == null ? null : ExternalUrls.fromJson(json["external_urls"]),
    href2: json["href"],
    id: json["id"],
    images: json["images"] == null ? [] : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
    name: json["name"],
    releaseDate: json["release_date"],
    releaseDatePrecision: releaseDatePrecisionValues.map[json["release_date_precision"]]!,
    totalTracks: json["total_tracks"],
    uri: json["uri"],
  );

  Map<String, dynamic> toJson() => {
    "album_group": albumGroup,
    "album_type": albumType,
    "type": type,
    "artists": artists == null ? [] : List<dynamic>.from(artists!.map((x) => x.toJson())),
    "available_markets": availableMarkets == null ? [] : List<dynamic>.from(availableMarkets!.map((x) => x)),
    "external_urls": externalUrls?.toJson(),
    "href": href2,
    "id": id,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
    "name": name,
    "release_date": releaseDate,
    "release_date_precision": releaseDatePrecisionValues.reverse[releaseDatePrecision],
    "total_tracks": totalTracks,

    "uri": uri,
  };
}

/*enum AlbumGroup { ALBUM }

final albumGroupValues = EnumValues({
  "album": AlbumGroup.ALBUM
});*/

class Artist {
  Artist({
    this.externalUrls,
    this.href,
    this.id,
    this.name,
    this.type,
    this.uri,
  });

  ExternalUrls? externalUrls;
  String? href;
  String? id;
  String? name;
  Type? type;
  String? uri;

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
    externalUrls: json["external_urls"] == null ? null : ExternalUrls.fromJson(json["external_urls"]),
    href: json["href"],
    id: json["id"],
    name: json["name"],
    type: typeValues.map[json["type"]]!,
    uri: json["uri"],
  );

  Map<String, dynamic> toJson() => {
    "external_urls": externalUrls?.toJson(),
    "href": href,
    "id": id,
    "name": name,
    "type": typeValues.reverse[type],
    "uri": uri,
  };
}

class ExternalUrls {
  ExternalUrls({
    this.spotify,
  });

  String? spotify;

  factory ExternalUrls.fromJson(Map<String, dynamic> json) => ExternalUrls(
    spotify: json["spotify"],
  );

  Map<String, dynamic> toJson() => {
    "spotify": spotify,
  };
}

enum Type { ARTIST }

final typeValues = EnumValues({
  "artist": Type.ARTIST
});

class Image {
  Image({
    this.height,
    this.url,
    this.width,
  });

  int? height;
  String? url;
  int? width;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    height: json["height"],
    url: json["url"],
    width: json["width"],
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "url": url,
    "width": width,
  };
}

enum ReleaseDatePrecision { DAY, YEAR }

final releaseDatePrecisionValues = EnumValues({
  "day": ReleaseDatePrecision.DAY,
  "year": ReleaseDatePrecision.YEAR
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

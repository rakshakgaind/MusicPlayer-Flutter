// To parse this JSON data, do
//
//     final AlbumTrackModel = AlbumTrackModelFromJson(jsonString);

import 'dart:convert';

AlbumTrackModel AlbumTrackModelFromJson(String str) => AlbumTrackModel.fromJson(json.decode(str));

String AlbumTrackModelToJson(AlbumTrackModel data) => json.encode(data.toJson());

class AlbumTrackModel {
  AlbumTrackModel({
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
  dynamic next;
  int? offset;
  dynamic previous;
  int? total;

  factory AlbumTrackModel.fromJson(Map<String, dynamic> json) => AlbumTrackModel(
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
    this.artists,
    this.availableMarkets,
    this.discNumber,
    this.durationMs,
    this.explicit,
    this.externalUrls,
    this.href,
    this.id,
    this.isLocal,
    this.name,
    this.previewUrl,
    this.trackNumber,
    this.type,
    this.uri,
  });

  List<Artist>? artists;
  List<String>? availableMarkets;
  int? discNumber;
  int? durationMs;
  bool? explicit;
  ExternalUrls? externalUrls;
  String? href;
  String? id;
  bool? isLocal;
  String? name;
  String? previewUrl;
  int? trackNumber;
  String? type;
  String? uri;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    artists: json["artists"] == null ? [] : List<Artist>.from(json["artists"]!.map((x) => Artist.fromJson(x))),
    availableMarkets: json["available_markets"] == null ? [] : List<String>.from(json["available_markets"]!.map((x) => x)),
    discNumber: json["disc_number"],
    durationMs: json["duration_ms"],
    explicit: json["explicit"],
    externalUrls: json["external_urls"] == null ? null : ExternalUrls.fromJson(json["external_urls"]),
    href: json["href"],
    id: json["id"],
    isLocal: json["is_local"],
    name: json["name"],
    previewUrl: json["preview_url"],
    trackNumber: json["track_number"],
    type: json["type"],
    uri: json["uri"],
  );

  Map<String, dynamic> toJson() => {
    "artists": artists == null ? [] : List<dynamic>.from(artists!.map((x) => x.toJson())),
    "available_markets": availableMarkets == null ? [] : List<dynamic>.from(availableMarkets!.map((x) => x)),
    "disc_number": discNumber,
    "duration_ms": durationMs,
    "explicit": explicit,
    "external_urls": externalUrls?.toJson(),
    "href": href,
    "id": id,
    "is_local": isLocal,
    "name": name,
    "preview_url": previewUrl,
    "track_number": trackNumber,
    "type": type,
    "uri": uri,
  };
}

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

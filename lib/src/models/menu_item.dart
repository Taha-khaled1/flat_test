// To parse this JSON data, do
//
//     final menuItem = menuItemFromJson(jsonString);

import 'dart:convert';

MenuItem menuItemFromJson(String str) => MenuItem.fromJson(json.decode(str));

String menuItemToJson(MenuItem data) => json.encode(data.toJson());

class MenuItem {
  MenuItem({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.customFields,
    this.hasMedia,
    this.media,
  });

  int id;
  String name;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> customFields;
  bool hasMedia;
  List<Media> media;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    customFields: List<dynamic>.from(json["custom_fields"].map((x) => x)),
    hasMedia: json["has_media"],
    media: List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "custom_fields": List<dynamic>.from(customFields.map((x) => x)),
    "has_media": hasMedia,
    "media": List<dynamic>.from(media.map((x) => x.toJson())),
  };
}

class Media {
  Media({
    this.id,
    this.modelType,
    this.modelId,
    this.collectionName,
    this.name,
    this.fileName,
    this.mimeType,
    this.disk,
    this.size,
    this.manipulations,
    this.customProperties,
    this.responsiveImages,
    this.orderColumn,
    this.createdAt,
    this.updatedAt,
    this.url,
    this.thumb,
    this.icon,
    this.formatedSize,
  });

  int id;
  String modelType;
  int modelId;
  String collectionName;
  String name;
  String fileName;
  String mimeType;
  String disk;
  int size;
  List<dynamic> manipulations;
  CustomProperties customProperties;
  List<dynamic> responsiveImages;
  int orderColumn;
  DateTime createdAt;
  DateTime updatedAt;
  String url;
  String thumb;
  String icon;
  String formatedSize;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    modelType: json["model_type"],
    modelId: json["model_id"],
    collectionName: json["collection_name"],
    name: json["name"],
    fileName: json["file_name"],
    mimeType: json["mime_type"],
    disk: json["disk"],
    size: json["size"],
    manipulations: List<dynamic>.from(json["manipulations"].map((x) => x)),
    customProperties: CustomProperties.fromJson(json["custom_properties"]),
    responsiveImages: List<dynamic>.from(json["responsive_images"].map((x) => x)),
    orderColumn: json["order_column"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    url: json["url"],
    thumb: json["thumb"],
    icon: json["icon"],
    formatedSize: json["formated_size"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "model_type": modelType,
    "model_id": modelId,
    "collection_name": collectionName,
    "name": name,
    "file_name": fileName,
    "mime_type": mimeType,
    "disk": disk,
    "size": size,
    "manipulations": List<dynamic>.from(manipulations.map((x) => x)),
    "custom_properties": customProperties.toJson(),
    "responsive_images": List<dynamic>.from(responsiveImages.map((x) => x)),
    "order_column": orderColumn,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "url": url,
    "thumb": thumb,
    "icon": icon,
    "formated_size": formatedSize,
  };
}

class CustomProperties {
  CustomProperties({
    this.uuid,
    this.userId,
    this.generatedConversions,
  });

  String uuid;
  int userId;
  GeneratedConversions generatedConversions;

  factory CustomProperties.fromJson(Map<String, dynamic> json) => CustomProperties(
    uuid: json["uuid"],
    userId: json["user_id"],
    generatedConversions: GeneratedConversions.fromJson(json["generated_conversions"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "user_id": userId,
    "generated_conversions": generatedConversions.toJson(),
  };
}

class GeneratedConversions {
  GeneratedConversions({
    this.thumb,
    this.icon,
  });

  bool thumb;
  bool icon;

  factory GeneratedConversions.fromJson(Map<String, dynamic> json) => GeneratedConversions(
    thumb: json["thumb"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "thumb": thumb,
    "icon": icon,
  };
}

// To parse this JSON data, do
//
//     final countries = countriesFromJson(jsonString);

import 'dart:convert';

Countries countriesFromJson(String str) => Countries.fromJson(json.decode(str));

String countriesToJson(Countries data) => json.encode(data.toJson());

class Countries {
  Countries({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  factory Countries.fromJson(Map<String, dynamic> json) => Countries(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message == null ? null : message,
  };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.description,
    this.currency,
    this.equation,
    this.createdAt,
    this.updatedAt,
    this.customFields,
    this.restaurants,
    this.hasMedia,
    this.media,
  });

  int id;
  String name;
  String description;
  String currency;
  String equation;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> customFields;
  List<Restaurant> restaurants;
  bool hasMedia;
  List<Media> media;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    currency: json["currency"] == null ? null : json["currency"],
    equation: json["equation"] == null ? null : json["equation"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    customFields: json["custom_fields"] == null ? null : List<dynamic>.from(json["custom_fields"].map((x) => x)),
    restaurants: json["restaurants"] == null ? null : List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
    hasMedia: json["has_media"] == null ? null : json["has_media"],
    media: json["media"] == null ? null : List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "description": description == null ? null : description,
    "currency": currency == null ? null : currency,
    "equation": equation == null ? null : equation,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "custom_fields": customFields == null ? null : List<dynamic>.from(customFields.map((x) => x)),
    "restaurants": restaurants == null ? null : List<dynamic>.from(restaurants.map((x) => x.toJson())),
    "has_media": hasMedia == null ? null : hasMedia,
    "media": media == null ? null : List<dynamic>.from(media.map((x) => x.toJson())),
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
    id: json["id"] == null ? null : json["id"],
    modelType: json["model_type"] == null ? null : json["model_type"],
    modelId: json["model_id"] == null ? null : json["model_id"],
    collectionName: json["collection_name"] == null ? null : json["collection_name"],
    name: json["name"] == null ? null : json["name"],
    fileName: json["file_name"] == null ? null : json["file_name"],
    mimeType: json["mime_type"] == null ? null : json["mime_type"],
    disk: json["disk"] == null ? null : json["disk"],
    size: json["size"] == null ? null : json["size"],
    manipulations: json["manipulations"] == null ? null : List<dynamic>.from(json["manipulations"].map((x) => x)),
    customProperties: json["custom_properties"] == null ? null : CustomProperties.fromJson(json["custom_properties"]),
    responsiveImages: json["responsive_images"] == null ? null : List<dynamic>.from(json["responsive_images"].map((x) => x)),
    orderColumn: json["order_column"] == null ? null : json["order_column"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    url: json["url"] == null ? null : json["url"],
    thumb: json["thumb"] == null ? null : json["thumb"],
    icon: json["icon"] == null ? null : json["icon"],
    formatedSize: json["formated_size"] == null ? null : json["formated_size"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "model_type": modelType == null ? null : modelType,
    "model_id": modelId == null ? null : modelId,
    "collection_name": collectionName == null ? null : collectionName,
    "name": name == null ? null : name,
    "file_name": fileName == null ? null : fileName,
    "mime_type": mimeType == null ? null : mimeType,
    "disk": disk == null ? null : disk,
    "size": size == null ? null : size,
    "manipulations": manipulations == null ? null : List<dynamic>.from(manipulations.map((x) => x)),
    "custom_properties": customProperties == null ? null : customProperties.toJson(),
    "responsive_images": responsiveImages == null ? null : List<dynamic>.from(responsiveImages.map((x) => x)),
    "order_column": orderColumn == null ? null : orderColumn,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "url": url == null ? null : url,
    "thumb": thumb == null ? null : thumb,
    "icon": icon == null ? null : icon,
    "formated_size": formatedSize == null ? null : formatedSize,
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
    uuid: json["uuid"] == null ? null : json["uuid"],
    userId: json["user_id"] == null ? null : json["user_id"],
    generatedConversions: json["generated_conversions"] == null ? null : GeneratedConversions.fromJson(json["generated_conversions"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid == null ? null : uuid,
    "user_id": userId == null ? null : userId,
    "generated_conversions": generatedConversions == null ? null : generatedConversions.toJson(),
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
    thumb: json["thumb"] == null ? null : json["thumb"],
    icon: json["icon"] == null ? null : json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "thumb": thumb == null ? null : thumb,
    "icon": icon == null ? null : icon,
  };
}

class Restaurant {
  Restaurant({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.pivot,
  });

  int id;
  String name;
  String latitude;
  String longitude;
  Pivot pivot;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    latitude: json["latitude"] == null ? null : json["latitude"],
    longitude: json["longitude"] == null ? null : json["longitude"],
    pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "pivot": pivot == null ? null : pivot.toJson(),
  };
}

class Pivot {
  Pivot({
    this.cuisineId,
    this.restaurantId,
  });

  int cuisineId;
  int restaurantId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    cuisineId: json["cuisine_id"] == null ? null : json["cuisine_id"],
    restaurantId: json["restaurant_id"] == null ? null : json["restaurant_id"],
  );

  Map<String, dynamic> toJson() => {
    "cuisine_id": cuisineId == null ? null : cuisineId,
    "restaurant_id": restaurantId == null ? null : restaurantId,
  };
}
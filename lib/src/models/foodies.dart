// To parse this JSON data, do
//
//     final foods = foodsFromJson(jsonString);

import 'dart:convert';

Foods foodsFromJson(String str) => Foods.fromJson(json.decode(str));

String foodsToJson(Foods data) => json.encode(data.toJson());

class Foods {
  Foods({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  factory Foods.fromJson(Map<String, dynamic> json) => Foods(
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
    this.price,
    this.discountPrice,
    this.description,
    this.ingredients,
    this.packageItemsCount,
    this.weight,
    this.unit,
    this.featured,
    this.deliverable,
    this.restaurantId,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.customFields,
    this.hasMedia,
    this.restaurant,
    this.media,
  });

  int id;
  String name;
  double price;
  double discountPrice;
  String description;
  String ingredients;
  int packageItemsCount;
  double weight;
  String unit;
  bool featured;
  bool deliverable;
  int restaurantId;
  int categoryId;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> customFields;
  bool hasMedia;
  Restaurant restaurant;
  List<Media> media;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    price: json["price"] == null ? null : json["price"].toDouble(),
    discountPrice: json["discount_price"] == null ? null : json["discount_price"].toDouble(),
    description: json["description"] == null ? null : json["description"],
    ingredients: json["ingredients"] == null ? null : json["ingredients"],
    packageItemsCount: json["package_items_count"] == null ? null : json["package_items_count"],
    weight: json["weight"] == null ? null : json["weight"].toDouble(),
    unit: json["unit"] == null ? null : json["unit"],
    featured: json["featured"] == null ? null : json["featured"],
    deliverable: json["deliverable"] == null ? null : json["deliverable"],
    restaurantId: json["restaurant_id"] == null ? null : json["restaurant_id"],
    categoryId: json["category_id"] == null ? null : json["category_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    customFields: json["custom_fields"] == null ? null : List<dynamic>.from(json["custom_fields"].map((x) => x)),
    hasMedia: json["has_media"] == null ? null : json["has_media"],
    restaurant: json["restaurant"] == null ? null : Restaurant.fromJson(json["restaurant"]),
    media: json["media"] == null ? null : List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "price": price == null ? null : price,
    "discount_price": discountPrice == null ? null : discountPrice,
    "description": description == null ? null : description,
    "ingredients": ingredients == null ? null : ingredients,
    "package_items_count": packageItemsCount == null ? null : packageItemsCount,
    "weight": weight == null ? null : weight,
    "unit": unit == null ? null : unit,
    "featured": featured == null ? null : featured,
    "deliverable": deliverable == null ? null : deliverable,
    "restaurant_id": restaurantId == null ? null : restaurantId,
    "category_id": categoryId == null ? null : categoryId,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "custom_fields": customFields == null ? null : List<dynamic>.from(customFields.map((x) => x)),
    "has_media": hasMedia == null ? null : hasMedia,
    "restaurant": restaurant == null ? null : restaurant.toJson(),
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
    this.deliveryFee,
    this.address,
    this.phone,
    this.defaultTax,
    this.availableForDelivery,
  });

  int id;
  String name;
  int deliveryFee;
  String address;
  String phone;
  int defaultTax;
  bool availableForDelivery;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    deliveryFee: json["delivery_fee"] == null ? null : json["delivery_fee"],
    address: json["address"] == null ? null : json["address"],
    phone: json["phone"] == null ? null : json["phone"],
    defaultTax: json["default_tax"] == null ? null : json["default_tax"],
    availableForDelivery: json["available_for_delivery"] == null ? null : json["available_for_delivery"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "delivery_fee": deliveryFee == null ? null : deliveryFee,
    "address": address == null ? null : address,
    "phone": phone == null ? null : phone,
    "default_tax": defaultTax == null ? null : defaultTax,
    "available_for_delivery": availableForDelivery == null ? null : availableForDelivery,
  };
}
class Categories {
  Categories({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  Categories copyWith({
    bool success,
    List<Datum> data,
    String message,
  }) =>
      Categories(
        success: success ?? this.success,
        data: data ?? this.data,
        message: message ?? this.message,
      );
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

  Datum copyWith({
    int id,
    String name,
    double price,
    double discountPrice,
    String description,
    String ingredients,
    int packageItemsCount,
    double weight,
    String unit,
    bool featured,
    bool deliverable,
    int restaurantId,
    int categoryId,
    DateTime createdAt,
    DateTime updatedAt,
    List<dynamic> customFields,
    bool hasMedia,
    Restaurant restaurant,
    List<Media> media,
  }) =>
      Datum(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        discountPrice: discountPrice ?? this.discountPrice,
        description: description ?? this.description,
        ingredients: ingredients ?? this.ingredients,
        packageItemsCount: packageItemsCount ?? this.packageItemsCount,
        weight: weight ?? this.weight,
        unit: unit ?? this.unit,
        featured: featured ?? this.featured,
        deliverable: deliverable ?? this.deliverable,
        restaurantId: restaurantId ?? this.restaurantId,
        categoryId: categoryId ?? this.categoryId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        customFields: customFields ?? this.customFields,
        hasMedia: hasMedia ?? this.hasMedia,
        restaurant: restaurant ?? this.restaurant,
        media: media ?? this.media,
      );
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

  Media copyWith({
    int id,
    String modelType,
    int modelId,
    String collectionName,
    String name,
    String fileName,
    String mimeType,
    String disk,
    int size,
    List<dynamic> manipulations,
    CustomProperties customProperties,
    List<dynamic> responsiveImages,
    int orderColumn,
    DateTime createdAt,
    DateTime updatedAt,
    String url,
    String thumb,
    String icon,
    String formatedSize,
  }) =>
      Media(
        id: id ?? this.id,
        modelType: modelType ?? this.modelType,
        modelId: modelId ?? this.modelId,
        collectionName: collectionName ?? this.collectionName,
        name: name ?? this.name,
        fileName: fileName ?? this.fileName,
        mimeType: mimeType ?? this.mimeType,
        disk: disk ?? this.disk,
        size: size ?? this.size,
        manipulations: manipulations ?? this.manipulations,
        customProperties: customProperties ?? this.customProperties,
        responsiveImages: responsiveImages ?? this.responsiveImages,
        orderColumn: orderColumn ?? this.orderColumn,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        url: url ?? this.url,
        thumb: thumb ?? this.thumb,
        icon: icon ?? this.icon,
        formatedSize: formatedSize ?? this.formatedSize,
      );
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

  CustomProperties copyWith({
    String uuid,
    int userId,
    GeneratedConversions generatedConversions,
  }) =>
      CustomProperties(
        uuid: uuid ?? this.uuid,
        userId: userId ?? this.userId,
        generatedConversions: generatedConversions ?? this.generatedConversions,
      );
}

class GeneratedConversions {
  GeneratedConversions({
    this.thumb,
    this.icon,
  });

  bool thumb;
  bool icon;

  GeneratedConversions copyWith({
    bool thumb,
    bool icon,
  }) =>
      GeneratedConversions(
        thumb: thumb ?? this.thumb,
        icon: icon ?? this.icon,
      );
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

  Restaurant copyWith({
    int id,
    String name,
    int deliveryFee,
    String address,
    String phone,
    int defaultTax,
    bool availableForDelivery,
  }) =>
      Restaurant(
        id: id ?? this.id,
        name: name ?? this.name,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        defaultTax: defaultTax ?? this.defaultTax,
        availableForDelivery: availableForDelivery ?? this.availableForDelivery,
      );
}

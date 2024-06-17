import 'dart:convert';

import 'package:get/get.dart';

import 'product_image_model.dart';

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.discountPrice,
    required this.images,
    this.description,
    this.returnTerms,
    this.isPrescriptionDrugs,
    this.ratingAverage,
    this.ratingCount,
    this.reviewCount,
    this.createdAt,
    this.updatedAt,
    this.categories,
  });

  final String id;
  final String name;
  final int price;
  final int discountPrice;
  final List<ProductImageModel>? images;
  final bool? isPrescriptionDrugs;
  final String? description;
  final String? returnTerms;
  final String? ratingAverage;
  final int? ratingCount;
  final int? reviewCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<CategoryModel>? categories;

  final RxBool _isFavorite = false.obs;
  bool get isFavorite => _isFavorite.value;
  set isFavorite(bool newValue) => _isFavorite.value = newValue;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'],
        name: json['name'],
        images: (json['images'] as List<dynamic>?)
            ?.map((e) => ProductImageModel.fromJson(e))
            .toList(),
        price: json['price'],
        discountPrice: json['price_after_discount'],
        isPrescriptionDrugs: json['is_prescription_drugs'],
        description: json['description'],
        returnTerms: json['refund_terms_and_condition'],
        ratingAverage: json['rating_average'],
        ratingCount: json['rating_count'],
        reviewCount: json['review_count'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
        categories: (json['categories'] as List<dynamic>?)
            ?.map((e) => CategoryModel.fromJson(e))
            .toList(),
      )..isFavorite = json['isFavorite'] == 1;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'discountPrice': discountPrice,
      'images': jsonEncode(images?.map((e) => e.toJson()).toList() ?? []),
      'isPrescriptionDrugs': isPrescriptionDrugs == true ? 1 : 0,
      'description': description ?? '',
      'returnTerms': returnTerms ?? '',
      'ratingAverage': ratingAverage ?? '',
      'ratingCount': ratingCount ?? 0,
      'reviewCount': reviewCount ?? 0,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      discountPrice: map['discountPrice'],
      images: (jsonDecode(map['images']) as List<dynamic>)
          .map((e) => ProductImageModel.fromJson(e))
          .toList(),
      isPrescriptionDrugs: map['isPrescriptionDrugs'] == 1,
      description: map['description'],
      returnTerms: map['returnTerms'],
      ratingAverage: map['ratingAverage'],
      ratingCount: map['ratingCount'],
      reviewCount: map['reviewCount'],
    )..isFavorite = map['isFavorite'] == 1;
  }
}

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

enum ProductSort {
  newest,
  priceAscending,
  priceDescending,
  nameAscending,
  nameDescending,
}

extension SortExtension on ProductSort {
  String get name {
    switch (this) {
      case ProductSort.newest:
        return 'Newest';
      case ProductSort.priceAscending:
        return 'Price: Low to High';
      case ProductSort.priceDescending:
        return 'Price: High to Low';
      case ProductSort.nameAscending:
        return 'Alphabet: A to Z';
      case ProductSort.nameDescending:
        return 'Alphabet: Z to A';
      default:
        return 'Newest';
    }
  }
}

class SortType {
  static String getSortByValue(ProductSort sort) {
    switch (sort) {
      case ProductSort.newest:
        return 'created_at';
      case ProductSort.nameAscending:
        return 'name';
      case ProductSort.nameDescending:
        return 'name';
      case ProductSort.priceAscending:
        return 'price';
      case ProductSort.priceDescending:
        return 'price';
      default:
        return 'id';
    }
  }

  static String getSortColumnValue(ProductSort sort) {
    switch (sort) {
      case ProductSort.newest:
        return 'desc';
      case ProductSort.nameAscending:
        return 'asc';
      case ProductSort.nameDescending:
        return 'desc';
      case ProductSort.priceAscending:
        return 'asc';
      case ProductSort.priceDescending:
        return 'desc';
      default:
        return 'asc';
    }
  }
}

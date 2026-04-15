// Server-driven UI entities — each field maps to a remotely configurable value

import 'package:flutter/material.dart';

class DeliveryInfoEntity {
  final String deliveryTime;
  final String deliveryUnit;
  final String distance;
  final String locationName;

  const DeliveryInfoEntity({
    required this.deliveryTime,
    required this.deliveryUnit,
    required this.distance,
    required this.locationName,
  });
}

class CategoryEntity {
  final String id;
  final String label;
  final String iconUrl;
  final bool isNew;

  const CategoryEntity({
    required this.id,
    required this.label,
    required this.iconUrl,
    this.isNew = false,
  });
}

class BannerEntity {
  final String id;
  final String imageUrl;
  final String? deepLink;

  const BannerEntity({
    required this.id,
    required this.imageUrl,
    this.deepLink,
  });
}

class PromoCardEntity {
  final String id;
  final String title;
  final String imageUrl;
  final String? deepLink;
  final Color? backgroundColor;

  const PromoCardEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.deepLink,
    this.backgroundColor,
  });
}

class ProductGridEntity {
  final String id;
  final String imageUrl;

  const ProductGridEntity({required this.id, required this.imageUrl});
}

class BestsellerSectionEntity {
  final String id;
  final String title;
  final int extraCount;
  final List<ProductGridEntity> products;
  final String? deepLink;

  const BestsellerSectionEntity({
    required this.id,
    required this.title,
    required this.extraCount,
    required this.products,
    this.deepLink,
  });
}

class DashboardEntity {
  final DeliveryInfoEntity deliveryInfo;
  final List<CategoryEntity> categories;
  final BannerEntity heroBanner;
  final List<PromoCardEntity> promoCards;
  final List<BestsellerSectionEntity> bestsellers;

  const DashboardEntity({
    required this.deliveryInfo,
    required this.categories,
    required this.heroBanner,
    required this.promoCards,
    required this.bestsellers,
  });
}

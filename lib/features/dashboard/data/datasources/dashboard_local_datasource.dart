import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rich/features/dashboard/domain/entities/dashboard_entity.dart';

abstract class DashboardLocalDataSource {
  Future<DashboardEntity> getDashboard();
}

/// Mock data source — replace with remote API call for server-driven UI.
/// All values here are candidates for remote config (Firebase Remote Config,
/// a CMS response, or a dedicated layout API).
@LazySingleton(as: DashboardLocalDataSource)
class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  @override
  Future<DashboardEntity> getDashboard() async {
    await Future.delayed(const Duration(milliseconds: 600)); // simulate network
    return DashboardEntity(
      deliveryInfo: const DeliveryInfoEntity(
        deliveryTime: '14',
        deliveryUnit: 'minutes',
        distance: '1.6 km away',
        locationName: 'Phase 1, Hinjawadi',
      ),
      categories: const [
        CategoryEntity(
          id: 'all',
          label: 'All',
          iconUrl: 'https://cdn-icons-png.flaticon.com/512/3081/3081559.png',
        ),
        CategoryEntity(
          id: 'summer',
          label: 'Summer',
          iconUrl: 'https://cdn-icons-png.flaticon.com/512/869/869869.png',
          isNew: true,
        ),
        CategoryEntity(
          id: 'electronics',
          label: 'Electronics',
          iconUrl: 'https://cdn-icons-png.flaticon.com/512/3659/3659899.png',
        ),
        CategoryEntity(
          id: 'beauty',
          label: 'Beauty',
          iconUrl: 'https://cdn-icons-png.flaticon.com/512/2553/2553642.png',
        ),
        CategoryEntity(
          id: 'pharmacy',
          label: 'Pharmacy',
          iconUrl: 'https://cdn-icons-png.flaticon.com/512/2966/2966327.png',
        ),
      ],
      heroBanner: const BannerEntity(
        id: 'navratri_banner',
        imageUrl:
            'https://images.unsplash.com/photo-1604423043492-41f8e5b7e6e3?w=800&q=80',
      ),
      promoCards: [
        PromoCardEntity(
          id: 'flowers',
          title: 'Flowers &\nPooja Needs',
          imageUrl:
              'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&q=80',
          backgroundColor: const Color(0xFF7B2D2D),
        ),
        PromoCardEntity(
          id: 'specials',
          title: 'Navratri\nSpecials',
          imageUrl:
              'https://images.unsplash.com/photo-1606787366850-de6330128bfc?w=400&q=80',
          backgroundColor: const Color(0xFF7B2D2D),
        ),
        PromoCardEntity(
          id: 'kanjak',
          title: 'Kanjak\nStore',
          imageUrl:
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&q=80',
          backgroundColor: const Color(0xFF7B2D2D),
        ),
      ],
      bestsellers: [
        BestsellerSectionEntity(
          id: 'vegetables',
          title: 'Vegetables &\nFruits',
          extraCount: 192,
          products: const [
            ProductGridEntity(
              id: 'v1',
              imageUrl:
                  'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200&q=80',
            ),
            ProductGridEntity(
              id: 'v2',
              imageUrl:
                  'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=200&q=80',
            ),
            ProductGridEntity(
              id: 'v3',
              imageUrl:
                  'https://images.unsplash.com/photo-1587132137056-bfbf0166836e?w=200&q=80',
            ),
            ProductGridEntity(
              id: 'v4',
              imageUrl:
                  'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=200&q=80',
            ),
          ],
        ),
        BestsellerSectionEntity(
          id: 'chips',
          title: 'Chips &\nNamkeen',
          extraCount: 361,
          products: const [
            ProductGridEntity(
              id: 'c1',
              imageUrl:
                  'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=200&q=80',
            ),
            ProductGridEntity(
              id: 'c2',
              imageUrl:
                  'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=200&q=80',
            ),
            ProductGridEntity(
              id: 'c3',
              imageUrl:
                  'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=200&q=80',
            ),
            ProductGridEntity(
              id: 'c4',
              imageUrl:
                  'https://images.unsplash.com/photo-1576618148400-f54bed99fcfd?w=200&q=80',
            ),
          ],
        ),
        BestsellerSectionEntity(
          id: 'drinks',
          title: 'Drinks &\nJuices',
          extraCount: 118,
          products: const [
            ProductGridEntity(
              id: 'd1',
              imageUrl:
                  'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=200&q=80',
            ),
            ProductGridEntity(
              id: 'd2',
              imageUrl:
                  'https://images.unsplash.com/photo-1527960471264-932f39eb5846?w=200&q=80',
            ),
            ProductGridEntity(
              id: 'd3',
              imageUrl:
                  'https://images.unsplash.com/photo-1553361371-9b22f78e8b1d?w=200&q=80',
            ),
            ProductGridEntity(
              id: 'd4',
              imageUrl:
                  'https://images.unsplash.com/photo-1625772299848-391b6a87d7b3?w=200&q=80',
            ),
          ],
        ),
      ],
    );
  }
}

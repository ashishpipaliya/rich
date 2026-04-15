import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rich/core/di/injection.dart';
import 'package:rich/core/theme/app_colors.dart';
import 'package:rich/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:rich/features/dashboard/presentation/bloc/dashboard_bloc.dart';

part 'widgets/dashboard_header.dart';
part 'widgets/category_chips.dart';
part 'widgets/hero_banner.dart';
part 'widgets/promo_grid.dart';
part 'widgets/bestsellers_section.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<DashboardBloc>()..add(const DashboardEvent.fetch()), child: const _DashboardView());
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardColors.pageBg,
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) => state.when(
          initial: () => const _LoadingView(),
          loading: () => const _LoadingView(),
          success: (dashboard, selectedCategoryId, isRefreshing) =>
              _SuccessView(dashboard: dashboard, selectedCategoryId: selectedCategoryId, isRefreshing: isRefreshing),
          failure: (message) => _ErrorView(message: message),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.white54, size: 48),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.read<DashboardBloc>().add(const DashboardEvent.fetch()),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final DashboardEntity dashboard;
  final String selectedCategoryId;
  final bool isRefreshing;

  const _SuccessView({required this.dashboard, required this.selectedCategoryId, required this.isRefreshing});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        // Pinned app bar — not part of the refresh zone
        _DashboardSliverAppBar(
          info: dashboard.deliveryInfo,
          categories: dashboard.categories,
          selectedCategoryId: selectedCategoryId,
        ),

        // Refresh control sits here — only content below chips pulls to refresh
        CupertinoSliverRefreshControl(
          onRefresh: () async =>
              context.read<DashboardBloc>().add(const DashboardEvent.refresh()),
        ),

        SliverToBoxAdapter(child: _HeroBanner(banner: dashboard.heroBanner)),
        SliverToBoxAdapter(child: _PromoGrid(cards: dashboard.promoCards)),
        SliverToBoxAdapter(
          child: _BestsellersSection(sections: dashboard.bestsellers),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

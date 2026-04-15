part of '../dashboard_page.dart';

// ─── Sliver App Bar ──────────────────────────────────────────────────────────

class _DashboardSliverAppBar extends StatelessWidget {
  final DeliveryInfoEntity info;
  final List<CategoryEntity> categories;
  final String selectedCategoryId;

  const _DashboardSliverAppBar({
    required this.info,
    required this.categories,
    required this.selectedCategoryId,
  });

  // Height of the pinned bottom section (search + chips)
  static const double _pinnedHeight = 48 + 8 + 72 + 1; // search + gap + chips + divider

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: DashboardColors.appBarBg,
      // Expanded height = safe area + delivery info block + pinned section
      expandedHeight: topPadding + 110 + _pinnedHeight,
      collapsedHeight: _pinnedHeight,
      toolbarHeight: _pinnedHeight,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: _CollapsibleDeliveryInfo(info: info),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(_pinnedHeight),
        child: _PinnedSearchAndChips(
          categories: categories,
          selectedCategoryId: selectedCategoryId,
        ),
      ),
    );
  }
}

// ─── Collapsible: Delivery Info ──────────────────────────────────────────────

class _CollapsibleDeliveryInfo extends StatelessWidget {
  final DeliveryInfoEntity info;
  const _CollapsibleDeliveryInfo({required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [DashboardColors.headerGradTop, DashboardColors.appBarBg],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _DeliveryInfo(info: info)),
              const SizedBox(width: 12),
              _TopActions(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Pinned: Search + Category Chips ─────────────────────────────────────────

class _PinnedSearchAndChips extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String selectedCategoryId;

  const _PinnedSearchAndChips({
    required this.categories,
    required this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DashboardColors.appBarBg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _SearchBar(),
          ),
          // Category chips
          _CategoryChips(
            categories: categories,
            selectedId: selectedCategoryId,
          ),
        ],
      ),
    );
  }
}

// ─── Delivery Info ────────────────────────────────────────────────────────────

class _DeliveryInfo extends StatelessWidget {
  final DeliveryInfoEntity info;
  const _DeliveryInfo({required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery in',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              info.deliveryTime,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              info.deliveryUnit,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 10),
            _DistanceBadge(distance: info.distance),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              info.locationName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.white, size: 18),
          ],
        ),
      ],
    );
  }
}

class _DistanceBadge extends StatelessWidget {
  final String distance;
  const _DistanceBadge({required this.distance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A5C2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.directions_bike_rounded, color: Colors.white, size: 13),
          const SizedBox(width: 4),
          Text(
            distance,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              const Center(
                child: Icon(Icons.account_balance_wallet_outlined,
                    color: Colors.white, size: 20),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A5C2A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '₹0',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person_outline_rounded,
              color: Colors.white, size: 22),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(Icons.search_rounded, color: Colors.grey.shade500, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Search "akhrot"',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Color(0xFFE0E0E0))),
            ),
            child: Icon(Icons.mic_none_rounded,
                color: Colors.grey.shade600, size: 22),
          ),
        ],
      ),
    );
  }
}


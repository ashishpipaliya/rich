part of '../dashboard_page.dart';

class _BestsellersSection extends StatelessWidget {
  final List<BestsellerSectionEntity> sections;
  const _BestsellersSection({required this.sections});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      color: const Color(0xFF0D0D0D),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 14),
            child: Text(
              'Bestsellers',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          // 3-column grid of bestseller cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _BestsellerGrid(sections: sections),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _BestsellerGrid extends StatelessWidget {
  final List<BestsellerSectionEntity> sections;
  const _BestsellerGrid({required this.sections});

  @override
  Widget build(BuildContext context) {
    // Arrange in rows of 3
    final rows = <List<BestsellerSectionEntity>>[];
    for (var i = 0; i < sections.length; i += 3) {
      rows.add(sections.sublist(i, (i + 3).clamp(0, sections.length)));
    }

    return Column(
      children: rows
          .asMap()
          .entries
          .map(
            (rowEntry) => Padding(
              padding: EdgeInsets.only(top: rowEntry.key == 0 ? 0 : 10),
              child: Row(
                children: rowEntry.value
                    .asMap()
                    .entries
                    .map(
                      (e) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: e.key == 0 ? 0 : 5,
                            right: e.key == rowEntry.value.length - 1 ? 0 : 5,
                          ),
                          child: _BestsellerCard(
                            section: e.value,
                            index: rowEntry.key * 3 + e.key,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _BestsellerCard extends StatelessWidget {
  final BestsellerSectionEntity section;
  final int index;

  const _BestsellerCard({required this.section, required this.index});

  @override
  Widget build(BuildContext context) {
    final products = section.products;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2x2 product image grid
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(4),
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                  children: List.generate(4, (i) {
                    if (i >= products.length) {
                      return Container(color: const Color(0xFF2A2A2A));
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                        imageUrl: products[i].imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: const Color(0xFF2A2A2A),
                          child: const Icon(Icons.image_not_supported_outlined,
                              color: Colors.white24, size: 20),
                        ),
                      ),
                    );
                  }),
                ),
                // "+X more" badge
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '+${section.extraCount} more',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
            child: Text(
              section.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 80 * index))
        .fadeIn(duration: 400.ms)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          duration: 350.ms,
        );
  }
}

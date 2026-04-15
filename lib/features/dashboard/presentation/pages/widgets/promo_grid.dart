part of '../dashboard_page.dart';

class _PromoGrid extends StatelessWidget {
  final List<PromoCardEntity> cards;
  const _PromoGrid({required this.cards});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: Row(
        children: cards
            .asMap()
            .entries
            .map(
              (e) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: e.key == 0 ? 0 : 5,
                    right: e.key == cards.length - 1 ? 0 : 5,
                  ),
                  child: _PromoCard(card: e.value, index: e.key),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final PromoCardEntity card;
  final int index;

  const _PromoCard({required this.card, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: card.backgroundColor ?? const Color(0xFF7B2D2D),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image bottom-right
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: CachedNetworkImage(
              imageUrl: card.imageUrl,
              height: 80,
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.2),
              colorBlendMode: BlendMode.darken,
              errorWidget: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (card.backgroundColor ?? const Color(0xFF7B2D2D))
                        .withValues(alpha: 0.9),
                    (card.backgroundColor ?? const Color(0xFF7B2D2D))
                        .withValues(alpha: 0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              card.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0, duration: 350.ms);
  }
}

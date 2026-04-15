part of '../dashboard_page.dart';

class _HeroBanner extends StatelessWidget {
  final BannerEntity banner;
  const _HeroBanner({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF5C1A00), Color(0xFF8B2500), Color(0xFF5C1A00)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with low opacity
          CachedNetworkImage(
            imageUrl: banner.imageUrl,
            fit: BoxFit.cover,
            color: Colors.black.withValues(alpha: 0.45),
            colorBlendMode: BlendMode.darken,
            errorWidget: (_, __, ___) => const SizedBox.shrink(),
          ),

          // Decorative side ornaments
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 50,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0x885C1A00), Colors.transparent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 50,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Color(0x885C1A00)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),

          // Text content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ornamentLine(),
                    const SizedBox(width: 8),
                    const Text(
                      'CELEBRATE',
                      style: TextStyle(
                        color: Color(0xFFD4A843),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ornamentLine(),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'NAVRATRI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dot(),
                    const SizedBox(width: 6),
                    _dot(),
                    const SizedBox(width: 6),
                    _dot(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).scale(
          begin: const Offset(0.97, 0.97),
          end: const Offset(1, 1),
          duration: 400.ms,
        );
  }

  Widget _ornamentLine() => Container(
        width: 24,
        height: 1,
        color: const Color(0xFFD4A843),
      );

  Widget _dot() => Container(
        width: 5,
        height: 5,
        decoration: const BoxDecoration(
          color: Color(0xFFD4A843),
          shape: BoxShape.circle,
        ),
      );
}

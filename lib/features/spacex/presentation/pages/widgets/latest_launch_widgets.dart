part of '../spacex_page.dart';

class _PremiumCardShell extends StatelessWidget {
  final Widget child;
  final String? backgroundImage;

  const _PremiumCardShell({required this.child, this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    final cardColors = SpaceXCardColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // 1. Dynamic Background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: cardColors.gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
              ),
            ),

            // 2. Animated Orbitals
            Positioned(
              top: -50,
              right: -50,
              child:
                  Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: cardColors.orbitalColor),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 5.seconds)
                      .blur(begin: const Offset(40, 40), end: const Offset(80, 80)),
            ),

            if (backgroundImage != null)
              Positioned(
                right: -20,
                bottom: -20,
                child: Opacity(
                  opacity: isDark ? 0.1 : 0.05,
                  child: CachedNetworkImage(imageUrl: backgroundImage!, fit: BoxFit.cover),
                ),
              ),

            // 3. Glass Reflection Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [cardColors.reflectionColor, Colors.transparent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 0.4],
                  ),
                ),
              ),
            ),

            // 4. Content
            Padding(padding: const EdgeInsets.all(16), child: child),

            // 5. Premium Border
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: cardColors.borderColor, width: 1.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LatestLaunchCard extends StatelessWidget {
  final Launch launch;

  const _LatestLaunchCard({required this.launch});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cardColors = SpaceXCardColors.of(context);
    final contentColor = cardColors.contentColor;

    return _PremiumCardShell(
      backgroundImage: launch.links.patch.small,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _LiveBadge(),
              Text(
                l10n.missionAlpha.toUpperCase(),
                style: TextStyle(color: contentColor.withValues(alpha: 0.3), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Mission Info Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      launch.name,
                      style: TextStyle(color: contentColor, fontSize: 22, fontWeight: FontWeight.w900, height: 1.1),
                    ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
                    const SizedBox(height: 4),
                    const _StatusBadge(),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _MissionPatch(launch: launch),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: contentColor.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: 12),

          // Stats Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatIndicator(label: l10n.flight, value: '#${launch.flightNumber}'),
              _StatIndicator(label: l10n.year, value: '${launch.dateUtc.year}'),
              _StatIndicator(label: l10n.orbit, value: l10n.leo, icon: Icons.public_rounded),
            ],
          ).animate(delay: 600.ms).fadeIn(),
        ],
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : colorScheme.primary).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: (isDark ? Colors.white : colorScheme.primary).withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
          ).animate(onPlay: (c) => c.repeat()).scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5)).fadeOut(),
          const SizedBox(width: 6),
          Text(
            l10n.liveTelemetry.toUpperCase(),
            style: TextStyle(color: isDark ? Colors.white : colorScheme.primary, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: SpaceXTheme.getSuccessColor(context).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
      child: Text(
        l10n.successfulDeployment.toUpperCase(),
        style: TextStyle(color: SpaceXTheme.getSuccessColor(context), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5),
      ),
    ).animate(delay: 400.ms).fadeIn().slideX(begin: -0.1);
  }
}

class _MissionPatch extends StatelessWidget {
  final Launch launch;
  const _MissionPatch({required this.launch});

  @override
  Widget build(BuildContext context) {
    if (launch.links.patch.small == null) return const SizedBox.shrink();
    return Hero(
      tag: 'latest_patch',
      child: Image.network(launch.links.patch.small!, width: 50, height: 50, fit: BoxFit.contain),
    ).animate().scale(duration: 1.seconds, curve: Curves.elasticOut, begin: const Offset(0.5, 0.5)).rotate(begin: -0.1, end: 0);
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 180,
        decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(32)),
      ),
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1500.ms, color: colorScheme.surface);
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  final String message;
  final AppLocalizations l10n;
  const _ErrorPlaceholder({required this.message, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _PremiumCardShell(
      child: Center(
        child: Column(
          children: [
            Icon(Icons.wifi_off_rounded, color: colorScheme.primary, size: 40),
            const SizedBox(height: 8),
            Text(l10n.connectionLost(message), style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7))),
            TextButton(
              onPressed: () => context.read<LatestLaunchBloc>().add(const LatestLaunchEvent.fetch()),
              child: Text(
                l10n.reconnect,
                style: TextStyle(color: colorScheme.inversePrimary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ).animate().shake(hz: 4, curve: Curves.easeInOut);
  }
}

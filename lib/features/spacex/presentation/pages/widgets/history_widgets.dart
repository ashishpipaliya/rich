part of '../spacex_page.dart';

class _LaunchListTile extends StatelessWidget {
  final Launch launch;
  final int index;

  const _LaunchListTile({required this.launch, required this.index});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final statusColor = launch.success == true
        ? SpaceXTheme.getSuccessColor(context)
        : (launch.success == false ? SpaceXTheme.getErrorColor(context) : colorScheme.outline);
    final statusBgColor = statusColor.withValues(alpha: 0.1);

    return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: statusColor.withValues(alpha: 0.3), width: .2),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(12)),
              child: launch.links.patch.small != null
                  ? Image.network(
                      launch.links.patch.small!,
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.rocket_launch, size: 40),
                    )
                  : const Icon(Icons.rocket_launch, size: 40),
            ),
            title: Text(launch.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('${l10n.flightNumber(launch.flightNumber)} • ${launch.dateUtc.year}', style: TextStyle(color: colorScheme.outline)),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: statusBgColor, shape: BoxShape.circle),
              child: Icon(
                launch.success == true ? Icons.check_rounded : (launch.success == false ? Icons.close_rounded : Icons.help_outline_rounded),
                size: 18,
                color: statusColor,
              ),
            ),
            onTap: () => _showLaunchDetails(context, launch),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, curve: Curves.easeOutQuad)
        .slideX(begin: -0.05, end: 0, duration: 450.ms, curve: Curves.easeOutQuad)
        .blurXY(begin: 4, end: 0, duration: 400.ms);
  }
}

class _LaunchGridTile extends StatelessWidget {
  final Launch launch;
  final int index;

  const _LaunchGridTile({required this.launch, required this.index});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final statusColor = launch.success == true
        ? SpaceXTheme.getSuccessColor(context)
        : (launch.success == false ? SpaceXTheme.getErrorColor(context) : colorScheme.outline);
    final statusBgColor = statusColor.withValues(alpha: 0.1);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: statusColor.withValues(alpha: 0.1), width: .1),
      ),
      child: InkWell(
        onTap: () => _showLaunchDetails(context, launch),
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: launch.links.patch.small != null
                        ? Image.network(
                            launch.links.patch.small!,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.rocket_launch, size: 40),
                          )
                        : const Icon(Icons.rocket_launch, size: 40),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    launch.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(l10n.flightNumber(launch.flightNumber), style: TextStyle(color: colorScheme.outline, fontSize: 12)),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: statusBgColor, shape: BoxShape.circle),
                child: Icon(
                  launch.success == true ? Icons.check_rounded : (launch.success == false ? Icons.close_rounded : Icons.help_outline_rounded),
                  size: 14,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }
}

class _StatIndicator extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _StatIndicator({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    final cardColors = SpaceXCardColors.of(context);
    final contentColor = cardColors.contentColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: contentColor.withValues(alpha: 0.4), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, color: contentColor.withValues(alpha: 0.7), size: 12), const SizedBox(width: 4)],
            Text(
              value,
              style: TextStyle(color: contentColor, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: -0.5),
            ),
          ],
        ),
      ],
    );
  }
}

class _HistoryShimmerLoader extends StatelessWidget {
  const _HistoryShimmerLoader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mode = context.watch<ViewModeCubit>().state;
    final shimmerBase = colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    final shimmerHighlight = colorScheme.surface;

    if (mode == SpaceXViewMode.list) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 80,
              decoration: BoxDecoration(color: shimmerBase, borderRadius: BorderRadius.circular(16)),
            ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1.5.seconds, color: shimmerHighlight),
            childCount: 5,
          ),
        ),
      );
    } else {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              decoration: BoxDecoration(color: shimmerBase, borderRadius: BorderRadius.circular(16)),
            ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1.5.seconds, color: shimmerHighlight),
            childCount: 6,
          ),
        ),
      );
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isStatus;
  final bool? statusValue;

  const _DetailRow({required this.label, required this.value, this.isStatus = false, this.statusValue});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = statusValue == true
        ? SpaceXTheme.getSuccessColor(context)
        : (statusValue == false ? SpaceXTheme.getErrorColor(context) : colorScheme.outline);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: colorScheme.outline, fontSize: 15)),
          if (!isStatus)
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(
                value,
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}

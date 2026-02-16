import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rich/core/di/injection.dart';
import 'package:rich/core/theme/spacex_theme.dart';
import 'package:rich/features/spacex/data/models/launch_model.dart';
import 'package:rich/l10n/app_localizations.dart';
import '../bloc/spacex_bloc.dart';
import '../bloc/spacex_event.dart';
import '../bloc/spacex_state.dart';
import '../bloc/view_mode_cubit.dart';

class SpaceXPage extends StatelessWidget {
  const SpaceXPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SpaceXBloc>()..add(const SpaceXEvent.fetchDashboard())),
        BlocProvider(create: (context) => getIt<ViewModeCubit>()),
      ],
      child: const SpaceXView(),
    );
  }
}

class SpaceXView extends StatelessWidget {
  const SpaceXView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: Icon(Icons.rocket_outlined, color: colorScheme.primary),
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              onChanged: (value) {
                context.read<SpaceXBloc>().add(SpaceXEvent.searchLaunches(value));
              },
            ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2, end: 0),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<SpaceXBloc>().add(const SpaceXEvent.fetchDashboard());
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text(l10n.latestLaunch, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const SliverToBoxAdapter(child: _LatestLaunchSection()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.launchHistory, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    BlocBuilder<ViewModeCubit, SpaceXViewMode>(
                      builder: (context, mode) {
                        return IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(mode == SpaceXViewMode.list ? Icons.grid_view_rounded : Icons.view_list_rounded),
                          onPressed: () => context.read<ViewModeCubit>().toggle(),
                        );
                      },
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms),
            ),
            BlocBuilder<SpaceXBloc, SpaceXState>(
              buildWhen: (previous, current) =>
                  previous.historyStatus != current.historyStatus || previous.filteredLaunches != current.filteredLaunches,
              builder: (context, state) {
                return switch (state.historyStatus) {
                  SpaceXStatus.initial => SliverFillRemaining(hasScrollBody: false, child: Center(child: Text(l10n.initializingControl))),
                  SpaceXStatus.loading => const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
                  ),
                  SpaceXStatus.failure => SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text(l10n.telemetryError(state.errorMessage ?? ''))),
                  ),
                  SpaceXStatus.empty => SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off_rounded, size: 80, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(l10n.noMissionsFound, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                    ).animate().scale(duration: 400.ms),
                  ),
                  SpaceXStatus.success => BlocBuilder<ViewModeCubit, SpaceXViewMode>(
                    builder: (context, mode) {
                      final launches = state.filteredLaunches;
                      if (mode == SpaceXViewMode.list) {
                        return SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _LaunchListTile(launch: launches[index], index: index),
                              childCount: launches.length,
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
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _LaunchGridTile(launch: launches[index], index: index),
                              childCount: launches.length,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: statusColor.withValues(alpha: 0.3), width: 1),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
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
        .slideX(begin: 0.05, end: 0, duration: 450.ms, curve: Curves.easeOutQuad)
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
        side: BorderSide(color: statusColor.withValues(alpha: 0.2), width: 1),
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

void _showLaunchDetails(BuildContext context, Launch launch) async {
  final l10n = AppLocalizations.of(context)!;
  final colorScheme = Theme.of(context).colorScheme;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: colorScheme.outlineVariant, borderRadius: BorderRadius.circular(10)),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    children: [
                      if (launch.links.patch.large != null)
                        Center(
                          child: Image.network(
                            launch.links.patch.large!,
                            height: 180,
                          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut).fadeIn(),
                        ),
                      const SizedBox(height: 24),
                      Text(
                        launch.name,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mission ID: ${launch.id.substring(0, 8).toUpperCase()}',
                        style: TextStyle(color: colorScheme.outline, fontWeight: FontWeight.bold, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Text(l10n.missionSummary, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 12),
                      Text(launch.details ?? l10n.noDetails, style: TextStyle(fontSize: 16, height: 1.6, color: colorScheme.onSurface)),
                      const SizedBox(height: 32),
                      _DetailRow(label: l10n.launchDate, value: '${launch.dateUtc.day}/${launch.dateUtc.month}/${launch.dateUtc.year}'),
                      _DetailRow(label: 'Flight Number', value: '#${launch.flightNumber}'),
                      _DetailRow(
                        label: l10n.launchStatus,
                        value: launch.success == true ? l10n.success : l10n.failure,
                        isStatus: true,
                        statusValue: launch.success,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
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

class _LatestLaunchSection extends StatelessWidget {
  const _LatestLaunchSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<SpaceXBloc, SpaceXState>(
      buildWhen: (previous, current) => previous.latestStatus != current.latestStatus || previous.latestLaunch != current.latestLaunch,
      builder: (context, state) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuart,
          child: switch (state.latestStatus) {
            SpaceXStatus.initial => const SizedBox.shrink(),
            SpaceXStatus.loading => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 160,
                decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(24)),
              ),
            ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1500.ms, color: colorScheme.surface),
            SpaceXStatus.failure => _LatestLaunchCardWrapper(
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.wifi_off_rounded, color: colorScheme.onInverseSurface, size: 40),
                    const SizedBox(height: 8),
                    Text(l10n.connectionLost('Telemetry Error'), style: TextStyle(color: colorScheme.onInverseSurface.withValues(alpha: 0.7))),
                    TextButton(
                      onPressed: () => context.read<SpaceXBloc>().add(const SpaceXEvent.fetchLatest()),
                      child: Text(
                        l10n.reconnect,
                        style: TextStyle(color: colorScheme.inversePrimary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().shake(hz: 4, curve: Curves.easeInOut),
            SpaceXStatus.success || SpaceXStatus.empty =>
              state.latestLaunch != null
                  ? _LatestLaunchContainer(launch: state.latestLaunch!)
                        .animate()
                        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0), duration: 600.ms, curve: Curves.easeOutBack)
                        .fadeIn(duration: 500.ms)
                  : const SizedBox.shrink(),
          },
        );
      },
    );
  }
}

class _LatestLaunchCardWrapper extends StatelessWidget {
  final Widget child;
  const _LatestLaunchCardWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: child,
    );
  }
}

class _LatestLaunchContainer extends StatelessWidget {
  final Launch launch;

  const _LatestLaunchContainer({required this.launch});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return _LatestLaunchCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: colorScheme.tertiary, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  l10n.liveTelemetry,
                  style: TextStyle(color: colorScheme.onTertiary, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
              ).animate().shimmer(delay: 1.seconds, duration: 2.seconds),
              const Spacer(),
              Icon(
                Icons.sensors,
                color: colorScheme.errorContainer,
                size: 16,
              ).animate(onPlay: (c) => c.repeat()).fadeIn(duration: 500.ms).fadeOut(delay: 500.ms),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (launch.links.patch.small != null)
                Hero(
                  tag: 'latest_patch',
                  child: Image.network(launch.links.patch.small!, width: 70, height: 70),
                ).animate().rotate(begin: -0.1, end: 0, duration: 1.seconds, curve: Curves.elasticOut),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      launch.name,
                      style: TextStyle(color: colorScheme.onPrimary, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),
                    const SizedBox(height: 4),
                    Text(
                      l10n.successfulDeployment,
                      style: TextStyle(color: colorScheme.onPrimary.withValues(alpha: 0.6), fontSize: 13),
                    ).animate(delay: 400.ms).fadeIn(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatIndicator(label: 'FLIGHT', value: '#${launch.flightNumber}'),
              _StatIndicator(label: 'YEAR', value: '${launch.dateUtc.year}'),
              _StatIndicator(label: l10n.orbit, value: 'LEO', icon: Icons.public),
            ],
          ).animate(delay: 600.ms).fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}

class _StatIndicator extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _StatIndicator({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: colorScheme.onPrimary.withValues(alpha: 0.4), fontSize: 11, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (icon != null) Icon(icon, color: colorScheme.onPrimary, size: 14),
            if (icon != null) const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rich/core/di/injection.dart';
import 'package:rich/core/theme/spacex_theme.dart';
import 'package:rich/features/spacex/data/models/launch_model.dart';
import 'package:rich/l10n/app_localizations.dart';
import '../bloc/latest_launch/latest_launch_bloc.dart';
import '../bloc/latest_launch/latest_launch_event.dart';
import '../bloc/latest_launch/latest_launch_state.dart';
import '../bloc/history/history_bloc.dart';
import '../bloc/history/history_event.dart';
import '../bloc/history/history_state.dart';
import '../bloc/view_mode_cubit.dart';

part 'widgets/latest_launch_widgets.dart';
part 'widgets/history_widgets.dart';

class SpaceXPage extends StatelessWidget {
  const SpaceXPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<LatestLaunchBloc>()..add(const LatestLaunchEvent.fetch())),
        BlocProvider(create: (context) => getIt<HistoryBloc>()..add(const HistoryEvent.fetch())),
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
                context.read<HistoryBloc>().add(HistoryEvent.search(value));
              },
            ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2, end: 0),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<LatestLaunchBloc>().add(const LatestLaunchEvent.fetch());
          context.read<HistoryBloc>().add(const HistoryEvent.fetch());
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            const SliverToBoxAdapter(child: _LatestLaunchSection()),
            const _HistoryHeaderSection(),
            BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                return switch (state) {
                  HistoryInitial() => SliverFillRemaining(hasScrollBody: false, child: Center(child: Text(l10n.initializingControl))),
                  HistoryLoading() => const _HistoryShimmerLoader(),
                  HistoryError(message: final msg) => SliverFillRemaining(hasScrollBody: false, child: Center(child: Text(l10n.telemetryError(msg)))),
                  HistoryLoaded(filteredLaunches: final filtered) => () {
                    if (filtered.isEmpty) {
                      return SliverFillRemaining(
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
                      );
                    }
                    return BlocBuilder<ViewModeCubit, SpaceXViewMode>(
                      builder: (context, mode) {
                        if (mode == SpaceXViewMode.list) {
                          return SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => _LaunchListTile(launch: filtered[index], index: index),
                                childCount: filtered.length,
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
                                (context, index) => _LaunchGridTile(launch: filtered[index], index: index),
                                childCount: filtered.length,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }(),
                };
              },
            ),
          ],
        ),
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

    return BlocBuilder<LatestLaunchBloc, LatestLaunchState>(
      builder: (context, state) {
        final isLoading = state is LatestLaunchLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: isLoading
                  ? Container(
                      width: 140,
                      height: 20,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1.5.seconds, color: colorScheme.surface)
                  : Text(l10n.latestLaunch, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuart,
              child: switch (state) {
                LatestLaunchInitial() => const SizedBox.shrink(),
                LatestLaunchLoading() => _LoadingPlaceholder(),
                LatestLaunchError(message: final msg) => _ErrorPlaceholder(message: msg, l10n: l10n),
                LatestLaunchLoaded(launch: final launch) =>
                  _LatestLaunchCard(launch: launch)
                      .animate()
                      .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0), duration: 600.ms, curve: Curves.easeOutBack)
                      .fadeIn(duration: 500.ms),
              },
            ),
          ],
        );
      },
    );
  }
}

class _HistoryHeaderSection extends StatelessWidget {
  const _HistoryHeaderSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return SliverToBoxAdapter(
      child: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          final isLoading = state is HistoryLoading;

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isLoading
                    ? Container(
                        width: 120,
                        height: 20,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1.5.seconds, color: colorScheme.surface)
                    : Text(l10n.launchHistory, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
          );
        },
      ),
    );
  }
}

void _showLaunchDetails(BuildContext context, Launch launch) {
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
                          child: CachedNetworkImage(
                            imageUrl: launch.links.patch.large!,
                            height: 180,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator.adaptive()),
                            errorWidget: (context, url, error) => const Icon(Icons.rocket_launch, size: 80),
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
                        l10n.missionId(launch.id.substring(0, 8).toUpperCase()),
                        style: TextStyle(color: colorScheme.outline, fontWeight: FontWeight.bold, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Text(l10n.missionSummary, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 12),
                      Text(launch.details ?? l10n.noDetails, style: TextStyle(fontSize: 16, height: 1.6, color: colorScheme.onSurface)),
                      const SizedBox(height: 32),
                      _DetailRow(label: l10n.launchDate, value: '${launch.dateUtc.day}/${launch.dateUtc.month}/${launch.dateUtc.year}'),
                      _DetailRow(label: l10n.flightNumberLabel, value: '#${launch.flightNumber}'),
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

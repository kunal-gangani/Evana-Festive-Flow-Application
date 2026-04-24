import 'package:evana_event_management_app/Controllers/booking_provider.dart';
import 'package:evana_event_management_app/Controllers/event_provider.dart';
import 'package:evana_event_management_app/Helpers/app_theme.dart';
import 'package:evana_event_management_app/Models/event_model.dart';
import 'package:evana_event_management_app/Views/Dashboard/widgets/event_card.dart';
import 'package:evana_event_management_app/Views/Tickets/ticket_wallet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDashboard extends StatelessWidget {
  const EventDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('Event Discovery'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const TicketWallet(),
                ),
              );
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.account_balance_wallet_outlined),
                Positioned(
                  right: -6,
                  top: -8,
                  child: Consumer<BookingProvider>(
                    builder: (context, bookingProvider, _) {
                      if (bookingProvider.userTickets.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentAmber,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${bookingProvider.userTickets.length}',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: const Color(0xFF0A0E21),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.read<EventProvider>().initDashboard(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Consumer<EventProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const _DashboardShimmer();
          }

          if (provider.error != null) {
            return _DashboardError(
              message: provider.error!,
              onRetry: () => context.read<EventProvider>().initDashboard(),
            );
          }

          return RefreshIndicator(
            color: AppTheme.accentAmber,
            backgroundColor: const Color(0xFF171D39),
            onRefresh: context.read<EventProvider>().initDashboard,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Text(
                  'Curated festive experiences',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Discover premium nights, summits, workshops, and sports experiences.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 10),
                Consumer<BookingProvider>(
                  builder: (context, bookingProvider, _) {
                    return Text(
                      'Tickets in wallet: ${bookingProvider.userTickets.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.accentAmber,
                            fontWeight: FontWeight.w700,
                          ),
                    );
                  },
                ),
                const SizedBox(height: 22),
                _CategoryStrip(selected: provider.selectedCategory),
                const SizedBox(height: 22),
                if (provider.events.isEmpty)
                  const _EmptyState()
                else
                  ...provider.events.map(
                    (event) => Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: EventCard(event: event),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({
    required this.selected,
  });

  final EventCategory? selected;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<EventProvider>();

    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _CategoryChip(
              label: 'All',
              isSelected: selected == null,
              onTap: provider.showAllEvents,
            ),
          ),
          ...EventCategory.values.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: _CategoryChip(
                label: _label(category),
                isSelected: selected == category,
                onTap: () => provider.filterByCategory(category),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _label(EventCategory category) {
    switch (category) {
      case EventCategory.music:
        return 'Music';
      case EventCategory.tech:
        return 'Tech';
      case EventCategory.workshop:
        return 'Workshop';
      case EventCategory.sports:
        return 'Sports';
    }
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppTheme.accentAmber : const Color(0xFF171D39),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected ? const Color(0xFF0A0E21) : Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_tethering_error_rounded,
              size: 52,
              color: AppTheme.accentAmber,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Icon(
            Icons.event_busy_outlined,
            size: 48,
            color: Colors.white54,
          ),
          const SizedBox(height: 14),
          Text(
            'No events found for this category.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }
}

class _DashboardShimmer extends StatefulWidget {
  const _DashboardShimmer();

  @override
  State<_DashboardShimmer> createState() => _DashboardShimmerState();
}

class _DashboardShimmerState extends State<_DashboardShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            _ShimmerBlock(
              animationValue: _controller.value,
              height: 28,
              widthFactor: 0.54,
            ),
            const SizedBox(height: 12),
            _ShimmerBlock(
              animationValue: _controller.value,
              height: 14,
              widthFactor: 0.82,
            ),
            const SizedBox(height: 22),
            Row(
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _ShimmerPill(animationValue: _controller.value),
                ),
              ),
            ),
            const SizedBox(height: 22),
            ...List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: _ShimmerCard(animationValue: _controller.value),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({
    required this.animationValue,
  });

  final double animationValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment(-1 + (animationValue * 2), 0),
          end: Alignment(1 + (animationValue * 2), 0),
          colors: const [
            Color(0xFF121830),
            Color(0xFF20284A),
            Color(0xFF121830),
          ],
        ),
      ),
    );
  }
}

class _ShimmerPill extends StatelessWidget {
  const _ShimmerPill({
    required this.animationValue,
  });

  final double animationValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          begin: Alignment(-1 + (animationValue * 2), 0),
          end: Alignment(1 + (animationValue * 2), 0),
          colors: const [
            Color(0xFF121830),
            Color(0xFF20284A),
            Color(0xFF121830),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBlock extends StatelessWidget {
  const _ShimmerBlock({
    required this.animationValue,
    required this.height,
    required this.widthFactor,
  });

  final double animationValue;
  final double height;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment(-1 + (animationValue * 2), 0),
            end: Alignment(1 + (animationValue * 2), 0),
            colors: const [
              Color(0xFF121830),
              Color(0xFF20284A),
              Color(0xFF121830),
            ],
          ),
        ),
      ),
    );
  }
}

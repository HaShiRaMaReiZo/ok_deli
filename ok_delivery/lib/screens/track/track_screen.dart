import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../models/package_model.dart';
import '../../repositories/package_repository.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/utils/date_utils.dart' as myanmar_date;
import 'track_date_detail_screen.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final _packageRepository = PackageRepository(
    ApiClient.create(baseUrl: ApiEndpoints.baseUrl),
  );

  List<PackageModel> _packages = [];
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload when coming back from detail screen
    final result = ModalRoute.of(context)?.settings.arguments;
    if (result == true) {
      _loadPackages(refresh: true);
    }
  }

  Future<void> _loadPackages({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _hasMore = true;
        _packages = [];
      });
    }

    if (_isLoadingMore || (!_hasMore && !refresh)) return;

    setState(() {
      if (!refresh) {
        _isLoadingMore = true;
      } else {
        _isLoading = true;
        _error = null;
      }
    });

    try {
      final packages = await _packageRepository.getPackages(page: _currentPage);

      setState(() {
        if (refresh) {
          _packages = packages;
        } else {
          _packages.addAll(packages);
        }
        _hasMore = packages.length >= 20; // Assuming 20 per page
        _currentPage++;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Map<DateTime, List<PackageModel>> _groupPackagesByRegisteredDate() {
    final Map<DateTime, List<PackageModel>> grouped = {};

    for (final package in _packages) {
      // Only group packages that have been registered (have registered_at)
      if (package.registeredAt == null) continue;

      // Use Myanmar timezone for grouping
      final date = myanmar_date.MyanmarDateUtils.getDateKey(
        package.registeredAt!,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(package);
    }

    return grouped;
  }

  String _formatDate(DateTime date) {
    // date is already in Myanmar timezone from getDateKey
    final now = myanmar_date.MyanmarDateUtils.getMyanmarNow();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return AppLocalizations.of(context)!.today;
    } else if (dateOnly == yesterday) {
      return AppLocalizations.of(context)!.yesterday;
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBeige,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.trackPackages),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadPackages(refresh: true),
            tooltip: AppLocalizations.of(context)!.refresh,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.errorLoadingPackages,
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _loadPackages(refresh: true),
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            )
          : _packages.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.noPackagesFound,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _loadPackages(refresh: true),
              child: Builder(
                builder: (context) {
                  final grouped = _groupPackagesByRegisteredDate();

                  if (grouped.isEmpty) {
                    return const Center(
                      child: Text(
                        'No registered packages found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }

                  final sortedDates = grouped.keys.toList()
                    ..sort((a, b) => b.compareTo(a));

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: sortedDates.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == sortedDates.length) {
                        // Load more trigger
                        if (!_isLoadingMore) {
                          _loadPackages();
                        }
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final date = sortedDates[index];
                      final packages = grouped[date]!;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TrackDateDetailScreen(
                                  date: date,
                                  packages: packages,
                                ),
                              ),
                            );

                            if (result == true) {
                              _loadPackages(refresh: true);
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryBlue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _formatDate(date),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.darkBlue,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${packages.length} package${packages.length == 1 ? '' : 's'}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}

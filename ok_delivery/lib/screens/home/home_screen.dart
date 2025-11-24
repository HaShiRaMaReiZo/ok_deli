import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user_model.dart';
import '../../models/package_model.dart';
import '../../repositories/package_repository.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/utils/date_utils.dart' as myanmar_date;
import '../register_package/register_package_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _packageRepository = PackageRepository(
    ApiClient.create(baseUrl: ApiEndpoints.baseUrl),
  );

  int _registeredThisMonth = 0;
  int _pendingThisMonth = 0;
  int _deliveredThisMonth = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      // Load all packages (multiple pages if needed)
      final allPackages = <PackageModel>[];
      int currentPage = 1;
      bool hasMore = true;

      while (hasMore) {
        final packages = await _packageRepository.getPackages(
          page: currentPage,
        );
        if (packages.isEmpty) {
          hasMore = false;
        } else {
          allPackages.addAll(packages);
          // If we got less than 20 packages, we've reached the end
          if (packages.length < 20) {
            hasMore = false;
          } else {
            currentPage++;
          }
        }
      }

      final now = myanmar_date.MyanmarDateUtils.getMyanmarNow();
      final currentMonth = DateTime(now.year, now.month, 1);
      final nextMonth = DateTime(now.year, now.month + 1, 1);

      int registeredThisMonth = 0;
      int pendingThisMonth = 0;
      int deliveredThisMonth = 0;

      for (final package in allPackages) {
        // Count registered this month (using registered_at)
        if (package.registeredAt != null) {
          final registeredDate = myanmar_date.MyanmarDateUtils.toMyanmarTime(
            package.registeredAt!,
          );
          if (registeredDate.isAfter(
                currentMonth.subtract(const Duration(days: 1)),
              ) &&
              registeredDate.isBefore(nextMonth)) {
            registeredThisMonth++;
          }
        }

        // Count pending this month (packages not delivered/cancelled/returned
        // that were registered or updated in current month)
        if (package.status != null &&
            package.status != 'delivered' &&
            package.status != 'cancelled' &&
            package.status != 'returned_to_merchant') {
          // Check if package was registered or updated in current month
          final registeredDate = package.registeredAt != null
              ? myanmar_date.MyanmarDateUtils.toMyanmarTime(
                  package.registeredAt!,
                )
              : null;
          final updatedDate = myanmar_date.MyanmarDateUtils.toMyanmarTime(
            package.updatedAt,
          );

          final isInCurrentMonth =
              (registeredDate != null &&
                  registeredDate.isAfter(
                    currentMonth.subtract(const Duration(days: 1)),
                  ) &&
                  registeredDate.isBefore(nextMonth)) ||
              (updatedDate.isAfter(
                    currentMonth.subtract(const Duration(days: 1)),
                  ) &&
                  updatedDate.isBefore(nextMonth));

          if (isInCurrentMonth) {
            pendingThisMonth++;
          }
        }

        // Count delivered this month (packages with status 'delivered'
        // that were updated in current month)
        if (package.status == 'delivered') {
          final updatedDate = myanmar_date.MyanmarDateUtils.toMyanmarTime(
            package.updatedAt,
          );
          if (updatedDate.isAfter(
                currentMonth.subtract(const Duration(days: 1)),
              ) &&
              updatedDate.isBefore(nextMonth)) {
            deliveredThisMonth++;
          }
        }
      }

      if (mounted) {
        setState(() {
          _registeredThisMonth = registeredThisMonth;
          _pendingThisMonth = pendingThisMonth;
          _deliveredThisMonth = deliveredThisMonth;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBeige,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
            tooltip: AppLocalizations.of(context)!.refresh,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Overview Box
            _buildProfileOverviewBox(context),
            const SizedBox(height: 16),

            // Stats Row - 3 boxes
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    context: context,
                    title: AppLocalizations.of(context)!.registered,
                    count: _isLoading ? '...' : _registeredThisMonth.toString(),
                    icon: Icons.add_circle_outline,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    context: context,
                    title: AppLocalizations.of(context)!.pending,
                    count: _isLoading ? '...' : _pendingThisMonth.toString(),
                    icon: Icons.pending_outlined,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    context: context,
                    title: AppLocalizations.of(context)!.delivered,
                    count: _isLoading ? '...' : _deliveredThisMonth.toString(),
                    icon: Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Register Package Box
            _buildRegisterPackageBox(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOverviewBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.merchant?.businessName ?? widget.user.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.user.merchant?.businessEmail ?? widget.user.email,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          // Arrow Icon
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildStatBox({
    required BuildContext context,
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      height: 130, // Fixed height to ensure all cards are same size
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterPackageBox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RegisterPackageScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.darkBlue, AppTheme.primaryBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.darkBlue.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.add_circle,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.registerPackage,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.createNewDeliveryPackage,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

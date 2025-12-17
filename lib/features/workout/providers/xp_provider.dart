import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/xp_service.dart';

// XP Service Provider
final xpServiceProvider = Provider<XPService>((ref) {
  return XPService();
});

// Total XP Provider - Stream that watches for XP changes
final totalXPProvider = StreamProvider.autoDispose<int>((ref) async* {
  final xpService = ref.watch(xpServiceProvider);

  // Initial value
  final initialXP = await xpService.getTotalXP();
  yield initialXP;

  // Listen for updates (poll every second when screen is active)
  await for (final _ in Stream.periodic(const Duration(seconds: 1))) {
    final xp = await xpService.getTotalXP();
    yield xp;
  }
});

// Current Level Provider (derived from XP)
final currentLevelProvider = Provider.autoDispose<int>((ref) {
  final xpService = ref.watch(xpServiceProvider);
  final xpAsync = ref.watch(totalXPProvider);

  return xpAsync.when(
    data: (xp) => xpService.calculateLevel(xp),
    loading: () => 1,
    error: (_, __) => 1,
  );
});

// Level Progress Provider (0.0 to 1.0)
final levelProgressProvider = Provider.autoDispose<double>((ref) {
  final xpService = ref.watch(xpServiceProvider);
  final xpAsync = ref.watch(totalXPProvider);
  final currentLevel = ref.watch(currentLevelProvider);

  return xpAsync.when(
    data: (xp) => xpService.getLevelProgress(xp, currentLevel),
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

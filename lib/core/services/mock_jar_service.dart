import '../models/jar_v2.dart';
import '../models/brand_collaboration.dart';
import '../utils/currency.dart';

/// Mock service for jar operations
class MockJarService {
  // Demo data: 2 pre-populated jars
  List<JarV2> _jars = [];

  MockJarService() {
    _initializeDemoJars();
  }

  void _initializeDemoJars() {
    final now = DateTime.now();

    // OXXO brand collaboration data
    final oxxoCollaboration = BrandCollaboration(
      brandName: 'OXXO',
      brandColor: '#E12019',
      rewards: [
        BrandReward(
          id: 'oxxo-1',
          emoji: '☕',
          title: 'Café Andatti Gourmet discount coupon',
          description: 'Save just 1 time and get discount',
        ),
        BrandReward(
          id: 'oxxo-2',
          emoji: '🍫',
          title: 'Free chocolate bar',
          description: 'Complete 3 deposits to unlock',
        ),
        BrandReward(
          id: 'oxxo-3',
          emoji: '🥤',
          title: 'Free drink of choice',
          description: r'Reach $50 to unlock this reward',
        ),
      ],
    );

    _jars = [
      JarV2(
        id: '1',
        emoji: '🏖️',
        name: 'Jar',
        currentBalance: 45.0, // $45
        goalAmount: 100.0, // Fixed at $100
        streakDays: 12,
        todayDeposit: 1.50,
        lastDepositDate: now,
        isCoinSavingEnabled: true,
        isAutoSaveEnabled: false,
        isBrandCollabEnabled: false,
        activities: [
          JarActivity(
            id: '1-1',
            emoji: '💰',
            description: 'Deposited ${formatCurrency(1.50)}',
            amount: 1.50,
            timestamp: now,
          ),
          JarActivity(
            id: '1-2',
            emoji: '💰',
            description: 'Deposited ${formatCurrency(1.00)}',
            amount: 1.00,
            timestamp: now.subtract(const Duration(days: 1)),
          ),
          JarActivity(
            id: '1-3',
            emoji: '💰',
            description: 'Deposited ${formatCurrency(2.50)}',
            amount: 2.50,
            timestamp: now.subtract(const Duration(days: 2)),
          ),
        ],
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      JarV2(
        id: '2',
        emoji: '🏪',
        name: 'Jar with OXXO',
        currentBalance: 3.50, // $3.50 (between $1-5 for coffee affordability)
        goalAmount: 100.0, // Fixed at $100
        streakDays: 5,
        todayDeposit: 0.50,
        lastDepositDate: now,
        isCoinSavingEnabled: false,
        isAutoSaveEnabled: true,
        isBrandCollabEnabled: true,
        brandCollaboration: oxxoCollaboration,
        activities: [
          JarActivity(
            id: '2-1',
            emoji: '💰',
            description: 'Deposited ${formatCurrency(0.50)}',
            amount: 0.50,
            timestamp: now,
          ),
          JarActivity(
            id: '2-2',
            emoji: '☕',
            description: 'Brand reward earned',
            amount: 0.0,
            timestamp: now.subtract(const Duration(hours: 2)),
          ),
        ],
        createdAt: now.subtract(const Duration(days: 15)),
      ),
    ];
  }

  Future<List<JarV2>> fetchJars() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network
    return List.from(_jars);
  }

  Future<JarV2> getJar(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _jars.firstWhere((j) => j.id == id);
  }

  Future<JarV2> createJar({
    String? emoji,
    String? name,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Use empty jar emoji for new jars ($0)
    final defaultEmoji = '🫙';

    final newJar = JarV2(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      emoji: emoji ?? defaultEmoji,
      name: name ?? 'Jar',
      currentBalance: 0,
      goalAmount: 100.0, // Always $100
      streakDays: 0,
      todayDeposit: 0,
      isCoinSavingEnabled: false,
      isAutoSaveEnabled: false,
      isBrandCollabEnabled: false,
      activities: [],
      createdAt: DateTime.now(),
      lastDepositDate: DateTime.now(),
    );

    _jars.add(newJar);
    return newJar;
  }

  Future<JarV2> deposit(String jarId, double amount) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _jars.indexWhere((j) => j.id == jarId);
    if (index == -1) throw Exception('Jar not found');

    final jar = _jars[index];

    // Update streak logic
    final now = DateTime.now();
    final lastDeposit = jar.lastDepositDate;
    final daysSinceLastDeposit = now.difference(lastDeposit).inDays;

    int newStreak = jar.streakDays;
    if (daysSinceLastDeposit == 1) {
      newStreak++; // Continue streak
    } else if (daysSinceLastDeposit > 1) {
      newStreak = 1; // Reset streak
    } else if (daysSinceLastDeposit == 0) {
      // Same day, keep streak
      newStreak = jar.streakDays;
    }

    // Check if it's a new day for todayDeposit reset
    final isSameDay = now.year == lastDeposit.year &&
        now.month == lastDeposit.month &&
        now.day == lastDeposit.day;

    final updatedJar = jar.copyWith(
      currentBalance: jar.currentBalance + amount,
      todayDeposit: isSameDay ? jar.todayDeposit + amount : amount,
      streakDays: newStreak,
      lastDepositDate: now,
      activities: [
        JarActivity(
          id: '$jarId-${DateTime.now().millisecondsSinceEpoch}',
          emoji: '💰',
          description: 'Deposited ${formatCurrency(amount)}',
          amount: amount,
          timestamp: now,
        ),
        ...jar.activities,
      ],
    );

    _jars[index] = updatedJar;
    return updatedJar;
  }

  Future<void> deleteJar(String jarId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _jars.removeWhere((j) => j.id == jarId);
  }

  Future<JarV2> updateCoinSaving(String jarId, bool enabled) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _jars.indexWhere((j) => j.id == jarId);
    if (index == -1) throw Exception('Jar not found');

    final updatedJar = _jars[index].copyWith(isCoinSavingEnabled: enabled);
    _jars[index] = updatedJar;
    return updatedJar;
  }

  Future<JarV2> updateAutoSave(String jarId, bool enabled) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _jars.indexWhere((j) => j.id == jarId);
    if (index == -1) throw Exception('Jar not found');

    final updatedJar = _jars[index].copyWith(isAutoSaveEnabled: enabled);
    _jars[index] = updatedJar;
    return updatedJar;
  }

  Future<JarV2> updateBrandCollab(String jarId, bool enabled) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _jars.indexWhere((j) => j.id == jarId);
    if (index == -1) throw Exception('Jar not found');

    final updatedJar = _jars[index].copyWith(isBrandCollabEnabled: enabled);
    _jars[index] = updatedJar;
    return updatedJar;
  }

  Future<JarV2> updateJar({
    required String jarId,
    String? emoji,
    String? name,
    double? goalAmount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _jars.indexWhere((j) => j.id == jarId);
    if (index == -1) throw Exception('Jar not found');

    final updatedJar = _jars[index].copyWith(
      emoji: emoji,
      name: name,
      goalAmount: goalAmount,
    );

    _jars[index] = updatedJar;
    return updatedJar;
  }
}

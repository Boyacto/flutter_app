import '../models/jar_v2.dart';
import '../utils/currency.dart';

/// Mock service for jar operations
class MockJarService {
  // Demo data: 3 pre-populated jars
  List<JarV2> _jars = [];

  MockJarService() {
    _initializeDemoJars();
  }

  void _initializeDemoJars() {
    final now = DateTime.now();

    _jars = [
      JarV2(
        id: '1',
        emoji: '🏖️',
        name: 'Beach Vacation',
        currentBalance: 450000,
        goalAmount: 2000000,
        streakDays: 12,
        todayDeposit: 15000,
        lastDepositDate: now,
        savingMode: SavingMode.autoSave,
        activities: [
          JarActivity(
            id: '1-1',
            emoji: '💰',
            description: 'Deposited ${formatCurrency(15000)}',
            amount: 15000,
            timestamp: now,
          ),
          JarActivity(
            id: '1-2',
            emoji: '💰',
            description: 'Deposited ${formatCurrency(10000)}',
            amount: 10000,
            timestamp: now.subtract(const Duration(days: 1)),
          ),
        ],
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      JarV2(
        id: '2',
        emoji: '🎮',
        name: 'Gaming Setup',
        currentBalance: 1200000,
        goalAmount: 3000000,
        streakDays: 5,
        todayDeposit: 25000,
        lastDepositDate: now,
        savingMode: SavingMode.manual,
        activities: [
          JarActivity(
            id: '2-1',
            emoji: '💰',
            description: 'Deposited ${formatCurrency(25000)}',
            amount: 25000,
            timestamp: now,
          ),
        ],
        createdAt: now.subtract(const Duration(days: 15)),
      ),
      JarV2(
        id: '3',
        emoji: '🚗',
        name: 'Car Fund',
        currentBalance: 8000000,
        goalAmount: 20000000,
        streakDays: 45,
        todayDeposit: 50000,
        lastDepositDate: now,
        savingMode: SavingMode.brandCoupons,
        activities: [
          JarActivity(
            id: '3-1',
            emoji: '💰',
            description: 'Deposited ${formatCurrency(50000)}',
            amount: 50000,
            timestamp: now,
          ),
        ],
        createdAt: now.subtract(const Duration(days: 90)),
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
    required String emoji,
    required String name,
    required double goalAmount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final newJar = JarV2(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      emoji: emoji,
      name: name,
      currentBalance: 0,
      goalAmount: goalAmount,
      streakDays: 0,
      todayDeposit: 0,
      savingMode: SavingMode.manual,
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

  Future<JarV2> updateMode(String jarId, SavingMode mode) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _jars.indexWhere((j) => j.id == jarId);
    if (index == -1) throw Exception('Jar not found');

    final updatedJar = _jars[index].copyWith(savingMode: mode);
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

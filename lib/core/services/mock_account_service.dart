import '../models/account.dart';

/// Mock service for account operations
class MockAccountService {
  List<Account> _accounts = [];

  MockAccountService() {
    _initializeDemoAccounts();
  }

  void _initializeDemoAccounts() {
    _accounts = [
      const Account(
        id: '1',
        name: 'Savings Account #1',
        balance: 450.0, // $450
        linkedJarId: '1', // Linked to first jar
      ),
      const Account(
        id: '2',
        name: 'Savings Account #2',
        balance: 3.50, // $3.50 (for OXXO collaboration jar)
        linkedJarId: '2', // Linked to OXXO jar
      ),
      const Account(
        id: '3',
        name: 'Savings Account #3',
        balance: 800.0, // $800
        linkedJarId: null, // No jar linked - will show "Make a Jar" button
      ),
    ];
  }

  Future<List<Account>> fetchAccounts() async {
    await Future.delayed(
        const Duration(milliseconds: 200)); // Simulate network
    return List.from(_accounts);
  }

  Future<Account> getAccount(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _accounts.firstWhere((a) => a.id == id);
  }

  Future<Account> updateAccountBalance(String accountId, double amount) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _accounts.indexWhere((a) => a.id == accountId);
    if (index == -1) throw Exception('Account not found');

    final account = _accounts[index];
    final updatedAccount = account.copyWith(balance: account.balance + amount);

    _accounts[index] = updatedAccount;
    return updatedAccount;
  }

  Future<Account> linkJarToAccount(String accountId, String jarId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _accounts.indexWhere((a) => a.id == accountId);
    if (index == -1) throw Exception('Account not found');

    final account = _accounts[index];
    final updatedAccount = account.copyWith(linkedJarId: jarId);

    _accounts[index] = updatedAccount;
    return updatedAccount;
  }

  Future<Account> unlinkJarFromAccount(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _accounts.indexWhere((a) => a.id == accountId);
    if (index == -1) throw Exception('Account not found');

    final account = _accounts[index];
    final updatedAccount = account.copyWith(clearLinkedJar: true);

    _accounts[index] = updatedAccount;
    return updatedAccount;
  }

  /// Find an account that doesn't have a linked jar
  Future<Account?> findAvailableAccount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _accounts.firstWhere((a) => !a.hasLinkedJar);
    } catch (e) {
      return null; // No available account
    }
  }
}

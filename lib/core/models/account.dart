/// Represents a savings account (통장) that can have a linked jar
class Account {
  final String id;
  final String name; // e.g., "Savings Account #1"
  final double balance; // Current amount in the savings account
  final String? linkedJarId; // null if no jar is linked

  const Account({
    required this.id,
    required this.name,
    required this.balance,
    this.linkedJarId,
  });

  bool get hasLinkedJar => linkedJarId != null;

  Account copyWith({
    String? id,
    String? name,
    double? balance,
    String? linkedJarId,
    bool clearLinkedJar = false,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      linkedJarId: clearLinkedJar ? null : (linkedJarId ?? this.linkedJarId),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'balance': balance,
        'linkedJarId': linkedJarId,
      };

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json['id'] as String,
        name: json['name'] as String,
        balance: (json['balance'] as num).toDouble(),
        linkedJarId: json['linkedJarId'] as String?,
      );
}

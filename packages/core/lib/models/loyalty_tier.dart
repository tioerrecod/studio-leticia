class LoyaltyTier {
  final String name;
  final String color;
  final int minPoints;
  final int? maxPoints;
  final List<String> benefits;

  const LoyaltyTier({
    required this.name,
    required this.color,
    required this.minPoints,
    this.maxPoints,
    this.benefits = const [],
  });

  factory LoyaltyTier.fromJson(Map<String, dynamic> json) => LoyaltyTier(
    name: json['name'] as String,
    color: json['color'] as String,
    minPoints: json['min_points'] as int,
    maxPoints: json['max_points'] as int?,
    benefits: (json['benefits'] as List<dynamic>?)?.cast<String>() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'color': color,
    'min_points': minPoints,
    'max_points': maxPoints,
    'benefits': benefits,
  };
}

class LoyaltySummary {
  final int totalPoints;
  final int lifetimePoints;
  final int visitsCount;
  final double totalSpent;
  final LoyaltyTier currentTier;
  final LoyaltyTier? nextTier;
  final int pointsToNextTier;

  const LoyaltySummary({
    required this.totalPoints,
    required this.lifetimePoints,
    required this.visitsCount,
    required this.totalSpent,
    required this.currentTier,
    this.nextTier,
    required this.pointsToNextTier,
  });

  String get formattedSpent => 'R\$ ${totalSpent.toStringAsFixed(2)}';

  factory LoyaltySummary.fromJson(Map<String, dynamic> json) => LoyaltySummary(
    totalPoints: json['total_points'] as int,
    lifetimePoints: json['lifetime_points'] as int,
    visitsCount: json['visits_count'] as int,
    totalSpent: (json['total_spent'] as num).toDouble(),
    currentTier: LoyaltyTier.fromJson(json['current_tier'] as Map<String, dynamic>),
    nextTier: json['next_tier'] != null
        ? LoyaltyTier.fromJson(json['next_tier'] as Map<String, dynamic>)
        : null,
    pointsToNextTier: json['points_to_next_tier'] as int,
  );

  Map<String, dynamic> toJson() => {
    'total_points': totalPoints,
    'lifetime_points': lifetimePoints,
    'visits_count': visitsCount,
    'total_spent': totalSpent,
    'current_tier': currentTier.toJson(),
    'next_tier': nextTier?.toJson(),
    'points_to_next_tier': pointsToNextTier,
  };
}

class AchievementWithStatus {
  final String name;
  final String displayName;
  final String description;
  final String icon;
  final bool isAchieved;

  AchievementWithStatus({
    required this.name,
    required this.displayName,
    required this.description,
    required this.icon,
    required this.isAchieved,
  });

  factory AchievementWithStatus.fromJson(Map<String, dynamic> json) {
    return AchievementWithStatus(
      name: json['name'] ?? '',
      displayName: json['displayName'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      isAchieved: json['isAchieved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'displayName': displayName,
      'description': description,
      'icon': icon,
      'isAchieved': isAchieved,
    };
  }
}

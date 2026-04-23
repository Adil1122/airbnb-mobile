class HostAction {
  final int id;
  final String title;
  final String? description;
  final String type;
  final bool isCompleted;

  HostAction({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    this.isCompleted = false,
  });

  factory HostAction.fromJson(Map<String, dynamic> json) {
    return HostAction(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class HostDashboardData {
  final int checkingIn;
  final int checkingOut;
  final int currentlyHosting;
  final int upcoming;
  final int pendingReview;
  final List<HostAction> actions;

  HostDashboardData({
    required this.checkingIn,
    required this.checkingOut,
    required this.currentlyHosting,
    required this.upcoming,
    required this.pendingReview,
    required this.actions,
  });

  factory HostDashboardData.fromJson(Map<String, dynamic> json) {
    return HostDashboardData(
      checkingIn: json['checkingIn'] ?? 0,
      checkingOut: json['checkingOut'] ?? 0,
      currentlyHosting: json['currentlyHosting'] ?? 0,
      upcoming: json['upcoming'] ?? 0,
      pendingReview: json['pendingReview'] ?? 0,
      actions: (json['actions'] as List? ?? [])
          .map((a) => HostAction.fromJson(a))
          .toList(),
    );
  }
}

class UserSettingsModel {
  final int? id;
  final bool showReadReceipts;
  final bool includeInSearch;
  final bool showHomeCity;
  final bool showTripType;
  final bool showLengthOfStay;
  final bool showBookedServices;
  final bool improveAI;
  final Map<String, dynamic>? notificationPreferences;
  final bool mapZoomControls;
  final bool mapPanControls;
  final bool autoTranslate;
  final String preferredLanguage;
  final String? businessEmail;
  final bool isTravelForWorkEnabled;
  final String? taxId;
  final String? taxCountry;
  final String? vatNumber;

  UserSettingsModel({
    this.id,
    this.showReadReceipts = true,
    this.includeInSearch = false,
    this.showHomeCity = true,
    this.showTripType = true,
    this.showLengthOfStay = true,
    this.showBookedServices = true,
    this.improveAI = true,
    this.notificationPreferences,
    this.mapZoomControls = false,
    this.mapPanControls = false,
    this.autoTranslate = true,
    this.preferredLanguage = 'English',
    this.businessEmail,
    this.isTravelForWorkEnabled = false,
    this.taxId,
    this.taxCountry,
    this.vatNumber,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      id: json['id'],
      showReadReceipts: json['showReadReceipts'] ?? true,
      includeInSearch: json['includeInSearch'] ?? false,
      showHomeCity: json['showHomeCity'] ?? true,
      showTripType: json['showTripType'] ?? true,
      showLengthOfStay: json['showLengthOfStay'] ?? true,
      showBookedServices: json['showBookedServices'] ?? true,
      improveAI: json['improveAI'] ?? true,
      notificationPreferences: json['notificationPreferences'],
      mapZoomControls: json['mapZoomControls'] ?? false,
      mapPanControls: json['mapPanControls'] ?? false,
      autoTranslate: json['autoTranslate'] ?? true,
      preferredLanguage: json['preferredLanguage'] ?? 'English',
      businessEmail: json['businessEmail'],
      isTravelForWorkEnabled: json['isTravelForWorkEnabled'] ?? false,
      taxId: json['taxId'],
      taxCountry: json['taxCountry'],
      vatNumber: json['vatNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showReadReceipts': showReadReceipts,
      'includeInSearch': includeInSearch,
      'showHomeCity': showHomeCity,
      'showTripType': showTripType,
      'showLengthOfStay': showLengthOfStay,
      'showBookedServices': showBookedServices,
      'improveAI': improveAI,
      'notificationPreferences': notificationPreferences,
      'mapZoomControls': mapZoomControls,
      'mapPanControls': mapPanControls,
      'autoTranslate': autoTranslate,
      'preferredLanguage': preferredLanguage,
      'businessEmail': businessEmail,
      'isTravelForWorkEnabled': isTravelForWorkEnabled,
      'taxId': taxId,
      'taxCountry': taxCountry,
      'vatNumber': vatNumber,
    };
  }

  UserSettingsModel copyWith({
    bool? showReadReceipts,
    bool? includeInSearch,
    bool? showHomeCity,
    bool? showTripType,
    bool? showLengthOfStay,
    bool? showBookedServices,
    bool? improveAI,
    Map<String, dynamic>? notificationPreferences,
    bool? mapZoomControls,
    bool? mapPanControls,
    bool? autoTranslate,
    String? preferredLanguage,
    String? businessEmail,
    bool? isTravelForWorkEnabled,
    String? taxId,
    String? taxCountry,
    String? vatNumber,
  }) {
    return UserSettingsModel(
      id: id,
      showReadReceipts: showReadReceipts ?? this.showReadReceipts,
      includeInSearch: includeInSearch ?? this.includeInSearch,
      showHomeCity: showHomeCity ?? this.showHomeCity,
      showTripType: showTripType ?? this.showTripType,
      showLengthOfStay: showLengthOfStay ?? this.showLengthOfStay,
      showBookedServices: showBookedServices ?? this.showBookedServices,
      improveAI: improveAI ?? this.improveAI,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
      mapZoomControls: mapZoomControls ?? this.mapZoomControls,
      mapPanControls: mapPanControls ?? this.mapPanControls,
      autoTranslate: autoTranslate ?? this.autoTranslate,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      businessEmail: businessEmail ?? this.businessEmail,
      isTravelForWorkEnabled: isTravelForWorkEnabled ?? this.isTravelForWorkEnabled,
      taxId: taxId ?? this.taxId,
      taxCountry: taxCountry ?? this.taxCountry,
      vatNumber: vatNumber ?? this.vatNumber,
    );
  }
}

import 'package:flutter/foundation.dart';
import 'dart:io';

class ApiConfig {
  static const String hostIp = '192.168.1.29';
  static const String port = '3001';

  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:$port';
    if (Platform.isAndroid) return 'http://$hostIp:$port';
    return 'http://$hostIp:$port';
  }

  static String get wsBaseUrl {
    if (kIsWeb) return 'ws://localhost:$port';
    return 'ws://$hostIp:$port';
  }

  // ── Auth ──────────────────────────────────────────────
  static String get authUrl => '$baseUrl/auth';

  // ── Properties / Listings ─────────────────────────────
  static String get propertiesUrl => '$baseUrl/properties';

  // ── Experiences & Services ────────────────────────────
  static String get experiencesUrl => '$baseUrl/experiences';
  static String get servicesUrl => '$baseUrl/services';

  // ── Host management ───────────────────────────────────
  static String get hostListingsUrl => '$baseUrl/host/listings';
  static String get hostDashboardUrl => '$baseUrl/host/listings/dashboard';
  static String get hostCalendarUrl => '$baseUrl/host/listings/calendar';

  // ── Bookings ──────────────────────────────────────────
  static String get bookingsUrl => '$baseUrl/bookings';
  static String get hostBookingsUrl => '$baseUrl/bookings/host';
  static String bookingByIdUrl(int id) => '$baseUrl/bookings/$id';
  static String confirmBookingUrl(int id) => '$baseUrl/bookings/$id/confirm';
  static String declineBookingUrl(int id) => '$baseUrl/bookings/$id/decline';
  static String cancelBookingUrl(int id) => '$baseUrl/bookings/$id/cancel';
  static String get bookingAvailabilityUrl => '$baseUrl/bookings/availability';
  static String get validatePromoUrl => '$baseUrl/bookings/validate-promo';
  static String reservedDatesUrl(int propertyId) => '$baseUrl/bookings/reserved-dates/$propertyId';

  // ── Reviews ───────────────────────────────────────────
  static String get reviewsUrl => '$baseUrl/reviews';
  static String reviewsByListingUrl(int propertyId) => '$baseUrl/reviews/listing/$propertyId';
  static String reviewSummaryUrl(int propertyId) => '$baseUrl/reviews/listing/$propertyId/summary';
  static String get myReviewsUrl => '$baseUrl/reviews/mine';
  static String reviewResponseUrl(int id) => '$baseUrl/reviews/$id/response';

  // ── Wishlists ─────────────────────────────────────────
  static String get wishlistsUrl => '$baseUrl/wishlists';
  static String wishlistByIdUrl(int id) => '$baseUrl/wishlists/$id';
  static String wishlistItemsUrl(int id) => '$baseUrl/wishlists/$id/items';
  static String wishlistItemUrl(int wishlistId, int itemId) =>
      '$baseUrl/wishlists/$wishlistId/items/$itemId';
  static String wishlistCheckUrl(int propertyId) => '$baseUrl/wishlists/check/$propertyId';

  // ── Messages ──────────────────────────────────────────
  static String get conversationsUrl => '$baseUrl/messages/conversations';
  static String conversationUrl(int id) => '$baseUrl/messages/conversations/$id';
  static String sendMessageUrl(int id) => '$baseUrl/messages/conversations/$id/send';
  static String markReadUrl(int id) => '$baseUrl/messages/conversations/$id/read';
  static String get unreadMessagesCountUrl => '$baseUrl/messages/unread-count';

  // ── Notifications ─────────────────────────────────────
  static String get notificationsUrl => '$baseUrl/notifications';
  static String get notificationUnreadCountUrl => '$baseUrl/notifications/unread-count';
  static String get notificationPreferencesUrl => '$baseUrl/notifications/preferences';
  static String get markAllNotificationsReadUrl => '$baseUrl/notifications/read-all';
  static String markNotificationReadUrl(int id) => '$baseUrl/notifications/$id/read';
  static String get deviceTokenUrl => '$baseUrl/notifications/device-token';

  // ── Payments ──────────────────────────────────────────
  static String get paymentIntentUrl => '$baseUrl/payment/create-intent';
  static String get confirmPaymentUrl => '$baseUrl/payment/confirm';
  static String get paymentMethodsUrl => '$baseUrl/payment/methods';

  // ── Categories & Destinations ─────────────────────────
  static String get categoriesUrl => '$baseUrl/categories';
  static String get destinationsUrl => '$baseUrl/destinations';

  // ── Upload ────────────────────────────────────────────
  static String get uploadImageUrl => '$baseUrl/upload/image';
  static String get uploadImagesUrl => '$baseUrl/upload/images';
  static String deleteUploadUrl(String filename) => '$baseUrl/upload/$filename';

  // ── Co-Hosts ──────────────────────────────────────────
  static String get coHostsUrl => '$baseUrl/co-hosts';
  static String get coHostInvitationsUrl => '$baseUrl/co-hosts/invitations';
  static String get myCoHostPropertiesUrl => '$baseUrl/co-hosts/my-properties';
  static String coHostRespondUrl(int id) => '$baseUrl/co-hosts/$id/respond';
  static String propertyCoHostsUrl(int propertyId) => '$baseUrl/co-hosts/property/$propertyId';

  // ── Recently Viewed ───────────────────────────────────
  static String get recentlyViewedUrl => '$baseUrl/recently-viewed';

  // ── Connections ───────────────────────────────────────
  static String get connectionsUrl => '$baseUrl/connections';
  static String get connectionRequestUrl => '$baseUrl/connections/request';
  static String get pendingConnectionsUrl => '$baseUrl/connections/pending';
  static String connectionRespondUrl(int id) => '$baseUrl/connections/$id/respond';

  // ── Superhost ─────────────────────────────────────────
  static String get superhostStatsUrl => '$baseUrl/superhost/my-stats';

  // ── Smart Pricing ─────────────────────────────────────
  static String get smartPricingUrl => '$baseUrl/smart-pricing';
  static String priceSuggestionUrl(int propertyId) => '$baseUrl/smart-pricing/$propertyId/suggestion';
  static String priceCalendarUrl(int propertyId) => '$baseUrl/smart-pricing/$propertyId/calendar';

  // ── iCal ──────────────────────────────────────────────
  static String get hostIcalUrl => '$baseUrl/ical/host';
  static String get guestIcalUrl => '$baseUrl/ical/trips';

  // ── Admin ─────────────────────────────────────────────
  static String get adminDashboardUrl => '$baseUrl/admin/dashboard';
  static String get adminUsersUrl => '$baseUrl/admin/users';
  static String get adminPropertiesUrl => '$baseUrl/admin/properties';
  static String get adminBookingsUrl => '$baseUrl/admin/bookings';
}

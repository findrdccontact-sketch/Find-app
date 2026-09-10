enum ListingStatus {
  available,
  rented,
  suspended,
  pendingValidation,
  rejected,
}

extension ListingStatusExtension on ListingStatus {
  String get label {
    switch (this) {
      case ListingStatus.available:
        return 'Disponible';
      case ListingStatus.rented:
        return 'Déjà loué';
      case ListingStatus.suspended:
        return 'Suspendu';
      case ListingStatus.pendingValidation:
        return 'En attente de validation';
      case ListingStatus.rejected:
        return 'Refusé';
    }
  }
}

class Listing {
  final String id;
  final String title;
  final String description;
  final double rentPrice; // In USD or FC
  final double cautionPrice;
  final String city; // Ville (Kinshasa, Lubumbashi, Goma, etc.)
  final String commune; // Commune (Gombe, Ngaliema, Bandalungwa, etc.)
  final String quartier;
  final String avenue;
  final double latitude;
  final double longitude;
  final String propertyType; // Maison, Appartement, Chambre, Studio, Local commercial
  final int bedroomsCount;
  final int livingRoomsCount;
  final int bathroomsCount;
  final bool hasKitchen;
  final bool hasParking;
  final bool hasFence;
  final bool hasWater;
  final bool hasElectricity;
  final bool hasInternet;
  final bool hasGarden;
  final List<String> photos; // Up to 20 photos
  final String? videoUrl;
  final String ownerId;
  final String ownerName;
  final String ownerPhone;
  final String ownerWhatsApp;
  final DateTime publishedAt;
  final ListingStatus status;
  final bool isListingVerified; // 🟢 Annonce vérifiée
  final bool isOwnerVerified; // 🔵 Propriétaire vérifié

  // Metrics for Owner / Agency dashboard
  final int viewsCount;
  final int favoritesCount;
  final int contactsCount;
  final int callsCount;
  final int whatsappCount;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.rentPrice,
    required this.cautionPrice,
    required this.city,
    required this.commune,
    required this.quartier,
    required this.avenue,
    required this.latitude,
    required this.longitude,
    required this.propertyType,
    required this.bedroomsCount,
    required this.livingRoomsCount,
    required this.bathroomsCount,
    this.hasKitchen = true,
    this.hasParking = false,
    this.hasFence = false,
    this.hasWater = true,
    this.hasElectricity = true,
    this.hasInternet = false,
    this.hasGarden = false,
    required this.photos,
    this.videoUrl,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerWhatsApp,
    required this.publishedAt,
    this.status = ListingStatus.available,
    this.isListingVerified = false,
    this.isOwnerVerified = false,
    this.viewsCount = 0,
    this.favoritesCount = 0,
    this.contactsCount = 0,
    this.callsCount = 0,
    this.whatsappCount = 0,
  });

  bool get isNewListing {
    final difference = DateTime.now().difference(publishedAt);
    return difference.inDays <= 7; // 🟡 Nouveau logement if published within 7 days
  }

  bool get isRented => status == ListingStatus.rented; // 🔴 Déjà loué

  Listing copyWith({
    String? id,
    String? title,
    String? description,
    double? rentPrice,
    double? cautionPrice,
    String? city,
    String? commune,
    String? quartier,
    String? avenue,
    double? latitude,
    double? longitude,
    String? propertyType,
    int? bedroomsCount,
    int? livingRoomsCount,
    int? bathroomsCount,
    bool? hasKitchen,
    bool? hasParking,
    bool? hasFence,
    bool? hasWater,
    bool? hasElectricity,
    bool? hasInternet,
    bool? hasGarden,
    List<String>? photos,
    String? videoUrl,
    String? ownerId,
    String? ownerName,
    String? ownerPhone,
    String? ownerWhatsApp,
    DateTime? publishedAt,
    ListingStatus? status,
    bool? isListingVerified,
    bool? isOwnerVerified,
    int? viewsCount,
    int? favoritesCount,
    int? contactsCount,
    int? callsCount,
    int? whatsappCount,
  }) {
    return Listing(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rentPrice: rentPrice ?? this.rentPrice,
      cautionPrice: cautionPrice ?? this.cautionPrice,
      city: city ?? this.city,
      commune: commune ?? this.commune,
      quartier: quartier ?? this.quartier,
      avenue: avenue ?? this.avenue,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      propertyType: propertyType ?? this.propertyType,
      bedroomsCount: bedroomsCount ?? this.bedroomsCount,
      livingRoomsCount: livingRoomsCount ?? this.livingRoomsCount,
      bathroomsCount: bathroomsCount ?? this.bathroomsCount,
      hasKitchen: hasKitchen ?? this.hasKitchen,
      hasParking: hasParking ?? this.hasParking,
      hasFence: hasFence ?? this.hasFence,
      hasWater: hasWater ?? this.hasWater,
      hasElectricity: hasElectricity ?? this.hasElectricity,
      hasInternet: hasInternet ?? this.hasInternet,
      hasGarden: hasGarden ?? this.hasGarden,
      photos: photos ?? this.photos,
      videoUrl: videoUrl ?? this.videoUrl,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerWhatsApp: ownerWhatsApp ?? this.ownerWhatsApp,
      publishedAt: publishedAt ?? this.publishedAt,
      status: status ?? this.status,
      isListingVerified: isListingVerified ?? this.isListingVerified,
      isOwnerVerified: isOwnerVerified ?? this.isOwnerVerified,
      viewsCount: viewsCount ?? this.viewsCount,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      contactsCount: contactsCount ?? this.contactsCount,
      callsCount: callsCount ?? this.callsCount,
      whatsappCount: whatsappCount ?? this.whatsappCount,
    );
  }
}

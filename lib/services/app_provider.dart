import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../models/filter_criteria.dart';
import '../models/listing.dart';
import '../models/notification_item.dart';
import '../models/report.dart';

class AppProvider with ChangeNotifier {
  AppUser _currentUser = AppUser(
    id: 'usr_001',
    name: 'Jean-Marc Kabanga',
    email: 'jeanmarc.k@find.cd',
    phone: '+243810001122',
    whatsapp: '+243810001122',
    role: UserRole.tenant,
    isVerified: true,
  );

  AppUser get currentUser => _currentUser;

  FilterCriteria _currentFilter = FilterCriteria();
  FilterCriteria get currentFilter => _currentFilter;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  final Set<String> _favoriteIds = {'lst_001', 'lst_003'};
  Set<String> get favoriteIds => _favoriteIds;

  final List<String> _searchHistory = [
    'Appartement Gombe 2 chambres',
    'Maison Ngaliema Kinshasa',
    'Studio Bandalungwa',
  ];
  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  final List<Report> _reports = [];
  List<Report> get reports => List.unmodifiable(_reports);

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'notif_1',
      title: 'Nouveau logement disponible !',
      message: 'Un appartement correspondant à votre recherche à la Gombe vient d\'être publié.',
      listingId: 'lst_001',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationItem(
      id: 'notif_2',
      title: 'Baisse de prix',
      message: 'Une maison à Ngaliema est maintenant proposée à \$1,200/mois.',
      listingId: 'lst_002',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
  ];
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  final List<AppUser> _allUsers = [];
  List<AppUser> get allUsers => List.unmodifiable(_allUsers);

  late List<Listing> _listings;

  AppProvider() {
    _initMockData();
  }

  void _initMockData() {
    _listings = [
      Listing(
        id: 'lst_001',
        title: 'Superbe Appartement Meublé de Standing',
        description:
            'Magnifique appartement situé en plein cœur de la Gombe avec vue panoramique sur le fleuve Congo. Sécurité 24/7, groupe électrogène industriel, citerne d\'eau et finitions de haut niveau.',
        rentPrice: 1500.0,
        cautionPrice: 4500.0,
        city: 'Kinshasa',
        commune: 'Gombe',
        quartier: 'Golf',
        avenue: 'Avenue de la Justice',
        latitude: -4.3033,
        longitude: 15.3012,
        propertyType: 'Appartement',
        bedroomsCount: 3,
        livingRoomsCount: 1,
        bathroomsCount: 2,
        hasKitchen: true,
        hasParking: true,
        hasFence: true,
        hasWater: true,
        hasElectricity: true,
        hasInternet: true,
        hasGarden: false,
        photos: [
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688',
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2',
        ],
        videoUrl: 'https://www.youtube.com/watch?v=sample1',
        ownerId: 'own_101',
        ownerName: 'Mbala Immobilier',
        ownerPhone: '+243890001111',
        ownerWhatsApp: '+243890001111',
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        status: ListingStatus.available,
        isListingVerified: true,
        isOwnerVerified: true,
        viewsCount: 342,
        favoritesCount: 28,
        contactsCount: 15,
        callsCount: 8,
        whatsappCount: 7,
      ),
      Listing(
        id: 'lst_002',
        title: 'Villa Moderne avec Piscine et Jardin',
        description:
            'Spacieuse villa familiale située dans un quartier calme et hautement sécurisé de Ngaliema. Comprend une piscine privée, un grand jardin arboré et dépendances pour le personnel.',
        rentPrice: 2800.0,
        cautionPrice: 8400.0,
        city: 'Kinshasa',
        commune: 'Ngaliema',
        quartier: 'Macampagne',
        avenue: 'Avenue de la Montagne',
        latitude: -4.3411,
        longitude: 15.2588,
        propertyType: 'Maison',
        bedroomsCount: 5,
        livingRoomsCount: 2,
        bathroomsCount: 4,
        hasKitchen: true,
        hasParking: true,
        hasFence: true,
        hasWater: true,
        hasElectricity: true,
        hasInternet: true,
        hasGarden: true,
        photos: [
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9',
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
        ],
        ownerId: 'own_102',
        ownerName: 'Alain Mukendi',
        ownerPhone: '+243820002222',
        ownerWhatsApp: '+243820002222',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        status: ListingStatus.available,
        isListingVerified: true,
        isOwnerVerified: true,
        viewsCount: 189,
        favoritesCount: 14,
        contactsCount: 9,
        callsCount: 5,
        whatsappCount: 4,
      ),
      Listing(
        id: 'lst_003',
        title: 'Studio Coquet & Lumineux',
        description:
            'Ideal pour jeune professionnel ou étudiant. Proche des commerces et transports, bien aéré et sécurisé.',
        rentPrice: 350.0,
        cautionPrice: 1050.0,
        city: 'Kinshasa',
        commune: 'Bandalungwa',
        quartier: 'Synhydro',
        avenue: 'Avenue Lubumbashi',
        latitude: -4.3322,
        longitude: 15.2899,
        propertyType: 'Studio',
        bedroomsCount: 1,
        livingRoomsCount: 1,
        bathroomsCount: 1,
        hasKitchen: true,
        hasParking: false,
        hasFence: true,
        hasWater: true,
        hasElectricity: true,
        hasInternet: false,
        hasGarden: false,
        photos: [
          'https://images.unsplash.com/photo-1536376072261-38c75010e6c9',
        ],
        ownerId: 'own_103',
        ownerName: 'Chantal Tshilombo',
        ownerPhone: '+243850003333',
        ownerWhatsApp: '+243850003333',
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        status: ListingStatus.available,
        isListingVerified: false,
        isOwnerVerified: true,
        viewsCount: 88,
        favoritesCount: 11,
        contactsCount: 4,
        callsCount: 2,
        whatsappCount: 2,
      ),
      Listing(
        id: 'lst_004',
        title: 'Local Commercial / Bureau sur Avenue Principale',
        description:
            'Emplacement commercial stratégique à fort passage piéton et véhicule. Idéal pour agence bancaire, boutique ou bureaux d\'entreprise.',
        rentPrice: 1200.0,
        cautionPrice: 3600.0,
        city: 'Lubumbashi',
        commune: 'Lubumbashi',
        quartier: 'Centre-Ville',
        avenue: 'Avenue Chaussée M\'siri',
        latitude: -11.6639,
        longitude: 27.4794,
        propertyType: 'Local commercial',
        bedroomsCount: 0,
        livingRoomsCount: 2,
        bathroomsCount: 2,
        hasKitchen: false,
        hasParking: true,
        hasFence: true,
        hasWater: true,
        hasElectricity: true,
        hasInternet: true,
        hasGarden: false,
        photos: [
          'https://images.unsplash.com/photo-1497366216548-37526070297c',
        ],
        ownerId: 'own_104',
        ownerName: 'Congo Real Estate Ltd',
        ownerPhone: '+243970004444',
        ownerWhatsApp: '+243970004444',
        publishedAt: DateTime.now().subtract(const Duration(days: 10)),
        status: ListingStatus.rented,
        isListingVerified: true,
        isOwnerVerified: true,
        viewsCount: 512,
        favoritesCount: 40,
        contactsCount: 29,
        callsCount: 18,
        whatsappCount: 11,
      ),
      Listing(
        id: 'lst_005',
        title: 'Chambre Indépendante dans Parcelle Calme',
        description:
            'Chambre autonome avec salle de bain privée, compteur d\'électricité prépayé et accès eau garanti.',
        rentPrice: 180.0,
        cautionPrice: 540.0,
        city: 'Goma',
        commune: 'Karisimbi',
        quartier: 'Mabanga Nord',
        avenue: 'Avenue de la Paix',
        latitude: -1.6788,
        longitude: 29.2311,
        propertyType: 'Chambre',
        bedroomsCount: 1,
        livingRoomsCount: 0,
        bathroomsCount: 1,
        hasKitchen: false,
        hasParking: false,
        hasFence: true,
        hasWater: true,
        hasElectricity: true,
        hasInternet: false,
        hasGarden: true,
        photos: [
          'https://images.unsplash.com/photo-1598928506311-c55ded91a20c',
        ],
        ownerId: 'own_105',
        ownerName: 'Ephrem Kanyamunyu',
        ownerPhone: '+243990005555',
        ownerWhatsApp: '+243990005555',
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        status: ListingStatus.available,
        isListingVerified: false,
        isOwnerVerified: false,
        viewsCount: 120,
        favoritesCount: 6,
        contactsCount: 3,
        callsCount: 2,
        whatsappCount: 1,
      ),
    ];

    _allUsers.addAll([
      _currentUser,
      AppUser(
        id: 'own_101',
        name: 'Mbala Immobilier',
        email: 'contact@mbala.cd',
        phone: '+243890001111',
        whatsapp: '+243890001111',
        role: UserRole.agency,
        isVerified: true,
        agencyName: 'Mbala Immobilier Sarl',
        agencyAgents: ['Patrick Mbala', 'Grace Kanku'],
        subscriptionPlan: 'Premium',
      ),
      AppUser(
        id: 'own_102',
        name: 'Alain Mukendi',
        email: 'alain.mukendi@gmail.com',
        phone: '+243820002222',
        whatsapp: '+243820002222',
        role: UserRole.owner,
        isVerified: true,
      ),
      AppUser(
        id: 'adm_001',
        name: 'Admin FIND DRC',
        email: 'admin@find.cd',
        phone: '+243800000000',
        whatsapp: '+243800000000',
        role: UserRole.admin,
      ),
    ]);
  }

  // Set User Role / User Switch
  void switchUserRole(UserRole role) {
    _currentUser = _currentUser.copyWith(role: role);
    notifyListeners();
  }

  void updateUserProfile({
    String? name,
    String? email,
    String? phone,
    String? whatsapp,
    String? agencyName,
  }) {
    _currentUser = _currentUser.copyWith(
      name: name,
      email: email,
      phone: phone,
      whatsapp: whatsapp,
      agencyName: agencyName,
    );
    notifyListeners();
  }

  // Search & Filter
  void setSearchQuery(String query) {
    _searchQuery = query;
    if (query.trim().isNotEmpty && !_searchHistory.contains(query.trim())) {
      _searchHistory.insert(0, query.trim());
    }
    notifyListeners();
  }

  void setFilterCriteria(FilterCriteria filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void clearFilter() {
    _currentFilter = FilterCriteria();
    _searchQuery = '';
    notifyListeners();
  }

  List<Listing> get filteredListings {
    return _listings.where((item) {
      // Search query check
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(q);
        final matchCity = item.city.toLowerCase().contains(q);
        final matchCommune = item.commune.toLowerCase().contains(q);
        final matchQuartier = item.quartier.toLowerCase().contains(q);
        final matchType = item.propertyType.toLowerCase().contains(q);
        if (!matchTitle && !matchCity && !matchCommune && !matchQuartier && !matchType) {
          return false;
        }
      }

      // Filter criteria check
      if (_currentFilter.city != null && _currentFilter.city!.isNotEmpty) {
        if (item.city.toLowerCase() != _currentFilter.city!.toLowerCase()) {
          return false;
        }
      }
      if (_currentFilter.commune != null && _currentFilter.commune!.isNotEmpty) {
        if (!item.commune.toLowerCase().contains(_currentFilter.commune!.toLowerCase())) {
          return false;
        }
      }
      if (_currentFilter.quartier != null && _currentFilter.quartier!.isNotEmpty) {
        if (!item.quartier.toLowerCase().contains(_currentFilter.quartier!.toLowerCase())) {
          return false;
        }
      }
      if (_currentFilter.propertyType != null && _currentFilter.propertyType!.isNotEmpty) {
        if (item.propertyType.toLowerCase() != _currentFilter.propertyType!.toLowerCase()) {
          return false;
        }
      }
      if (_currentFilter.minPrice != null) {
        if (item.rentPrice < _currentFilter.minPrice!) {
          return false;
        }
      }
      if (_currentFilter.maxPrice != null) {
        if (item.rentPrice > _currentFilter.maxPrice!) {
          return false;
        }
      }
      if (_currentFilter.minBedrooms != null) {
        if (item.bedroomsCount < _currentFilter.minBedrooms!) {
          return false;
        }
      }
      if (_currentFilter.availableOnly) {
        if (item.status != ListingStatus.available) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  List<Listing> get latestListings {
    final list = List<Listing>.from(_listings);
    list.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    return list;
  }

  List<Listing> get favoriteListings {
    return _listings.where((l) => _favoriteIds.contains(l.id)).toList();
  }

  List<Listing> get userListings {
    return _listings.where((l) => l.ownerId == _currentUser.id).toList();
  }

  void toggleFavorite(String listingId) {
    if (_favoriteIds.contains(listingId)) {
      _favoriteIds.remove(listingId);
    } else {
      _favoriteIds.add(listingId);
    }
    notifyListeners();
  }

  bool isFavorite(String listingId) => _favoriteIds.contains(listingId);

  // Listing CRUD
  void addListing(Listing listing) {
    _listings.insert(0, listing);

    // Auto-generate notification for saved searches
    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Nouveau logement correspondant !',
        message: '${listing.propertyType} à ${listing.commune}, ${listing.city} (\$${listing.rentPrice.toStringAsFixed(0)}/mois)',
        listingId: listing.id,
        createdAt: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  void updateListing(Listing updated) {
    final index = _listings.indexWhere((l) => l.id == updated.id);
    if (index != -1) {
      _listings[index] = updated;
      notifyListeners();
    }
  }

  void deleteListing(String listingId) {
    _listings.removeWhere((l) => l.id == listingId);
    _favoriteIds.remove(listingId);
    notifyListeners();
  }

  void suspendListing(String listingId) {
    final index = _listings.indexWhere((l) => l.id == listingId);
    if (index != -1) {
      _listings[index] = _listings[index].copyWith(status: ListingStatus.suspended);
      notifyListeners();
    }
  }

  void markAsRented(String listingId) {
    final index = _listings.indexWhere((l) => l.id == listingId);
    if (index != -1) {
      _listings[index] = _listings[index].copyWith(status: ListingStatus.rented);
      notifyListeners();
    }
  }

  // Metrics increment
  void incrementViews(String listingId) {
    final index = _listings.indexWhere((l) => l.id == listingId);
    if (index != -1) {
      _listings[index] = _listings[index].copyWith(
        viewsCount: _listings[index].viewsCount + 1,
      );
      notifyListeners();
    }
  }

  void incrementCalls(String listingId) {
    final index = _listings.indexWhere((l) => l.id == listingId);
    if (index != -1) {
      _listings[index] = _listings[index].copyWith(
        callsCount: _listings[index].callsCount + 1,
        contactsCount: _listings[index].contactsCount + 1,
      );
      notifyListeners();
    }
  }

  void incrementWhatsApp(String listingId) {
    final index = _listings.indexWhere((l) => l.id == listingId);
    if (index != -1) {
      _listings[index] = _listings[index].copyWith(
        whatsappCount: _listings[index].whatsappCount + 1,
        contactsCount: _listings[index].contactsCount + 1,
      );
      notifyListeners();
    }
  }

  // Fraud Reporting
  void submitReport({
    required String listingId,
    required String listingTitle,
    required String reason,
    required String details,
  }) {
    final report = Report(
      id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
      listingId: listingId,
      listingTitle: listingTitle,
      reporterName: _currentUser.name,
      reason: reason,
      details: details,
      createdAt: DateTime.now(),
    );
    _reports.insert(0, report);
    notifyListeners();
  }

  void resolveReport(String reportId, String newStatus) {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      _reports[index] = _reports[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  // Identity Verification Request (Owner -> Admin)
  void requestOwnerVerification() {
    _currentUser = _currentUser.copyWith(isVerified: true);
    notifyListeners();
  }

  // Admin moderation
  void setListingVerifiedBadge(String listingId, bool isVerified) {
    final index = _listings.indexWhere((l) => l.id == listingId);
    if (index != -1) {
      _listings[index] = _listings[index].copyWith(isListingVerified: isVerified);
      notifyListeners();
    }
  }

  void setOwnerVerifiedBadge(String listingId, bool isVerified) {
    final index = _listings.indexWhere((l) => l.id == listingId);
    if (index != -1) {
      _listings[index] = _listings[index].copyWith(isOwnerVerified: isVerified);
      notifyListeners();
    }
  }

  // Agency management
  void addAgencyAgent(String agentName) {
    final updatedAgents = List<String>.from(_currentUser.agencyAgents)..add(agentName);
    _currentUser = _currentUser.copyWith(agencyAgents: updatedAgents);
    notifyListeners();
  }

  void upgradeAgencyPlan(String planName) {
    _currentUser = _currentUser.copyWith(subscriptionPlan: planName);
    notifyListeners();
  }

  void markNotificationRead(String notifId) {
    final index = _notifications.indexWhere((n) => n.id == notifId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:find_app/models/app_user.dart';
import 'package:find_app/models/filter_criteria.dart';
import 'package:find_app/models/listing.dart';
import 'package:find_app/services/app_provider.dart';

void main() {
  group('Domain Models Tests', () {
    test('AppUser creation and role labels', () {
      final user = AppUser(
        id: 'usr_test',
        name: 'Test User',
        email: 'test@find.cd',
        phone: '+243000000',
        whatsapp: '+243000000',
        role: UserRole.owner,
      );

      expect(user.id, 'usr_test');
      expect(user.role.label, 'Propriétaire');

      final updated = user.copyWith(isVerified: true, role: UserRole.admin);
      expect(updated.isVerified, isTrue);
      expect(updated.role.label, 'Administrateur');
    });

    test('Listing status and new/rented getters', () {
      final recentListing = Listing(
        id: 'l_1',
        title: 'Appartement Test',
        description: 'Desc',
        rentPrice: 500,
        cautionPrice: 1500,
        city: 'Kinshasa',
        commune: 'Gombe',
        quartier: 'Golf',
        avenue: 'Avenue Test',
        latitude: -4.3,
        longitude: 15.3,
        propertyType: 'Appartement',
        bedroomsCount: 2,
        livingRoomsCount: 1,
        bathroomsCount: 1,
        photos: [],
        ownerId: 'own_1',
        ownerName: 'Owner',
        ownerPhone: '123',
        ownerWhatsApp: '123',
        publishedAt: DateTime.now(),
        status: ListingStatus.available,
      );

      expect(recentListing.isNewListing, isTrue);
      expect(recentListing.isRented, isFalse);

      final rentedListing = recentListing.copyWith(status: ListingStatus.rented);
      expect(rentedListing.isRented, isTrue);
    });

    test('FilterCriteria isEmpty check', () {
      final emptyFilter = FilterCriteria();
      expect(emptyFilter.isEmpty, isTrue);

      final filterWithCity = FilterCriteria(city: 'Kinshasa');
      expect(filterWithCity.isEmpty, isFalse);
    });
  });

  group('AppProvider State & Business Logic Tests', () {
    late AppProvider provider;

    setUp(() {
      provider = AppProvider();
    });

    test('Initial state contains DRC mock listings', () {
      expect(provider.latestListings.isNotEmpty, isTrue);
      expect(provider.currentUser.role, UserRole.tenant);
    });

    test('Role switching works for all 5 roles', () {
      for (final role in UserRole.values) {
        provider.switchUserRole(role);
        expect(provider.currentUser.role, role);
      }
    });

    test('Search text query filtering', () {
      provider.setSearchQuery('Gombe');
      expect(provider.filteredListings.every((l) =>
        l.title.toLowerCase().contains('gombe') ||
        l.commune.toLowerCase().contains('gombe') ||
        l.city.toLowerCase().contains('gombe')
      ), isTrue);
    });

    test('Multi-criteria filtering (city, type, maxPrice)', () {
      provider.setFilterCriteria(FilterCriteria(
        city: 'Kinshasa',
        propertyType: 'Maison',
        maxPrice: 3000,
      ));

      final results = provider.filteredListings;
      for (final item in results) {
        expect(item.city.toLowerCase(), 'kinshasa');
        expect(item.propertyType.toLowerCase(), 'maison');
        expect(item.rentPrice <= 3000, isTrue);
      }
    });

    test('Favoriting functionality', () {
      const listingId = 'lst_002';
      final isInitiallyFav = provider.isFavorite(listingId);

      provider.toggleFavorite(listingId);
      expect(provider.isFavorite(listingId), !isInitiallyFav);

      provider.toggleFavorite(listingId);
      expect(provider.isFavorite(listingId), isInitiallyFav);
    });

    test('Listing CRUD operations', () {
      final newListing = Listing(
        id: 'lst_new_1',
        title: 'Nouvelle Maison Test',
        description: 'Description test',
        rentPrice: 800,
        cautionPrice: 2400,
        city: 'Lubumbashi',
        commune: 'Lubumbashi',
        quartier: 'Centre',
        avenue: 'Avenue Test',
        latitude: -11.6,
        longitude: 27.4,
        propertyType: 'Maison',
        bedroomsCount: 3,
        livingRoomsCount: 1,
        bathroomsCount: 2,
        photos: ['https://example.com/photo.jpg'],
        ownerId: provider.currentUser.id,
        ownerName: provider.currentUser.name,
        ownerPhone: provider.currentUser.phone,
        ownerWhatsApp: provider.currentUser.whatsapp,
        publishedAt: DateTime.now(),
      );

      final initialCount = provider.latestListings.length;
      provider.addListing(newListing);
      expect(provider.latestListings.length, initialCount + 1);

      // Mark as rented
      provider.markAsRented('lst_new_1');
      final rented = provider.latestListings.firstWhere((l) => l.id == 'lst_new_1');
      expect(rented.isRented, isTrue);

      // Delete listing
      provider.deleteListing('lst_new_1');
      expect(provider.latestListings.any((l) => l.id == 'lst_new_1'), isFalse);
    });

    test('Fraud report submission and resolution', () {
      provider.submitReport(
        listingId: 'lst_001',
        listingTitle: 'Listing Title',
        reason: 'Fraud suspected',
        details: 'Fake photos',
      );

      expect(provider.reports.length, 1);
      expect(provider.reports.first.reason, 'Fraud suspected');

      provider.resolveReport(provider.reports.first.id, 'resolved');
      expect(provider.reports.first.status, 'resolved');
    });
  });
}

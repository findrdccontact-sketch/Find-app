import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:find_app/main.dart';
import 'package:find_app/models/app_user.dart';
import 'package:find_app/models/listing.dart';
import 'package:find_app/screens/home_screen.dart';
import 'package:find_app/screens/listing_detail_screen.dart';
import 'package:find_app/screens/owner_dashboard_screen.dart';
import 'package:find_app/screens/search_screen.dart';
import 'package:find_app/services/app_provider.dart';

void main() {
  Widget buildTestableWidget(Widget child, {AppProvider? customProvider}) {
    return ChangeNotifierProvider<AppProvider>(
      create: (_) => customProvider ?? AppProvider(),
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }

  testWidgets('FindApp main navigation renders home tab and bottom navigation bar', (WidgetTester tester) async {
    await tester.pumpWidget(const FindApp());
    await tester.pumpAndSettle();

    expect(find.text('FIND'), findsOneWidget);
    expect(find.text('« Trouvez votre prochain chez-vous. »'), findsOneWidget);
    expect(find.text('Accueil'), findsOneWidget);
    expect(find.text('Recherche'), findsOneWidget);
    expect(find.text('Publier'), findsOneWidget);
    expect(find.text('Mon Espace'), findsOneWidget);
  });

  testWidgets('HomeScreen renders categories and list items', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        HomeScreen(
          onListingSelect: (_) {},
          onNavigateToPublish: () {},
          onCategorySelect: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Catégories'), findsOneWidget);
    expect(find.text('Tous'), findsOneWidget);
    expect(find.text('Maison'), findsOneWidget);
    expect(find.text('Appartement'), findsOneWidget);
    expect(find.text('Dernières annonces'), findsOneWidget);
  });

  testWidgets('SearchScreen expands filters and toggles map view', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        SearchScreen(
          onListingSelect: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Recherche & Filtres'), findsOneWidget);

    // Expand filter tile
    final expansionTile = find.byType(ExpansionTile);
    expect(expansionTile, findsOneWidget);
    await tester.tap(expansionTile);
    await tester.pumpAndSettle();

    expect(find.text('Ville'), findsOneWidget);
    expect(find.text('Type de bien'), findsOneWidget);

    // Toggle Map View
    final mapIconBtn = find.byIcon(Icons.map);
    expect(mapIconBtn, findsOneWidget);
    await tester.tap(mapIconBtn);
    await tester.pumpAndSettle();

    expect(find.text('République Démocratique du Congo'), findsOneWidget);
  });

  testWidgets('ListingDetailScreen renders details, badges, and contact buttons', (WidgetTester tester) async {
    final provider = AppProvider();
    final sampleListing = provider.latestListings.first;

    await tester.pumpWidget(
      buildTestableWidget(
        ListingDetailScreen(
          listing: sampleListing,
          onBack: () {},
        ),
        customProvider: provider,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(sampleListing.title), findsAtLeastNWidgets(1));
    expect(find.text('Localisation'), findsOneWidget);
    expect(find.text('Caractéristiques'), findsOneWidget);
    expect(find.text('Appeler'), findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);
  });

  testWidgets('OwnerDashboardScreen requires confirmation before deleting listing', (WidgetTester tester) async {
    final provider = AppProvider();
    provider.switchUserRole(UserRole.owner);

    // Add a listing owned by the current owner user
    provider.addListing(
      Listing(
        id: 'test_owner_listing',
        title: 'Maison Test Propriétaire',
        description: 'Description test',
        rentPrice: 600,
        cautionPrice: 1800,
        city: 'Kinshasa',
        commune: 'Gombe',
        quartier: 'Centre',
        avenue: 'Avenue Test',
        latitude: -4.3,
        longitude: 15.3,
        propertyType: 'Maison',
        bedroomsCount: 3,
        livingRoomsCount: 1,
        bathroomsCount: 2,
        photos: [],
        ownerId: provider.currentUser.id,
        ownerName: provider.currentUser.name,
        ownerPhone: provider.currentUser.phone,
        ownerWhatsApp: provider.currentUser.whatsapp,
        publishedAt: DateTime.now(),
      ),
    );

    expect(provider.userListings.isNotEmpty, isTrue);
    final initialCount = provider.userListings.length;
    final targetListing = provider.userListings.first;

    await tester.pumpWidget(
      buildTestableWidget(
        OwnerDashboardScreen(
          onEditListing: (_) {},
        ),
        customProvider: provider,
      ),
    );
    await tester.pumpAndSettle();

    // Verify delete button tooltip
    final deleteButtons = find.byTooltip('Supprimer l\'annonce');
    expect(deleteButtons, findsWidgets);

    // Scroll until delete button is visible and tap it
    await tester.ensureVisible(deleteButtons.first);
    await tester.pumpAndSettle();
    await tester.tap(deleteButtons.first);
    await tester.pumpAndSettle();

    // Dialog appears
    expect(find.text('Confirmer la suppression'), findsOneWidget);
    expect(
      find.text('Êtes-vous sûr de vouloir supprimer l\'annonce "${targetListing.title}" ? Cette action est irréversible.'),
      findsOneWidget,
    );

    // Listing has NOT been deleted yet
    expect(provider.userListings.length, initialCount);

    // Tap 'Annuler'
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();

    // Dialog dismissed and still not deleted
    expect(find.text('Confirmer la suppression'), findsNothing);
    expect(provider.userListings.length, initialCount);

    // Scroll until delete button is visible and tap delete button again
    await tester.ensureVisible(deleteButtons.first);
    await tester.pumpAndSettle();
    await tester.tap(deleteButtons.first);
    await tester.pumpAndSettle();

    // Confirm deletion
    await tester.tap(find.text('Supprimer'));
    await tester.pumpAndSettle();

    // Listing deleted and feedback shown
    expect(provider.userListings.length, initialCount - 1);
    expect(find.text('Annonce supprimée avec succès.'), findsOneWidget);
  });
}

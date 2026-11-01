import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:find_app/main.dart';
import 'package:find_app/screens/home_screen.dart';
import 'package:find_app/models/app_user.dart';
import 'package:find_app/screens/listing_detail_screen.dart';
import 'package:find_app/screens/owner_dashboard_screen.dart';
import 'package:find_app/screens/search_screen.dart';
import 'package:find_app/services/app_provider.dart';

void main() {
  Widget buildTestableWidget(Widget child, {AppProvider? customProvider}) {
    return ChangeNotifierProvider<AppProvider>(
      create: (_) => customProvider ?? AppProvider(),
      child: MaterialApp(
        home: child is Scaffold ? child : Scaffold(body: child),
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

  testWidgets('OwnerDashboardScreen delete button shows confirmation dialog and handles cancel/confirm', (WidgetTester tester) async {
    final provider = AppProvider();
    provider.switchUserRole(UserRole.owner);
    // Add a listing owned by the current user
    final sampleListing = provider.latestListings.first.copyWith(
      id: 'lst_test_owner',
      ownerId: provider.currentUser.id,
      title: 'Mon Logement de Test',
    );
    provider.addListing(sampleListing);

    await tester.pumpWidget(
      buildTestableWidget(
        OwnerDashboardScreen(
          onEditListing: (_) {},
        ),
        customProvider: provider,
      ),
    );
    await tester.pumpAndSettle();

    final deleteBtn = find.byTooltip('Supprimer le logement');
    expect(deleteBtn, findsWidgets);

    final initialCount = provider.userListings.length;
    expect(initialCount, greaterThan(0));

    // Scroll until deleteBtn is visible, then tap
    await tester.ensureVisible(deleteBtn.first);
    await tester.pumpAndSettle();
    await tester.tap(deleteBtn.first);
    await tester.pumpAndSettle();

    // Confirmation dialog should be displayed
    expect(find.text('Supprimer le logement'), findsOneWidget);
    expect(find.text('Annuler'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Supprimer'), findsOneWidget);

    // Cancel deletion
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();

    expect(find.text('Supprimer le logement'), findsNothing);
    expect(provider.userListings.length, equals(initialCount));

    // Tap delete again and confirm
    await tester.ensureVisible(deleteBtn.first);
    await tester.pumpAndSettle();
    await tester.tap(deleteBtn.first);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Supprimer'));
    await tester.pumpAndSettle();

    expect(find.text('Logement supprimé avec succès.'), findsOneWidget);
    expect(provider.userListings.length, equals(initialCount - 1));
  });
}

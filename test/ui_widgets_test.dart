import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:find_app/main.dart';
import 'package:find_app/screens/home_screen.dart';
import 'package:find_app/screens/listing_detail_screen.dart';
import 'package:find_app/screens/search_screen.dart';
import 'package:find_app/services/app_provider.dart';

void main() {
  Widget buildTestableWidget(Widget child, {AppProvider? customProvider}) {
    return ChangeNotifierProvider<AppProvider>(
      create: (_) => customProvider ?? AppProvider(),
      child: MaterialApp(
        home: child,
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

    // Verify accessible tooltips on action buttons
    expect(find.byTooltip('Retour'), findsOneWidget);
    expect(
      find.byTooltip(provider.isFavorite(sampleListing.id) ? 'Retirer des favoris' : 'Ajouter aux favoris'),
      findsOneWidget,
    );
    expect(find.byTooltip('Partager l\'annonce'), findsOneWidget);
    expect(find.byTooltip('Signaler l\'annonce'), findsOneWidget);
  });
}

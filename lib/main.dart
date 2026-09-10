import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/listing.dart';
import 'screens/home_screen.dart';
import 'screens/listing_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/publish_listing_screen.dart';
import 'screens/search_screen.dart';
import 'services/app_provider.dart';

void main() {
  runApp(const FindApp());
}

class FindApp extends StatelessWidget {
  const FindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        title: 'FIND - DRC Real Estate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A237E), // Deep Indigo
            primary: const Color(0xFF1A237E),
            secondary: const Color(0xFFFF6D00), // Vibrant Amber/Orange
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            elevation: 0,
          ),
        ),
        home: const MainNavigationShell(),
      ),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;
  Listing? _selectedListing;
  String? _initialSearchCategory;

  void _onSelectListing(Listing listing) {
    setState(() {
      _selectedListing = listing;
    });
  }

  void _onCategorySelect(String category) {
    setState(() {
      _initialSearchCategory = category;
      _currentIndex = 1; // Switch to Search tab
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedListing != null) {
      return ListingDetailScreen(
        listing: _selectedListing!,
        onBack: () {
          setState(() {
            _selectedListing = null;
          });
        },
      );
    }

    final screens = [
      HomeScreen(
        onListingSelect: _onSelectListing,
        onNavigateToPublish: () {
          setState(() {
            _currentIndex = 2; // Switch to Publish tab
          });
        },
        onCategorySelect: _onCategorySelect,
      ),
      SearchScreen(
        onListingSelect: _onSelectListing,
        initialCategory: _initialSearchCategory,
      ),
      PublishListingScreen(
        onPublished: () {
          setState(() {
            _currentIndex = 0; // Return to Home
          });
        },
      ),
      ProfileScreen(
        onListingSelect: _onSelectListing,
        onNavigateToPublish: () {
          setState(() {
            _currentIndex = 2;
          });
        },
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Recherche',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Publier',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Mon Espace',
          ),
        ],
      ),
    );
  }
}

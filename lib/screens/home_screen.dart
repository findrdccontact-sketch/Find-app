import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/listing.dart';
import '../services/app_provider.dart';
import '../widgets/listing_card.dart';

class HomeScreen extends StatefulWidget {
  final Function(Listing) onListingSelect;
  final VoidCallback onNavigateToPublish;
  final Function(String category) onCategorySelect;

  const HomeScreen({
    super.key,
    required this.onListingSelect,
    required this.onNavigateToPublish,
    required this.onCategorySelect,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tous';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Tous', 'icon': Icons.grid_view},
    {'name': 'Maison', 'icon': Icons.house},
    {'name': 'Appartement', 'icon': Icons.apartment},
    {'name': 'Chambre', 'icon': Icons.single_bed},
    {'name': 'Studio', 'icon': Icons.king_bed},
    {'name': 'Local commercial', 'icon': Icons.storefront},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final listings = _selectedCategory == 'Tous'
        ? provider.latestListings
        : provider.latestListings
            .where((l) => l.propertyType.toLowerCase() == _selectedCategory.toLowerCase())
            .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Header
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Colors.indigo.shade800,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.home_work, color: Colors.indigo, size: 28),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'FIND',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '« Trouvez votre prochain chez-vous. »',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                tooltip: 'Notifications',
                onPressed: () {
                  _showNotificationsDialog(context, provider);
                },
              ),
            ],
          ),

          // Search Bar & Action Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Rechercher ville, commune, type...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    tooltip: 'Effacer la recherche',
                                    onPressed: () {
                                      _searchController.clear();
                                      provider.setSearchQuery('');
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          onSubmitted: (value) {
                            provider.setSearchQuery(value);
                            widget.onCategorySelect(_selectedCategory);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          provider.setSearchQuery(_searchController.text);
                          widget.onCategorySelect(_selectedCategory);
                        },
                        child: const Text('Rechercher'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Publier une annonce Button CTA
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
                      ),
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text(
                        'Publier une annonce',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: widget.onNavigateToPublish,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Categories header
                  const Text(
                    'Catégories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Categories horizontal list
                  SizedBox(
                    height: 45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = _selectedCategory == cat['name'];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            selected: isSelected,
                            avatar: Icon(
                              cat['icon'] as IconData,
                              size: 18,
                              color: isSelected ? Colors.white : Colors.indigo,
                            ),
                            label: Text(cat['name'] as String),
                            selectedColor: Theme.of(context).primaryColor,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = cat['name'] as String;
                              });
                              widget.onCategorySelect(_selectedCategory);
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Latest Listings Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Dernières annonces',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${listings.length} logement(s)',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Listings List
          listings.isEmpty
              ? SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: const [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'Aucune annonce trouvée',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = listings[index];
                      return ListingCard(
                        listing: item,
                        isFavorite: provider.isFavorite(item.id),
                        onTap: () {
                          provider.incrementViews(item.id);
                          widget.onListingSelect(item);
                        },
                        onFavoriteToggle: () => provider.toggleFavorite(item.id),
                      );
                    },
                    childCount: listings.length,
                  ),
                ),
        ],
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.notifications_active, color: Colors.indigo),
            SizedBox(width: 8),
            Text('Notifications'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: provider.notifications.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Aucune notification pour le moment.'),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: provider.notifications.length,
                  separatorBuilder: (c, i) => const Divider(),
                  itemBuilder: (c, index) {
                    final notif = provider.notifications[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        notif.title,
                        style: TextStyle(
                          fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(notif.message),
                      trailing: notif.isRead
                          ? null
                          : const Icon(Icons.circle, size: 10, color: Colors.blue),
                      onTap: () {
                        provider.markNotificationRead(notif.id);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/filter_criteria.dart';
import '../models/listing.dart';
import '../services/app_provider.dart';
import '../widgets/listing_card.dart';
import '../widgets/map_view.dart';

class SearchScreen extends StatefulWidget {
  final Function(Listing) onListingSelect;
  final String? initialCategory;

  const SearchScreen({
    super.key,
    required this.onListingSelect,
    this.initialCategory,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isMapView = false;
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _communeController = TextEditingController();
  final TextEditingController _quartierController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  String? _selectedType;
  int? _minBedrooms;
  bool _availableOnly = true;

  final List<String> _cities = [
    'Toutes',
    'Kinshasa',
    'Lubumbashi',
    'Goma',
    'Bukavu',
    'Kisangani',
    'Matadi',
  ];

  final List<String> _propertyTypes = [
    'Tous',
    'Maison',
    'Appartement',
    'Chambre',
    'Studio',
    'Local commercial',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null && widget.initialCategory != 'Tous') {
      _selectedType = widget.initialCategory;
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    _communeController.dispose();
    _quartierController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _applyFilters(AppProvider provider) {
    double? minPrice = double.tryParse(_minPriceController.text);
    double? maxPrice = double.tryParse(_maxPriceController.text);

    provider.setFilterCriteria(FilterCriteria(
      city: _cityController.text == 'Toutes' ? null : _cityController.text,
      commune: _communeController.text,
      quartier: _quartierController.text,
      minPrice: minPrice,
      maxPrice: maxPrice,
      propertyType: _selectedType == 'Tous' ? null : _selectedType,
      minBedrooms: _minBedrooms,
      availableOnly: _availableOnly,
    ));
  }

  void _resetFilters(AppProvider provider) {
    setState(() {
      _cityController.clear();
      _communeController.clear();
      _quartierController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
      _selectedType = null;
      _minBedrooms = null;
      _availableOnly = true;
    });
    provider.clearFilter();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final listings = provider.filteredListings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche & Filtres'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.format_list_bulleted : Icons.map),
            tooltip: _isMapView ? 'Vue Liste' : 'Vue Carte',
            onPressed: () {
              setState(() {
                _isMapView = !_isMapView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_off),
            tooltip: 'Réinitialiser',
            onPressed: () => _resetFilters(provider),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter expander panel
          ExpansionTile(
            leading: const Icon(Icons.filter_list, color: Colors.indigo),
            title: Text(
              'Filtres de recherche (${listings.length} résultats)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    // City & Property Type row
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _cityController.text.isEmpty ? 'Toutes' : _cityController.text,
                            decoration: const InputDecoration(
                              labelText: 'Ville',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (val) {
                              setState(() {
                                _cityController.text = val ?? '';
                              });
                              _applyFilters(provider);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedType ?? 'Tous',
                            decoration: const InputDecoration(
                              labelText: 'Type de bien',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            items: _propertyTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedType = val;
                              });
                              _applyFilters(provider);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Commune & Quartier row
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _communeController,
                            decoration: const InputDecoration(
                              labelText: 'Commune (ex: Gombe)',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => _applyFilters(provider),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _quartierController,
                            decoration: const InputDecoration(
                              labelText: 'Quartier',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => _applyFilters(provider),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Price Range & Bedrooms row
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Prix min (\$)',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => _applyFilters(provider),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _maxPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Prix max (\$)',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) => _applyFilters(provider),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Bedrooms dropdown & Availability toggle
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int?>(
                            initialValue: _minBedrooms,
                            decoration: const InputDecoration(
                              labelText: 'Chambres min.',
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(value: null, child: Text('Indifférent')),
                              DropdownMenuItem(value: 1, child: Text('1+')),
                              DropdownMenuItem(value: 2, child: Text('2+')),
                              DropdownMenuItem(value: 3, child: Text('3+')),
                              DropdownMenuItem(value: 4, child: Text('4+')),
                            ],
                            onChanged: (val) {
                              setState(() {
                                _minBedrooms = val;
                              });
                              _applyFilters(provider);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CheckboxListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Disponibles uni.', style: TextStyle(fontSize: 12)),
                            value: _availableOnly,
                            onChanged: (val) {
                              setState(() {
                                _availableOnly = val ?? true;
                              });
                              _applyFilters(provider);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 1),

          // Main Search Content View (List View or Map View)
          Expanded(
            child: _isMapView
                ? MapViewWidget(
                    listings: listings,
                    onListingSelected: widget.onListingSelect,
                  )
                : listings.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 64, color: Colors.grey),
                            const SizedBox(height: 12),
                            const Text(
                              'Aucun logement ne correspond à vos critères.',
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => _resetFilters(provider),
                              child: const Text('Réinitialiser les filtres'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: listings.length,
                        itemBuilder: (context, index) {
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
                      ),
          ),
        ],
      ),
    );
  }
}

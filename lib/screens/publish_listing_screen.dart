import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/listing.dart';
import '../services/app_provider.dart';

class PublishListingScreen extends StatefulWidget {
  final VoidCallback onPublished;

  const PublishListingScreen({
    super.key,
    required this.onPublished,
  });

  @override
  State<PublishListingScreen> createState() => _PublishListingScreenState();
}

class _PublishListingScreenState extends State<PublishListingScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rentPriceController = TextEditingController();
  final TextEditingController _cautionPriceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController(text: 'Kinshasa');
  final TextEditingController _communeController = TextEditingController();
  final TextEditingController _quartierController = TextEditingController();
  final TextEditingController _avenueController = TextEditingController();
  final TextEditingController _latController = TextEditingController(text: '-4.3250');
  final TextEditingController _lngController = TextEditingController(text: '15.3222');
  final TextEditingController _videoUrlController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  String _propertyType = 'Appartement';
  int _bedrooms = 2;
  int _livingRooms = 1;
  int _bathrooms = 1;

  bool _hasKitchen = true;
  bool _hasParking = false;
  bool _hasFence = true;
  bool _hasWater = true;
  bool _hasElectricity = true;
  bool _hasInternet = false;
  bool _hasGarden = false;

  final List<String> _photos = [];

  final List<String> _cities = ['Kinshasa', 'Lubumbashi', 'Goma', 'Bukavu', 'Kisangani', 'Matadi'];
  final List<String> _propertyTypes = ['Maison', 'Appartement', 'Chambre', 'Studio', 'Local commercial'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AppProvider>(context, listen: false).currentUser;
      _phoneController.text = user.phone;
      _whatsappController.text = user.whatsapp;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _rentPriceController.dispose();
    _cautionPriceController.dispose();
    _cityController.dispose();
    _communeController.dispose();
    _quartierController.dispose();
    _avenueController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _videoUrlController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  void _addMockPhoto() {
    if (_photos.length >= 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Limite maximale de 20 photos atteinte.')),
      );
      return;
    }
    final mockUrls = [
      'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
      'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688',
      'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2',
      'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9',
      'https://images.unsplash.com/photo-1536376072261-38c75010e6c9',
    ];
    final nextUrl = mockUrls[_photos.length % mockUrls.length];
    setState(() {
      _photos.add(nextUrl);
    });
  }

  void _submitListing(AppProvider provider) {
    if (_formKey.currentState!.validate()) {
      if (_photos.isEmpty) {
        _photos.add('https://images.unsplash.com/photo-1522708323590-d24dbb6b0267');
      }

      final newListing = Listing(
        id: 'lst_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text,
        description: _descriptionController.text,
        rentPrice: double.parse(_rentPriceController.text),
        cautionPrice: double.parse(_cautionPriceController.text),
        city: _cityController.text,
        commune: _communeController.text,
        quartier: _quartierController.text,
        avenue: _avenueController.text,
        latitude: double.tryParse(_latController.text) ?? -4.3250,
        longitude: double.tryParse(_lngController.text) ?? 15.3222,
        propertyType: _propertyType,
        bedroomsCount: _bedrooms,
        livingRoomsCount: _livingRooms,
        bathroomsCount: _bathrooms,
        hasKitchen: _hasKitchen,
        hasParking: _hasParking,
        hasFence: _hasFence,
        hasWater: _hasWater,
        hasElectricity: _hasElectricity,
        hasInternet: _hasInternet,
        hasGarden: _hasGarden,
        photos: _photos,
        videoUrl: _videoUrlController.text.isEmpty ? null : _videoUrlController.text,
        ownerId: provider.currentUser.id,
        ownerName: provider.currentUser.name,
        ownerPhone: _phoneController.text,
        ownerWhatsApp: _whatsappController.text,
        publishedAt: DateTime.now(),
        status: ListingStatus.available,
        isListingVerified: false,
        isOwnerVerified: provider.currentUser.isVerified,
      );

      provider.addListing(newListing);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Annonce publiée avec succès !')),
      );

      widget.onPublished();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publier un logement'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'Informations générales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre de l\'annonce *',
                hintText: 'ex: Appartement meublé 3 chambres Gombe',
                border: OutlineInputBorder(),
              ),
              validator: (val) => val == null || val.isEmpty ? 'Champ requis' : null,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _propertyType,
                    decoration: const InputDecoration(
                      labelText: 'Type de logement *',
                      border: OutlineInputBorder(),
                    ),
                    items: _propertyTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (val) => setState(() => _propertyType = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _rentPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Loyer mensuel (\$) *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Requis' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _cautionPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Caution (\$) *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Requis' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Localisation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _cityController.text,
              decoration: const InputDecoration(
                labelText: 'Ville *',
                border: OutlineInputBorder(),
              ),
              items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _cityController.text = val!),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _communeController,
                    decoration: const InputDecoration(
                      labelText: 'Commune *',
                      hintText: 'ex: Gombe',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Requis' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _quartierController,
                    decoration: const InputDecoration(
                      labelText: 'Quartier *',
                      hintText: 'ex: Golf',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Requis' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _avenueController,
              decoration: const InputDecoration(
                labelText: 'Avenue *',
                hintText: 'ex: Avenue de la Justice n°12',
                border: OutlineInputBorder(),
              ),
              validator: (val) => val == null || val.isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _latController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Latitude GPS',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _lngController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Longitude GPS',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Pièces & Équipements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _counterSelector('Chambres', _bedrooms, (val) => setState(() => _bedrooms = val)),
                _counterSelector('Salons', _livingRooms, (val) => setState(() => _livingRooms = val)),
                _counterSelector('Salles de bain', _bathrooms, (val) => setState(() => _bathrooms = val)),
              ],
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                FilterChip(
                  label: const Text('Cuisine'),
                  selected: _hasKitchen,
                  onSelected: (v) => setState(() => _hasKitchen = v),
                ),
                FilterChip(
                  label: const Text('Parking'),
                  selected: _hasParking,
                  onSelected: (v) => setState(() => _hasParking = v),
                ),
                FilterChip(
                  label: const Text('Clôture'),
                  selected: _hasFence,
                  onSelected: (v) => setState(() => _hasFence = v),
                ),
                FilterChip(
                  label: const Text('Eau'),
                  selected: _hasWater,
                  onSelected: (v) => setState(() => _hasWater = v),
                ),
                FilterChip(
                  label: const Text('Électricité'),
                  selected: _hasElectricity,
                  onSelected: (v) => setState(() => _hasElectricity = v),
                ),
                FilterChip(
                  label: const Text('Internet'),
                  selected: _hasInternet,
                  onSelected: (v) => setState(() => _hasInternet = v),
                ),
                FilterChip(
                  label: const Text('Jardin'),
                  selected: _hasGarden,
                  onSelected: (v) => setState(() => _hasGarden = v),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Photos (jusqu\'à 20 photos)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add_a_photo),
                  label: Text('Ajouter (${_photos.length}/20)'),
                  onPressed: _addMockPhoto,
                ),
              ],
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 90,
              child: _photos.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('Aucune photo ajoutée. Cliquez sur "Ajouter".'),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _photos.length,
                      itemBuilder: (ctx, idx) => Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(_photos[idx]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 10,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.close, size: 14, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _photos.removeAt(idx);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _videoUrlController,
              decoration: const InputDecoration(
                labelText: 'Lien vidéo (ex: YouTube / Vimeo)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Description & Contact',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description détaillée *',
                border: OutlineInputBorder(),
              ),
              validator: (val) => val == null || val.isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Téléphone *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Requis' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _whatsappController,
                    decoration: const InputDecoration(
                      labelText: 'WhatsApp *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Requis' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => _submitListing(provider),
              child: const Text('Publier le logement', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _counterSelector(String label, int count, Function(int) onChanged) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: count > 0 ? () => onChanged(count - 1) : null,
            ),
            Text('$count', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => onChanged(count + 1),
            ),
          ],
        ),
      ],
    );
  }
}

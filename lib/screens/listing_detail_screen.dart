import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/listing.dart';
import '../services/app_provider.dart';
import '../widgets/badge_widget.dart';

class ListingDetailScreen extends StatefulWidget {
  final Listing listing;
  final VoidCallback onBack;

  const ListingDetailScreen({
    super.key,
    required this.listing,
    required this.onBack,
  });

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final item = provider.latestListings.firstWhere(
      (l) => l.id == widget.listing.id,
      orElse: () => widget.listing,
    );
    final isFav = provider.isFavorite(item.id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour',
          onPressed: widget.onBack,
        ),
        title: Text(item.title),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            color: isFav ? Colors.red : Colors.white,
            tooltip: isFav ? 'Retirer des favoris' : 'Ajouter aux favoris',
            onPressed: () => provider.toggleFavorite(item.id),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Partager l\'annonce',
            onPressed: () => _shareListing(context, item),
          ),
          IconButton(
            icon: const Icon(Icons.report_problem_outlined),
            color: Colors.amber,
            tooltip: 'Signaler cette annonce',
            onPressed: () => _showReportDialog(context, provider, item),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo Gallery PageView
            Stack(
              children: [
                SizedBox(
                  height: 260,
                  child: item.photos.isNotEmpty
                      ? PageView.builder(
                          itemCount: item.photos.length,
                          onPageChanged: (idx) {
                            setState(() {
                              _currentImageIndex = idx;
                            });
                          },
                          itemBuilder: (ctx, index) {
                            return Image.network(
                              item.photos[index],
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                color: Colors.blueGrey.shade100,
                                child: const Center(
                                  child: Icon(Icons.home, size: 64, color: Colors.grey),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.blueGrey.shade100,
                          child: const Center(
                            child: Icon(Icons.home, size: 64, color: Colors.grey),
                          ),
                        ),
                ),
                // Counter Badge
                if (item.photos.length > 1)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_currentImageIndex + 1} / ${item.photos.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),

            // Main Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges Row
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [
                      if (item.isRented)
                        const ListingBadge(type: BadgeType.rented)
                      else ...[
                        if (item.isListingVerified)
                          const ListingBadge(type: BadgeType.listingVerified),
                        if (item.isOwnerVerified)
                          const ListingBadge(type: BadgeType.ownerVerified),
                        if (item.isNewListing) const ListingBadge(type: BadgeType.newListing),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title & Price
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(
                        '\$${item.rentPrice.toStringAsFixed(0)} / mois',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Caution: \$${item.cautionPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.indigo.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Location Card
                  Card(
                    color: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.redAccent),
                              SizedBox(width: 8),
                              Text('Localisation', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Ville: ${item.city}'),
                          Text('Commune: ${item.commune}'),
                          Text('Quartier: ${item.quartier}'),
                          Text('Avenue: ${item.avenue}'),
                          Text(
                            'GPS: ${item.latitude.toStringAsFixed(4)}, ${item.longitude.toStringAsFixed(4)}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Specifications
                  const Text('Caractéristiques', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _featureChip(Icons.king_bed, '${item.bedroomsCount} Chambre(s)'),
                      _featureChip(Icons.weekend, '${item.livingRoomsCount} Salon(s)'),
                      _featureChip(Icons.bathtub, '${item.bathroomsCount} Salle(s) de bain'),
                      if (item.hasKitchen) _featureChip(Icons.kitchen, 'Cuisine'),
                      if (item.hasParking) _featureChip(Icons.local_parking, 'Parking'),
                      if (item.hasFence) _featureChip(Icons.fence, 'Clôture'),
                      if (item.hasWater) _featureChip(Icons.water_drop, 'Eau disponible'),
                      if (item.hasElectricity) _featureChip(Icons.bolt, 'Électricité'),
                      if (item.hasInternet) _featureChip(Icons.wifi, 'Internet / Wifi'),
                      if (item.hasGarden) _featureChip(Icons.park, 'Jardin'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Video Link Section (if available)
                  if (item.videoUrl != null && item.videoUrl!.isNotEmpty) ...[
                    const Text('Vidéo de présentation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.play_circle_fill, color: Colors.red, size: 36),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Regarder la vidéo du logement',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade900),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Ouverture de la vidéo: ${item.videoUrl}')),
                              );
                            },
                            child: const Text('Voir'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Description
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),

                  const SizedBox(height: 20),

                  // Owner / Agency Info Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              item.ownerName.isNotEmpty ? item.ownerName[0].toUpperCase() : 'P',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.ownerName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  item.isOwnerVerified ? 'Propriétaire vérifié 🔵' : 'Bailleur / Agent',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 80), // Padding for sticky bottom contact bar
                ],
              ),
            ),
          ],
        ),
      ),

      // Sticky Bottom Contact Bar (Call & WhatsApp)
      bottomSheet: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.phone),
                label: const Text('Appeler', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: () {
                  provider.incrementCalls(item.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Appel vers le ${item.ownerPhone}')),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.chat_bubble),
                label: const Text('WhatsApp', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: () {
                  provider.incrementWhatsApp(item.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ouvrir WhatsApp pour le ${item.ownerWhatsApp}')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.indigo),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.indigo.shade50,
    );
  }

  void _shareListing(BuildContext context, Listing item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Lien partagé: https://find.cd/property/${item.id}')),
    );
  }

  void _showReportDialog(BuildContext context, AppProvider provider, Listing item) {
    final reasonController = TextEditingController();
    final detailsController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Signaler cette annonce'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Motif du signalement',
                hintText: 'ex: Annonce frauduleuse, Prix incorrect...',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: detailsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Détails explicatifs',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                provider.submitReport(
                  listingId: item.id,
                  listingTitle: item.title,
                  reason: reasonController.text,
                  details: detailsController.text,
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signalement transmis aux administrateurs FIND.')),
                );
              }
            },
            child: const Text('Envoyer le signalement'),
          ),
        ],
      ),
    );
  }
}

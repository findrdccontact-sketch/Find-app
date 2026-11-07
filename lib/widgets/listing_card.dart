import 'package:flutter/material.dart';
import '../models/listing.dart';
import 'badge_widget.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const ListingCard({
    super.key,
    required this.listing,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: listing.photos.isNotEmpty
                      ? Image.network(
                          listing.photos.first,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                            color: Colors.blueGrey.shade100,
                            child: const Center(
                              child: Icon(Icons.home, size: 48, color: Colors.grey),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.blueGrey.shade100,
                          child: const Center(
                            child: Icon(Icons.home, size: 48, color: Colors.grey),
                          ),
                        ),
                ),
                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withAlpha(220),
                    child: IconButton(
                      tooltip: isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey.shade700,
                      ),
                      onPressed: onFavoriteToggle,
                    ),
                  ),
                ),
                // Badges overlay
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Wrap(
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: [
                      if (listing.isRented)
                        const ListingBadge(type: BadgeType.rented, compact: true)
                      else ...[
                        if (listing.isListingVerified)
                          const ListingBadge(type: BadgeType.listingVerified, compact: true),
                        if (listing.isOwnerVerified)
                          const ListingBadge(type: BadgeType.ownerVerified, compact: true),
                        if (listing.isNewListing)
                          const ListingBadge(type: BadgeType.newListing, compact: true),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${listing.rentPrice.toStringAsFixed(0)} / mois',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        listing.propertyType,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    listing.title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          '${listing.commune}, ${listing.city} (${listing.quartier})',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16.0),
                  // Specifications
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _specItem(Icons.king_bed, '${listing.bedroomsCount} chb'),
                      _specItem(Icons.weekend, '${listing.livingRoomsCount} salon'),
                      _specItem(Icons.bathtub, '${listing.bathroomsCount} sdb'),
                      if (listing.hasParking) _specItem(Icons.local_parking, 'Parking'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _specItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 4.0),
        Text(
          text,
          style: TextStyle(fontSize: 12.0, color: Colors.grey.shade800),
        ),
      ],
    );
  }
}

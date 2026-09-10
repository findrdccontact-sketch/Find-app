import 'package:flutter/material.dart';
import '../models/listing.dart';

class MapViewWidget extends StatefulWidget {
  final List<Listing> listings;
  final Function(Listing) onListingSelected;

  const MapViewWidget({
    super.key,
    required this.listings,
    required this.onListingSelected,
  });

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {
  Listing? _selectedListing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Simulated Interactive DRC Map canvas
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade50,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Stack(
              children: [
                // Map Background pattern
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MapGridPainter(),
                  ),
                ),
                // City labels
                const Positioned(
                  top: 20,
                  left: 20,
                  child: Chip(
                    avatar: Icon(Icons.location_city, size: 16),
                    label: Text('République Démocratique du Congo'),
                    backgroundColor: Colors.white70,
                  ),
                ),
                // Map Markers
                ...widget.listings.map((item) {
                  // Normalize coordinates for visual positioning inside container
                  final x = ((item.longitude - 15.0) * 15.0 + 80.0) % 280.0 + 20.0;
                  final y = ((item.latitude + 5.0) * -25.0 + 100.0) % 350.0 + 40.0;
                  final isSelected = _selectedListing?.id == item.id;

                  return Positioned(
                    left: x,
                    top: y,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedListing = item;
                        });
                        widget.onListingSelected(item);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.deepOrange : Colors.indigo,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                )
                              ],
                            ),
                            child: Text(
                              '\$${item.rentPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.location_on,
                            color: isSelected ? Colors.deepOrange : Colors.indigo,
                            size: isSelected ? 32 : 24,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        // Selected Listing Bar
        if (_selectedListing != null)
          Container(
            padding: const EdgeInsets.all(12.0),
            color: Colors.white,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade300,
                    child: _selectedListing!.photos.isNotEmpty
                        ? Image.network(_selectedListing!.photos.first, fit: BoxFit.cover)
                        : const Icon(Icons.home),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedListing!.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${_selectedListing!.commune}, ${_selectedListing!.city} • \$${_selectedListing!.rentPrice.toStringAsFixed(0)}/m',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => widget.onListingSelected(_selectedListing!),
                  child: const Text('Voir'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade100.withAlpha(100)
      ..strokeWidth = 1.0;

    const step = 30.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

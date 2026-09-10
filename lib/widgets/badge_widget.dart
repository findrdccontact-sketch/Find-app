import 'package:flutter/material.dart';

enum BadgeType {
  listingVerified, // 🟢 Annonce vérifiée
  ownerVerified, // 🔵 Propriétaire vérifié
  newListing, // 🟡 Nouveau logement
  rented, // 🔴 Déjà loué
}

class ListingBadge extends StatelessWidget {
  final BadgeType type;
  final bool compact;

  const ListingBadge({
    super.key,
    required this.type,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String label;

    switch (type) {
      case BadgeType.listingVerified:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
        icon = Icons.verified;
        label = 'Annonce vérifiée';
        break;
      case BadgeType.ownerVerified:
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade900;
        icon = Icons.verified_user;
        label = 'Propriétaire vérifié';
        break;
      case BadgeType.newListing:
        backgroundColor = Colors.amber.shade100;
        textColor = Colors.amber.shade900;
        icon = Icons.new_releases;
        label = 'Nouveau';
        break;
      case BadgeType.rented:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
        icon = Icons.do_not_disturb_on;
        label = 'Déjà loué';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6.0 : 8.0,
        vertical: compact ? 2.0 : 4.0,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: textColor.withAlpha(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: compact ? 12.0 : 14.0,
            color: textColor,
          ),
          const SizedBox(width: 4.0),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: compact ? 10.0 : 12.0,
            ),
          ),
        ],
      ),
    );
  }
}

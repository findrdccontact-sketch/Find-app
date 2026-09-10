import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/listing.dart';
import '../services/app_provider.dart';

class OwnerDashboardScreen extends StatelessWidget {
  final Function(Listing) onEditListing;

  const OwnerDashboardScreen({
    super.key,
    required this.onEditListing,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final listings = provider.userListings;

    int totalViews = 0;
    int totalFavorites = 0;
    int totalCalls = 0;
    int totalWhatsApp = 0;
    int totalContacts = 0;

    for (var l in listings) {
      totalViews += l.viewsCount;
      totalFavorites += l.favoritesCount;
      totalCalls += l.callsCount;
      totalWhatsApp += l.whatsappCount;
      totalContacts += l.contactsCount;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Owner Identity Verification Status Banner
          Card(
            color: provider.currentUser.isVerified ? Colors.blue.shade50 : Colors.amber.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(
                    provider.currentUser.isVerified ? Icons.verified_user : Icons.warning_amber_rounded,
                    color: provider.currentUser.isVerified ? Colors.blue.shade800 : Colors.amber.shade900,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.currentUser.isVerified
                              ? 'Propriétaire vérifié 🔵'
                              : 'Compte non vérifié',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          provider.currentUser.isVerified
                              ? 'Vos annonces bénéficient du badge de confiance.'
                              : 'Demandez la vérification pour obtenir le badge Propriétaire vérifié.',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (!provider.currentUser.isVerified)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                      onPressed: () {
                        provider.requestOwnerVerification();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Demande de vérification soumise avec succès !')),
                        );
                      },
                      child: const Text('Vérifier'),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Tableau de bord - Statistiques',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Statistics Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.1,
            children: [
              _statCard(context, '${listings.length}', 'Logements', Icons.home, Colors.blue),
              _statCard(context, '$totalViews', 'Vues', Icons.remove_red_eye, Colors.purple),
              _statCard(context, '$totalFavorites', 'Favoris', Icons.favorite, Colors.red),
              _statCard(context, '$totalContacts', 'Contacts', Icons.contact_mail, Colors.teal),
              _statCard(context, '$totalCalls', 'Appels', Icons.phone, Colors.green),
              _statCard(context, '$totalWhatsApp', 'WhatsApp', Icons.chat, const Color(0xFF25D366)),
            ],
          ),
          const SizedBox(height: 24),

          // Mes Logements Header
          const Text(
            'Mes Logements Publiés',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          listings.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('Vous n\'avez publié aucun logement pour l\'instant.'),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listings.length,
                  itemBuilder: (context, index) {
                    final item = listings[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: item.isRented ? Colors.red.shade100 : Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item.status.label,
                                    style: TextStyle(
                                      color: item.isRented ? Colors.red.shade900 : Colors.green.shade900,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('${item.commune}, ${item.city} • \$${item.rentPrice.toStringAsFixed(0)}/mois'),
                            const SizedBox(height: 8),

                            // Listing mini metrics bar
                            Row(
                              children: [
                                Text('👁 ${item.viewsCount} vues', style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 12),
                                Text('❤️ ${item.favoritesCount} favoris', style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 12),
                                Text('📞 ${item.callsCount} appels', style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 12),
                                Text('💬 ${item.whatsappCount} whatsapp', style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                            const Divider(height: 16),

                            // Action buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (!item.isRented)
                                  OutlinedButton.icon(
                                    icon: const Icon(Icons.check_circle, size: 16),
                                    label: const Text('Marquer Loué'),
                                    onPressed: () => provider.markAsRented(item.id),
                                  ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.pause, size: 16),
                                  label: Text(item.status == ListingStatus.suspended ? 'Réactiver' : 'Suspendre'),
                                  onPressed: () {
                                    if (item.status == ListingStatus.suspended) {
                                      provider.updateListing(item.copyWith(status: ListingStatus.available));
                                    } else {
                                      provider.suspendListing(item.id);
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => provider.deleteListing(item.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _statCard(BuildContext context, String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.black87), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

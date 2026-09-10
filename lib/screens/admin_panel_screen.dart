import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_user.dart';
import '../services/app_provider.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final listings = provider.latestListings;
    final reports = provider.reports;

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade100,
            child: const TabBar(
              labelColor: Colors.indigo,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.indigo,
              tabs: [
                Tab(icon: Icon(Icons.dashboard), text: 'Stats & Badges'),
                Tab(icon: Icon(Icons.report), text: 'Signalements'),
                Tab(icon: Icon(Icons.people), text: 'Utilisateurs'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Tab 1: Stats & Badge Moderation
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Statistiques Générales Platform', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _statTile('Listings', '${listings.length}', Colors.indigo),
                          const SizedBox(width: 8),
                          _statTile('Signalements', '${reports.length}', Colors.red),
                          const SizedBox(width: 8),
                          _statTile('Utilisateurs', '${provider.allUsers.length}', Colors.green),
                        ],
                      ),
                      const SizedBox(height: 24),

                      const Text('Modération des Badges & Annonces', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 12),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listings.length,
                        itemBuilder: (ctx, index) {
                          final item = listings[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                              subtitle: Text('${item.commune}, ${item.city} • ${item.ownerName}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FilterChip(
                                    label: const Text('🟢 Annonce'),
                                    selected: item.isListingVerified,
                                    onSelected: (val) {
                                      provider.setListingVerifiedBadge(item.id, val);
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                  FilterChip(
                                    label: const Text('🔵 Propriétaire'),
                                    selected: item.isOwnerVerified,
                                    onSelected: (val) {
                                      provider.setOwnerVerifiedBadge(item.id, val);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Tab 2: Fraud Reports Handling Queue
                reports.isEmpty
                    ? const Center(
                        child: Text('Aucun signalement de fraude en attente.'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: reports.length,
                        itemBuilder: (ctx, index) {
                          final rep = reports[index];
                          return Card(
                            color: Colors.red.shade50,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Annonce: ${rep.listingTitle}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Chip(
                                        label: Text(rep.status),
                                        backgroundColor: rep.status == 'pending' ? Colors.amber : Colors.green,
                                      ),
                                    ],
                                  ),
                                  Text('Motif: ${rep.reason}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                  Text('Détails: ${rep.details}'),
                                  Text('Signalé par: ${rep.reporterName}'),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                        onPressed: () {
                                          provider.deleteListing(rep.listingId);
                                          provider.resolveReport(rep.id, 'resolved');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Annonce frauduleuse supprimée.')),
                                          );
                                        },
                                        child: const Text('Supprimer L\'Annonce'),
                                      ),
                                      const SizedBox(width: 8),
                                      OutlinedButton(
                                        onPressed: () {
                                          provider.resolveReport(rep.id, 'dismissed');
                                        },
                                        child: const Text('Classer Sans Suite'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                // Tab 3: Users Management
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.allUsers.length,
                  itemBuilder: (ctx, index) {
                    final u = provider.allUsers[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(u.name.isNotEmpty ? u.name[0] : 'U'),
                        ),
                        title: Text(u.name),
                        subtitle: Text('${u.email} • ${u.role.label}'),
                        trailing: u.isVerified
                            ? const Icon(Icons.verified, color: Colors.blue)
                            : null,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

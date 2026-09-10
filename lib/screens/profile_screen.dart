import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_user.dart';
import '../models/listing.dart';
import '../services/app_provider.dart';
import '../widgets/listing_card.dart';
import 'admin_panel_screen.dart';
import 'agency_dashboard_screen.dart';
import 'owner_dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Function(Listing) onListingSelect;
  final VoidCallback onNavigateToPublish;

  const ProfileScreen({
    super.key,
    required this.onListingSelect,
    required this.onNavigateToPublish,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _whatsappController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AppProvider>(context, listen: false).currentUser;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
    _whatsappController = TextEditingController(text: user.whatsapp);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final user = provider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Espace FIND'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Role Switcher Top Header Card
          Container(
            color: Colors.indigo.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              children: [
                const Icon(Icons.swap_horiz, color: Colors.indigo),
                const SizedBox(width: 8),
                const Text(
                  'Mode Espace: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: DropdownButtonFormField<UserRole>(
                    initialValue: user.role,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    items: UserRole.values
                        .map((r) => DropdownMenuItem(value: r, child: Text(r.label)))
                        .toList(),
                    onChanged: (role) {
                      if (role != null) {
                        provider.switchUserRole(role);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // Main Space Content View based on User Role
          Expanded(
            child: _buildRoleSpace(context, provider, user),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSpace(BuildContext context, AppProvider provider, AppUser user) {
    switch (user.role) {
      case UserRole.visitor:
        return _buildVisitorSpace(context, provider);
      case UserRole.tenant:
        return _buildTenantSpace(context, provider, user);
      case UserRole.owner:
        return OwnerDashboardScreen(
          onEditListing: (l) {},
        );
      case UserRole.agency:
        return const AgencyDashboardScreen();
      case UserRole.admin:
        return const AdminPanelScreen();
    }
  }

  Widget _buildVisitorSpace(BuildContext context, AppProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Icon(Icons.account_circle, size: 80, color: Colors.indigo),
          const SizedBox(height: 16),
          const Text(
            'Bienvenue sur FIND',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'En tant que visiteur, vous pouvez consulter les annonces, filtrer les résultats et contacter directement les propriétaires par téléphone ou WhatsApp.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.login),
            label: const Text('Se connecter / Créer un compte'),
            onPressed: () {
              provider.switchUserRole(UserRole.tenant);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compte Locataire créé et connecté !')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTenantSpace(BuildContext context, AppProvider provider, AppUser user) {
    final favorites = provider.favoriteListings;

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
                Tab(icon: Icon(Icons.favorite), text: 'Favoris'),
                Tab(icon: Icon(Icons.history), text: 'Historique'),
                Tab(icon: Icon(Icons.person), text: 'Profil'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Tab 1: Favorites
                favorites.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                            SizedBox(height: 12),
                            Text('Aucun logement en favoris.'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: favorites.length,
                        itemBuilder: (ctx, index) {
                          final item = favorites[index];
                          return ListingCard(
                            listing: item,
                            isFavorite: true,
                            onTap: () => widget.onListingSelect(item),
                            onFavoriteToggle: () => provider.toggleFavorite(item.id),
                          );
                        },
                      ),

                // Tab 2: Search History
                provider.searchHistory.isEmpty
                    ? const Center(child: Text('Aucun historique de recherche.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.searchHistory.length,
                        itemBuilder: (ctx, index) {
                          final query = provider.searchHistory[index];
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.search, color: Colors.indigo),
                              title: Text(query),
                              trailing: IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                                onPressed: () {
                                  provider.setSearchQuery(query);
                                },
                              ),
                            ),
                          );
                        },
                      ),

                // Tab 3: Tenant Profile Info Edit Form
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Informations Personnelles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nom complet', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Adresse e-mail', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _whatsappController,
                        decoration: const InputDecoration(labelText: 'Numéro WhatsApp', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        ),
                        onPressed: () {
                          provider.updateUserProfile(
                            name: _nameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            whatsapp: _whatsappController.text,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profil mis à jour !')),
                          );
                        },
                        child: const Text('Enregistrer les modifications'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

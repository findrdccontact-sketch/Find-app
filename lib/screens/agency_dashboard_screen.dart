import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';

class AgencyDashboardScreen extends StatelessWidget {
  const AgencyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final user = provider.currentUser;
    final agentNameController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Agency Profile Card
          Card(
            color: Colors.indigo.shade900,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.business, color: Colors.white, size: 36),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.agencyName ?? user.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Compte Agence Immobilière Professionnelle',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Chip(
                        label: Text(
                          user.subscriptionPlan,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                        ),
                        backgroundColor: Colors.amber,
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nombre d\'agents: ${user.agencyAgents.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      if (user.subscriptionPlan != 'Premium')
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            provider.upgradeAgencyPlan('Premium');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Souscription Premium activée avec succès !')),
                            );
                          },
                          child: const Text('Souscrire Offre Premium'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Premium Offer Features Banner
          Card(
            color: Colors.amber.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🌟 Offre Premium Agence FIND',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber),
                  ),
                  SizedBox(height: 4),
                  Text('• Publication de logements illimitée'),
                  Text('• Badge "Agence Vérifiée" en tête des recherches'),
                  Text('• Multi-agents jusqu\'à 20 comptes secondaires'),
                  Text('• Statistiques avancées et export de données'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Agents Management
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gestion des Agents',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('Ajouter Agent'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Ajouter un agent immobilier'),
                      content: TextField(
                        controller: agentNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom et Prénom de l\'agent',
                          hintText: 'ex: Patrick Mbala',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Annuler'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (agentNameController.text.isNotEmpty) {
                              provider.addAgencyAgent(agentNameController.text);
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Agent ajouté avec succès !')),
                              );
                            }
                          },
                          child: const Text('Ajouter'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          user.agencyAgents.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('Aucun agent enregistré pour le moment.'),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: user.agencyAgents.length,
                  itemBuilder: (context, index) {
                    final agent = user.agencyAgents[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(agent),
                        subtitle: const Text('Agent Immobilier Référencé'),
                        trailing: const Icon(Icons.verified, color: Colors.blue),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

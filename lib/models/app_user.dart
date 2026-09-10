enum UserRole {
  visitor,
  tenant,
  owner,
  agency,
  admin,
}

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.visitor:
        return 'Visiteur';
      case UserRole.tenant:
        return 'Locataire';
      case UserRole.owner:
        return 'Propriétaire';
      case UserRole.agency:
        return 'Agence immobilière';
      case UserRole.admin:
        return 'Administrateur';
    }
  }
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String whatsapp;
  final UserRole role;
  final bool isVerified; // Propriétaire vérifié badge eligibility
  final String? agencyName;
  final List<String> agencyAgents;
  final String subscriptionPlan; // 'Gratuit', 'Premium', etc.

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.whatsapp,
    required this.role,
    this.isVerified = false,
    this.agencyName,
    this.agencyAgents = const [],
    this.subscriptionPlan = 'Gratuit',
  });

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? whatsapp,
    UserRole? role,
    bool? isVerified,
    String? agencyName,
    List<String>? agencyAgents,
    String? subscriptionPlan,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      whatsapp: whatsapp ?? this.whatsapp,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      agencyName: agencyName ?? this.agencyName,
      agencyAgents: agencyAgents ?? this.agencyAgents,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
    );
  }
}

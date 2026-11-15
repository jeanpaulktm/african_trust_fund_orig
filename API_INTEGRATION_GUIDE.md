/// DOCUMENTATION DE L'INTÉGRATION API - AFRICAN TRUST FUND
/// Version: 1.0
/// Date: 14 Novembre 2026
/// 
/// ============================================================================
/// 📋 STRUCTURE DE L'IMPLÉMENTATION API COMPLÈTE
/// ============================================================================
/// 
/// Cette implémentation couvre les 5 PARTS de la documentation API:
///
/// ✅ PART 1 - AUTHENTIFICATION & DASHBOARD
///    - Files implémentés:
///      • lib/core/api/api_config.dart
///      • lib/core/api/api_service.dart
///      • lib/features/auth/data/models/auth_models.dart
///      • lib/features/auth/data/repositories/auth_repository.dart
///      • lib/features/auth/presentation/providers/auth_provider.dart
///      • lib/features/dashboard/data/models/dashboard_models.dart
///      • lib/features/dashboard/data/repositories/dashboard_repository.dart
///      • lib/features/dashboard/presentation/providers/dashboard_provider.dart
///
/// ✅ PART 2 - GESTION DES PRÊTS
///    - Files implémentés:
///      • lib/features/credit/data/models/loan_models.dart
///      • lib/features/credit/data/repositories/loan_repository.dart
///
/// 📝 PART 3 - TRANSACTIONS FINANCIÈRES (À venir)
/// 📝 PART 4 - PLACEMENTS & ÉPARGNE (À venir)
/// 📝 PART 5 - PROFIL, DOCUMENTS & AUTRES (À venir)
///
/// ============================================================================
/// 🔧 UTILISATION DES PROVIDERS RIVERPOD
/// ============================================================================
///
/// Pour utiliser les services API dans vos widgets:
///
/// 1. AUTHENTIFICATION:
///    ----
///    final authState = ref.watch(authProvider);
///    final isAuthenticated = ref.watch(isAuthenticatedProvider);
///    final currentUser = ref.watch(currentUserProvider);
///    
///    // Connexion
///    ref.read(authProvider.notifier).login(
///      email: 'user@example.com',
///      password: 'password123',
///    );
///    
///    // Déconnexion
///    ref.read(authProvider.notifier).logout();
///
/// 2. DASHBOARD:
///    ----
///    final dashboardState = ref.watch(dashboardProvider);
///    
///    // Charger les données
///    ref.read(dashboardProvider.notifier).fetchDashboard();
///    
///    // Rafraîchir
///    ref.read(dashboardProvider.notifier).refreshDashboard();
///
/// 3. PRÊTS:
///    ----
///    final loanRepository = ref.watch(loanRepositoryProvider);
///    
///    // Liste prêts
///    final loans = await loanRepository.getLoans();
///    
///    // Détails prêt
///    final loan = await loanRepository.getLoanDetails(loanId);
///    
///    // Simuler un prêt
///    final simulation = await loanRepository.simulateLoan(
///      amount: 1000000,
///      currency: 'CDF',
///      loanType: 'classique',
///      termMonths: 24,
///    );
///    
///    // Demander un prêt
///    final response = await loanRepository.requestLoan(
///      amount: 1000000,
///      currency: 'CDF',
///      loanType: 'classique',
///      termMonths: 24,
///      purpose: 'Besoin professionnel',
///    );
///    
///    // Effectuer un remboursement
///    await loanRepository.repayLoan(
///      loanId: 'loan-123',
///      amount: 45833,
///    );
///
/// ============================================================================
/// 🔐 GESTION DE L'AUTHENTIFICATION
/// ============================================================================
///
/// Le système gère automatiquement:
///   • Stockage sécurisé du token (FlutterSecureStorage)
///   • Ajout du Bearer token à chaque requête
///   • Renouvellement du token si expiré
///   • Gestion des erreurs 401 (token invalide)
///
/// Flow d'authentification:
/// 1. User → login() → Token stocké en sécurisé
/// 2. Chaque requête → Token ajouté automatiquement
/// 3. Token expire (24h) → refresh() automatiquement
/// 4. Logout → Token supprimé
///
/// ============================================================================
/// 📊 MODÈLES DE DONNÉES
/// ============================================================================
///
/// Les modèles sont générés avec `json_serializable` pour une
/// sérialisation/désérialisation automatique:
///
/// flutter pub run build_runner build --delete-conflicting-outputs
///
/// Modèles implémentés:
/// - AuthData, UserData, ProfileData (Authentification)
/// - DashboardData, Balances, LoanStats (Dashboard)
/// - LoanDetail, ScheduleItem, RepaymentHistory (Prêts)
/// - Pagination (Utilitaire)
///
/// ============================================================================
/// 🌐 ENDPOINTS IMPLÉMENTÉS
/// ============================================================================
///
/// PART 1 - AUTHENTIFICATION & DASHBOARD
/// ----
/// POST   /api/v1/auth/login              ✅ Connexion
/// POST   /api/v1/auth/register           ✅ Enregistrement
/// POST   /api/v1/auth/refresh            ✅ Renouveler token
/// POST   /api/v1/auth/logout             ✅ Déconnexion
/// GET    /api/v1/auth/profile            ✅ Récupérer profil
/// GET    /api/v1/dashboard               ✅ Dashboard complet
///
/// PART 2 - GESTION DES PRÊTS
/// ----
/// GET    /api/v1/prets                   ✅ Liste prêts
/// GET    /api/v1/prets/{id}              ✅ Détails prêt
/// POST   /api/v1/prets/demand            ✅ Demander prêt
/// POST   /api/v1/prets/{id}/repay        ✅ Rembourser prêt
/// POST   /api/v1/prets/simuler           ✅ Simuler prêt
///
/// PART 3 - TRANSACTIONS
/// ----
/// GET    /api/v1/transactions            📝 Liste transactions
/// POST   /api/v1/transactions/deposit    📝 Créer dépôt
/// POST   /api/v1/transactions/withdrawal 📝 Créer retrait
/// POST   /api/v1/transactions/transfer   📝 Virement
///
/// PART 4 - PLACEMENTS
/// ----
/// GET    /api/v1/placements              📝 Liste placements
/// POST   /api/v1/placements              📝 Créer placement
/// POST   /api/v1/placements/{id}/withdraw 📝 Retirer placement
/// POST   /api/v1/placements/simuler      📝 Simuler placement
///
/// PART 5 - PROFIL & DOCUMENTS
/// ----
/// GET    /api/v1/profil                  📝 Récupérer profil
/// PUT    /api/v1/profil                  📝 Modifier profil
/// POST   /api/v1/profil/avatar           📝 Upload avatar
/// GET    /api/v1/profil/documents        📝 Liste documents
/// POST   /api/v1/profil/documents        📝 Upload document
///
/// ============================================================================
/// 📦 PROCHAINES ÉTAPES
/// ============================================================================
///
/// 1. Générer les fichiers .g.dart:
///    flutter pub run build_runner build --delete-conflicting-outputs
///
/// 2. Implémenter PART 3 - Transactions:
///    • transaction_models.dart
///    • transaction_repository.dart
///    • transaction_provider.dart
///
/// 3. Implémenter PART 4 - Placements:
///    • placement_models.dart
///    • placement_repository.dart
///    • placement_provider.dart
///
/// 4. Implémenter PART 5 - Profil:
///    • profile_models.dart
///    • profile_repository.dart
///    • profile_provider.dart
///
/// 5. Tester chaque endpoint avec Postman
///
/// 6. Intégrer à la UI Flutter
///
/// ============================================================================
/// 🧪 EXEMPLE D'INTÉGRATION DANS UN WIDGET
/// ============================================================================
///
/// import 'package:flutter/material.dart';
/// import 'package:flutter_riverpod/flutter_riverpod.dart';
/// import 'package:african/features/auth/presentation/providers/auth_provider.dart';
/// import 'package:african/features/dashboard/presentation/providers/dashboard_provider.dart';
///
/// class HomeScreen extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final authState = ref.watch(authProvider);
///     final dashboardState = ref.watch(dashboardProvider);
///
///     return Scaffold(
///       appBar: AppBar(title: Text('Bienvenue ${authState.user?.firstName}')),
///       body: dashboardState.isLoading
///           ? Center(child: CircularProgressIndicator())
///           : dashboardState.error != null
///             ? Center(child: Text('Erreur: ${dashboardState.error}'))
///             : ListView(
///                 children: [
///                   Card(
///                     child: ListTile(
///                       title: Text('Solde CDF'),
///                       subtitle: Text(
///                         '${dashboardState.data?.balances.cdf} CDF',
///                       ),
///                     ),
///                   ),
///                   Card(
///                     child: ListTile(
///                       title: Text('Prêts actifs'),
///                       subtitle: Text(
///                         '${dashboardState.data?.loanStats.activeLoans}',
///                       ),
///                     ),
///                   ),
///                 ],
///               ),
///       floatingActionButton: FloatingActionButton(
///         onPressed: () {
///           ref.read(dashboardProvider.notifier).refreshDashboard();
///         },
///         child: Icon(Icons.refresh),
///       ),
///     );
///   }
/// }
///
/// ============================================================================
/// ⚠️ NOTES IMPORTANTES
/// ============================================================================
///
/// 1. Configuration du Backend:
///    - URL de base: https://api.africantrust.cd
///    - À adapter dans: lib/core/api/api_config.dart
///    - Changer le baseUrl selon votre environnement (dev, staging, prod)
///
/// 2. Sécurité:
///    - Les tokens sont stockés dans FlutterSecureStorage
///    - Jamais stocker les mots de passe
///    - Utiliser HTTPS en production
///
/// 3. Génération des modèles:
///    Après chaque modification des modèles .dart:
///    flutter pub run build_runner build --delete-conflicting-outputs
///
/// 4. Gestion d'erreurs:
///    Tous les appels API lancent ApiException en cas d'erreur
///    Toujours utiliser try-catch ou écouter les erreurs dans les providers
///
/// 5. Pagination:
///    Tous les endpoints de liste supportent:
///    - page: Numéro de page (default: 1)
///    - per_page: Résultats par page (default: 10, max: 50)
///    - sort: Tri (date_desc, montant_asc, etc.)
///    - filter: Filtres optionnels
///
/// ============================================================================

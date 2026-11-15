/// ============================================================================
/// 📱 GUIDE D'INTÉGRATION UI - AFRICAN TRUST FUND
/// ============================================================================
/// 
/// Ce guide montre comment intégrer les providers API dans la UI Flutter existante
///
/// ============================================================================
/// 1. CONVERTIR main.dart EN RIVERPOD
/// ============================================================================
///
/// Changez:
/// 
/// import 'package:flutter/material.dart';
/// 
/// à:
/// 
/// import 'package:flutter/material.dart';
/// import 'package:flutter_riverpod/flutter_riverpod.dart';
/// 
/// Et enveloppez le root:
/// 
/// void main() {
///   runApp(const ProviderScope(child: AfricanTrustFundApp()));
/// }
///
/// ============================================================================
/// 2. UTILISER LES PROVIDERS DANS LES SCREENS
/// ============================================================================
///
/// EXEMPLE 1: Dashboard avec le vrai API
/// ----
///
/// import 'package:flutter/material.dart';
/// import 'package:flutter_riverpod/flutter_riverpod.dart';
/// import 'package:african/features/dashboard/presentation/providers/dashboard_provider.dart';
/// 
/// class DashboardPage extends ConsumerStatefulWidget {
///   const DashboardPage({...});
/// 
///   @override
///   ConsumerState<DashboardPage> createState() => _DashboardPageState();
/// }
/// 
/// class _DashboardPageState extends ConsumerState<DashboardPage> {
///   @override
///   void initState() {
///     super.initState();
///     // Charger les données du dashboard au démarrage
///     Future.microtask(
///       () => ref.read(dashboardProvider.notifier).fetchDashboard(),
///     );
///   }
/// 
///   @override
///   Widget build(BuildContext context) {
///     final dashboardState = ref.watch(dashboardProvider);
/// 
///     return Scaffold(
///       appBar: AppBar(title: const Text('Tableau de bord')),
///       body: dashboardState.isLoading
///           ? const Center(child: CircularProgressIndicator())
///           : dashboardState.error != null
///             ? Center(
///                 child: Column(
///                   mainAxisAlignment: MainAxisAlignment.center,
///                   children: [
///                     Text('Erreur: ${dashboardState.error}'),
///                     const SizedBox(height: 16),
///                     ElevatedButton(
///                       onPressed: () => ref
///                           .read(dashboardProvider.notifier)
///                           .refreshDashboard(),
///                       child: const Text('Réessayer'),
///                     ),
///                   ],
///                 ),
///               )
///             : RefreshIndicator(
///                 onRefresh: () => ref
///                     .read(dashboardProvider.notifier)
///                     .refreshDashboard(),
///                 child: ListView(
///                   padding: const EdgeInsets.all(16),
///                   children: [
///                     // Soldes
///                     Card(
///                       child: Padding(
///                         padding: const EdgeInsets.all(16),
///                         child: Column(
///                           crossAxisAlignment: CrossAxisAlignment.start,
///                           children: [
///                             const Text(
///                               'Soldes',
///                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
///                             ),
///                             const SizedBox(height: 12),
///                             Row(
///                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
///                               children: [
///                                 Column(
///                                   crossAxisAlignment: CrossAxisAlignment.start,
///                                   children: [
///                                     const Text('CDF'),
///                                     Text(
///                                       '${dashboardState.data?.balances.cdf.toStringAsFixed(0)} CDF',
///                                       style: const TextStyle(
///                                         fontSize: 16,
///                                         fontWeight: FontWeight.bold,
///                                       ),
///                                     ),
///                                   ],
///                                 ),
///                                 Column(
///                                   crossAxisAlignment: CrossAxisAlignment.start,
///                                   children: [
///                                     const Text('USD'),
///                                     Text(
///                                       '\$${dashboardState.data?.balances.usd.toStringAsFixed(2)}',
///                                       style: const TextStyle(
///                                         fontSize: 16,
///                                         fontWeight: FontWeight.bold,
///                                       ),
///                                     ),
///                                   ],
///                                 ),
///                               ],
///                             ),
///                           ],
///                         ),
///                       ),
///                     ),
///                     const SizedBox(height: 16),
///                     // Statistiques prêts
///                     Card(
///                       child: Padding(
///                         padding: const EdgeInsets.all(16),
///                         child: Column(
///                           crossAxisAlignment: CrossAxisAlignment.start,
///                           children: [
///                             const Text(
///                               'Prêts',
///                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
///                             ),
///                             const SizedBox(height: 12),
///                             Row(
///                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
///                               children: [
///                                 _StatCard(
///                                   label: 'Actifs',
///                                   value: '${dashboardState.data?.loanStats.activeLoans}',
///                                 ),
///                                 _StatCard(
///                                   label: 'Complétés',
///                                   value: '${dashboardState.data?.loanStats.completedLoans}',
///                                 ),
///                                 _StatCard(
///                                   label: 'En retard',
///                                   value: '${dashboardState.data?.loanStats.overdueLoans}',
///                                   color: Colors.red,
///                                 ),
///                               ],
///                             ),
///                           ],
///                         ),
///                       ),
///                     ),
///                   ],
///                 ),
///               ),
///       floatingActionButton: FloatingActionButton(
///         onPressed: () =>
///             ref.read(dashboardProvider.notifier).refreshDashboard(),
///         child: const Icon(Icons.refresh),
///       ),
///     );
///   }
/// }
/// 
/// class _StatCard extends StatelessWidget {
///   final String label;
///   final String value;
///   final Color? color;
/// 
///   const _StatCard({
///     required this.label,
///     required this.value,
///     this.color,
///   });
/// 
///   @override
///   Widget build(BuildContext context) {
///     return Column(
///       children: [
///         Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
///         const SizedBox(height: 8),
///         Text(
///           value,
///           style: TextStyle(
///             fontSize: 20,
///             fontWeight: FontWeight.bold,
///             color: color,
///           ),
///         ),
///       ],
///     );
///   }
/// }
///
/// ============================================================================
/// EXEMPLE 2: Page des Prêts avec Provider
/// ============================================================================
///
/// import 'package:flutter/material.dart';
/// import 'package:flutter_riverpod/flutter_riverpod.dart';
/// import 'package:african/features/credit/data/repositories/loan_repository.dart';
/// 
/// final loanRepositoryProvider = Provider<LoanRepository>((ref) {
///   final apiService = ref.watch(apiServiceProvider);
///   return LoanRepository(apiService: apiService);
/// });
/// 
/// class CreditPage extends ConsumerStatefulWidget {
///   const CreditPage({...});
/// 
///   @override
///   ConsumerState<CreditPage> createState() => _CreditPageState();
/// }
/// 
/// class _CreditPageState extends ConsumerState<CreditPage> {
///   late PageController _pageController;
///   int _currentPage = 0;
/// 
///   @override
///   void initState() {
///     super.initState();
///     _pageController = PageController();
///   }
/// 
///   @override
///   void dispose() {
///     _pageController.dispose();
///     super.dispose();
///   }
/// 
///   @override
///   Widget build(BuildContext context) {
///     return DefaultTabController(
///       length: 3,
///       child: Scaffold(
///         appBar: AppBar(
///           title: const Text('Crédits'),
///           bottom: const TabBar(
///             tabs: [
///               Tab(text: 'Mes Crédits'),
///               Tab(text: 'Simulateur'),
///               Tab(text: 'Nouvelle Demande'),
///             ],
///           ),
///         ),
///         body: TabBarView(
///           children: [
///             _MyLoansTab(),
///             _LoanSimulatorTab(),
///             _NewLoanRequestTab(),
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// 
/// class _MyLoansTab extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     return FutureBuilder(
///       future: ref.read(loanRepositoryProvider).getLoans(),
///       builder: (context, snapshot) {
///         if (snapshot.connectionState == ConnectionState.waiting) {
///           return const Center(child: CircularProgressIndicator());
///         }
/// 
///         if (snapshot.hasError) {
///           return Center(child: Text('Erreur: ${snapshot.error}'));
///         }
/// 
///         final response = snapshot.data!;
///         if (!response.success || response.data.isEmpty) {
///           return const Center(child: Text('Aucun prêt'));
///         }
/// 
///         return ListView.builder(
///           itemCount: response.data.length,
///           itemBuilder: (context, index) {
///             final loan = response.data[index];
///             return Card(
///               margin: const EdgeInsets.all(8),
///               child: ListTile(
///                 title: Text(loan.reference),
///                 subtitle: Text('Montant: ${loan.amountApproved} ${loan.currency}'),
///                 trailing: Chip(label: Text(loan.status)),
///                 onTap: () {
///                   Navigator.of(context).push<void>(
///                     MaterialPageRoute(
///                       builder: (context) => LoanDetailPage(loanId: loan.id),
///                     ),
///                   );
///                 },
///               ),
///             );
///           },
///         );
///       },
///     );
///   }
/// }
/// 
/// class _LoanSimulatorTab extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     // TODO: Implémenter le simulateur de prêt
///     return const Center(child: Text('Simulateur de prêt'));
///   }
/// }
/// 
/// class _NewLoanRequestTab extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     // TODO: Implémenter le formulaire de demande de prêt
///     return const Center(child: Text('Nouvelle demande'));
///   }
/// }
///
/// ============================================================================
/// EXEMPLE 3: Authentification avec Provider
/// ============================================================================
///
/// class AuthPage extends ConsumerStatefulWidget {
///   const AuthPage({...});
/// 
///   @override
///   ConsumerState<AuthPage> createState() => _AuthPageState();
/// }
/// 
/// class _AuthPageState extends ConsumerState<AuthPage> {
///   late TextEditingController _emailController;
///   late TextEditingController _passwordController;
/// 
///   @override
///   void initState() {
///     super.initState();
///     _emailController = TextEditingController();
///     _passwordController = TextEditingController();
///   }
/// 
///   @override
///   void dispose() {
///     _emailController.dispose();
///     _passwordController.dispose();
///     super.dispose();
///   }
/// 
///   @override
///   Widget build(BuildContext context) {
///     final authState = ref.watch(authProvider);
/// 
///     return Scaffold(
///       appBar: AppBar(title: const Text('Connexion')),
///       body: Padding(
///         padding: const EdgeInsets.all(16),
///         child: Column(
///           mainAxisAlignment: MainAxisAlignment.center,
///           children: [
///             TextField(
///               controller: _emailController,
///               decoration: const InputDecoration(labelText: 'Email'),
///             ),
///             const SizedBox(height: 12),
///             TextField(
///               controller: _passwordController,
///               decoration: const InputDecoration(labelText: 'Mot de passe'),
///               obscureText: true,
///             ),
///             const SizedBox(height: 24),
///             ElevatedButton(
///               onPressed: authState.isLoading
///                   ? null
///                   : () {
///                       ref.read(authProvider.notifier).login(
///                             email: _emailController.text,
///                             password: _passwordController.text,
///                           );
///                     },
///               child: authState.isLoading
///                   ? const SizedBox(
///                       width: 20,
///                       height: 20,
///                       child: CircularProgressIndicator(strokeWidth: 2),
///                     )
///                   : const Text('Se connecter'),
///             ),
///             if (authState.error != null)
///               Padding(
///                 padding: const EdgeInsets.only(top: 16),
///                 child: Text(
///                   'Erreur: ${authState.error}',
///                   style: const TextStyle(color: Colors.red),
///                 ),
///               ),
///           ],
///         ),
///       ),
///     );
///   }
/// }
///
/// ============================================================================
/// 📌 BONNES PRATIQUES
/// ============================================================================
///
/// 1. Toujours utiliser ConsumerWidget ou ConsumerStatefulWidget
/// 2. Charger les données dans initState() avec Future.microtask()
/// 3. Utiliser ref.watch() pour écouter les changements
/// 4. Utiliser ref.read() pour déclencher des actions
/// 5. Gérer les états: loading, error, success
/// 6. Afficher un CircularProgressIndicator pendant le chargement
/// 7. Afficher les erreurs à l'utilisateur de manière claire
/// 8. Utiliser RefreshIndicator pour permettre le rafraîchissement
/// 9. Optimiser avec des Selectors quand approprié
/// 10. Tester chaque fonctionnalité avant de déployer
///
/// ============================================================================
/// 🚀 DÉPLOIEMENT
/// ============================================================================
///
/// Avant de déployer en production:
///
/// 1. Changer l'URL de base:
///    lib/core/api/api_config.dart
///    static const String baseUrl = 'https://api.africantrust.cd';
/// 
/// 2. Tester tous les endpoints avec Postman
/// 
/// 3. Activer HTTPS obligatoire
/// 
/// 4. Configurer les headers de sécurité
/// 
/// 5. Vérifier les permissions (Android/iOS)
/// 
/// 6. Générer les certificats SSL
/// 
/// 7. Tester sur des vrais appareils
/// 
/// 8. Monitorrer les logs en production
///
/// ============================================================================

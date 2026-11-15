/// ============================================================================
/// 🚀 QUICK START - EXEMPLES RAPIDES D'UTILISATION
/// ============================================================================
///
/// Ce fichier contient des snippets rapides pour intégrer l'API dans votre app
///
/// ============================================================================
/// 1️⃣ INITIALISER L'APP AVEC RIVERPOD
/// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Wrapper avec ProviderScope pour activer Riverpod
  runApp(
    const ProviderScope(
      child: AfricanTrustFundApp(),
    ),
  );
}

/// ============================================================================
/// 2️⃣ LOGIN - EXEMPLE COMPLET
/// ============================================================================

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'client@africantrust.cd',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: authState.isLoading
                    ? null
                    : () async {
                        await ref.read(authProvider.notifier).login(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        
                        if (mounted && !authState.isLoading) {
                          if (authState.isAuthenticated) {
                            Navigator.of(context).pushReplacementNamed('/home');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(authState.error ?? '')),
                            );
                          }
                        }
                      },
                child: authState.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Se connecter'),
              ),
            ),
            if (authState.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Erreur: ${authState.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// 3️⃣ DASHBOARD - AFFICHER LES SOLDES
/// ============================================================================

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les données du dashboard au démarrage
    Future.microtask(
      () => ref.read(dashboardProvider.notifier).fetchDashboard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(dashboardProvider.notifier).refreshDashboard(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: dashboardState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardState.error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Erreur: ${dashboardState.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(dashboardProvider.notifier)
                          .refreshDashboard(),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () => ref
                    .read(dashboardProvider.notifier)
                    .refreshDashboard(),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Soldes
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Soldes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text('CDF'),
                                    Text(
                                      '${dashboardState.data?.balances.cdf.toStringAsFixed(0)} CDF',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text('USD'),
                                    Text(
                                      '\$${dashboardState.data?.balances.usd.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Prêts actifs
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Prêts',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Prêts actifs: ${dashboardState.data?.loanStats.activeLoans}',
                            ),
                            Text(
                              'Montant total dû: ${dashboardState.data?.loanStats.totalOutstanding} CDF',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

/// ============================================================================
/// 4️⃣ LISTE DES PRÊTS
/// ============================================================================

class LoansScreen extends ConsumerWidget {
  const LoansScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(loanRepositoryProvider).getLoans(page: 1),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        final response = snapshot.data!;
        if (!response.success || response.data.isEmpty) {
          return const Center(child: Text('Aucun prêt'));
        }

        return ListView.builder(
          itemCount: response.data.length,
          itemBuilder: (context, index) {
            final loan = response.data[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(loan.reference),
                subtitle: Text(
                  '${loan.amountApproved} ${loan.currency} - ${loan.status}',
                ),
                trailing: CircleAvatar(
                  child: Text(loan.interestRate.toStringAsFixed(1)),
                ),
                onTap: () {
                  // Aller à la page de détails
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (context) => LoanDetailScreen(loanId: loan.id),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

/// ============================================================================
/// 5️⃣ SIMULATEUR DE PRÊT
/// ============================================================================

class LoanSimulatorScreen extends ConsumerStatefulWidget {
  const LoanSimulatorScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoanSimulatorScreen> createState() =>
      _LoanSimulatorScreenState();
}

class _LoanSimulatorScreenState extends ConsumerState<LoanSimulatorScreen> {
  late TextEditingController _amountController;
  late TextEditingController _monthsController;
  String _selectedCurrency = 'CDF';
  String _selectedLoanType = 'classique';
  Map<String, dynamic>? _simulationResult;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _monthsController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  void _simulate() async {
    try {
      final result = await ref.read(loanRepositoryProvider).simulateLoan(
        amount: double.parse(_amountController.text),
        currency: _selectedCurrency,
        loanType: _selectedLoanType,
        termMonths: int.parse(_monthsController.text),
      );

      if (result.success) {
        setState(() {
          _simulationResult = {
            'monthlyPayment': result.data.monthlyPayment,
            'totalInterest': result.data.totalInterest,
            'totalToRepay': result.data.totalToRepay,
          };
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Simulation effectuée')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulateur de prêt')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Montant (CDF)',
                hintText: '1000000',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _monthsController,
              decoration: const InputDecoration(
                labelText: 'Durée (mois)',
                hintText: '24',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedLoanType,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedLoanType = value);
                }
              },
              items: const [
                DropdownMenuItem(value: 'classique', child: Text('Classique')),
                DropdownMenuItem(value: 'pme', child: Text('PME')),
                DropdownMenuItem(value: 'personnel', child: Text('Personnel')),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _simulate,
              child: const Text('Simuler'),
            ),
            if (_simulationResult != null) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Résultats',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Mensualité: ${_simulationResult!['monthlyPayment'].toStringAsFixed(0)} CDF',
                      ),
                      Text(
                        'Intérêts totaux: ${_simulationResult!['totalInterest'].toStringAsFixed(0)} CDF',
                      ),
                      Text(
                        'Total à rembourser: ${_simulationResult!['totalToRepay'].toStringAsFixed(0)} CDF',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// ============================================================================
/// 6️⃣ VÉRIFIER L'AUTHENTIFICATION
/// ============================================================================

// Dans votre navigation principale:

class RootPage extends ConsumerWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return Scaffold(
      body: isAuthenticated
          ? const DashboardScreen()
          : const LoginScreen(),
    );
  }
}

/// ============================================================================
/// 7️⃣ LOGOUT
/// ============================================================================

ElevatedButton(
  onPressed: () async {
    await ref.read(authProvider.notifier).logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  },
  child: const Text('Se déconnecter'),
)

/// ============================================================================
/// 8️⃣ GESTION DES ERREURS API
/// ============================================================================

try {
  final response = await ref.read(loanRepositoryProvider).getLoans();
  // Utiliser la réponse
} on ApiException catch (e) {
  // Erreur API
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Erreur API: ${e.message}'),
      backgroundColor: Colors.red,
    ),
  );
} catch (e) {
  // Erreur générale
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Erreur: $e'),
      backgroundColor: Colors.red,
    ),
  );
}

/// ============================================================================
/// 9️⃣ FORMATS ET CONSTANTES
/// ============================================================================

// Devises
const String CDF = 'CDF';
const String USD = 'USD';

// Types de prêts
const String LOAN_TYPE_CLASSIC = 'classique';
const String LOAN_TYPE_PME = 'pme';
const String LOAN_TYPE_PERSONAL = 'personnel';

// Statuts prêts
const String LOAN_STATUS_SUBMITTED = 'soumis';
const String LOAN_STATUS_IN_ANALYSIS = 'en_analyse';
const String LOAN_STATUS_APPROVED = 'approuve';
const String LOAN_STATUS_DISBURSED = 'decaisse';
const String LOAN_STATUS_IN_REPAYMENT = 'en_cours';
const String LOAN_STATUS_OVERDUE = 'en_retard';
const String LOAN_STATUS_CLOSED = 'solde';
const String LOAN_STATUS_REJECTED = 'rejete';

/// ============================================================================
/// 🔟 PAGINATION
/// ============================================================================

// Charger la page 1
final page1 = await ref.read(loanRepositoryProvider).getLoans(
  page: 1,
  perPage: 10,
);

// Charger la page 2
final page2 = await ref.read(loanRepositoryProvider).getLoans(
  page: 2,
  perPage: 10,
);

// Charger avec filtres
final filtered = await ref.read(loanRepositoryProvider).getLoans(
  page: 1,
  perPage: 10,
  status: LOAN_STATUS_APPROVED,
  sort: 'date_desc',
);

/// ============================================================================
/// C'est prêt! 🚀
/// ============================================================================

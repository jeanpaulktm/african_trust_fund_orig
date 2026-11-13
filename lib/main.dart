import 'package:flutter/material.dart';

import 'core/money/currency.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/atf_logo.dart';
import 'features/admin/presentation/admin_page.dart';
import 'features/analytics/presentation/analytics_page.dart';
import 'features/auth/domain/models/mandataire.dart';
import 'features/auth/domain/models/user.dart';
import 'features/auth/presentation/auth_page.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'features/credit/domain/services/credit_service.dart';
import 'features/credit/presentation/credit_page.dart';
import 'features/dashboard/presentation/dashboard_page.dart';
import 'features/notifications/presentation/notification_screen.dart';
import 'features/payments/domain/services/payment_gateway.dart';
import 'features/profile/presentation/profile_page.dart';
import 'features/savings/domain/services/savings_service.dart';
import 'features/savings/presentation/savings_page.dart';
import 'features/wallet/presentation/balances_page.dart';
import 'features/wallet/domain/services/wallet_service.dart';
import 'features/wallet/presentation/wallet_page.dart';

void main() {
  runApp(const AfricanTrustFundApp());
}

class AfricanTrustFundApp extends StatefulWidget {
  const AfricanTrustFundApp({super.key});

  @override
  State<AfricanTrustFundApp> createState() => _AfricanTrustFundAppState();
}

class _AfricanTrustFundAppState extends State<AfricanTrustFundApp>
    with WidgetsBindingObserver {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  final _themeNotifier = ThemeNotifier();
  final PaymentGateway _paymentGateway = const UnavailablePaymentGateway();
  late final WalletService _wallet;
  late final SavingsService _savings;
  late final CreditService _credit;
  late final List<User> _clients;
  User? _currentUser;
  bool _isAdmin = false;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _clients = [
      User(
        id: 'user-001',
        lastName: 'Kadeghu',
        postName: 'Mbuyi',
        firstName: 'Nehemie',
        email: 'client@africantrust.cd',
        dateOfBirth: DateTime(1995, 6, 12),
        identityNumber: 'ID-DEMO-001',
        phoneNumber: '+243 000 000 010',
        city: 'Kinshasa',
        commune: 'Gombe',
        neighborhood: 'Centre-ville',
        cell: 'Cellule 1',
        houseNumber: '12',
        profilePhotoPath: 'profil-demo.jpg',
        identityFrontPath: 'identite-recto-demo.jpg',
        identityBackPath: 'identite-verso-demo.jpg',
        passwordHash: 'pending-server-authentication',
        mandataire: const Mandataire(
          fullName: 'Grace Mbuyi',
          contact: '+243 000 000 000',
          relationship: 'Soeur',
          identityDocumentPath: 'mandataire-demo.jpg',
        ),
      ),
      User(
        id: 'user-002',
        lastName: 'Tshibanda',
        postName: 'Ilunga',
        firstName: 'Amina',
        email: 'amina@africantrust.cd',
        dateOfBirth: DateTime(1998, 3, 5),
        identityNumber: 'ID-DEMO-002',
        phoneNumber: '+243 000 000 011',
        city: 'Kinshasa',
        commune: 'Limete',
        neighborhood: 'Industriel',
        cell: 'Cellule 2',
        houseNumber: '24',
        profilePhotoPath: '',
        identityFrontPath: '',
        identityBackPath: '',
        passwordHash: 'pending-server-authentication',
        mandataire: const Mandataire(
          fullName: 'Paul Ilunga',
          contact: '+243 000 000 001',
          relationship: 'Parent',
          identityDocumentPath: '',
        ),
      ),
    ];
    _wallet = WalletService(
      usdToCdfRate: 2800,
      initialBalances: {
        'user-001': {Currency.usd: 1250, Currency.cdf: 820000},
        'user-002': {Currency.usd: 450, Currency.cdf: 250000},
      },
    );
    _savings = SavingsService(wallet: _wallet, annualInterestRate: 0.05);
    _credit = CreditService(
      wallet: _wallet,
      passwordVerifier: const UnavailablePasswordVerifier(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (_themeNotifier.themeMode == ThemeMode.system) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeNotifier,
      builder: (context, _) => MaterialApp(
        title: 'African Trust Fund',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: _messengerKey,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: _themeNotifier.themeMode,
        home: _showSplash
            ? SplashScreen(
                onCompleted: () => setState(() => _showSplash = false),
              )
            : _isAdmin
            ? AdminPage(
                clients: List.unmodifiable(_clients),
                wallet: _wallet,
                paymentGateway: _paymentGateway,
                onSignOut: _signOut,
                isDark: _themeNotifier.isDark,
                onToggleTheme: _themeNotifier.toggle,
              )
            : _currentUser == null
            ? AuthPage(
                onClientLogin: _login,
                onAdminLogin: () => setState(() => _isAdmin = true),
                onRegister: _register,
                isDark: _themeNotifier.isDark,
                onToggleTheme: _themeNotifier.toggle,
              )
            : _ClientShell(
                user: _currentUser!,
                clients: List.unmodifiable(_clients),
                wallet: _wallet,
                savings: _savings,
                credit: _credit,
                paymentGateway: _paymentGateway,
                onSignOut: _signOut,
                isDark: _themeNotifier.isDark,
                onToggleTheme: _themeNotifier.toggle,
              ),
      ),
    );
  }

  void _login(String email) {
    final normalizedEmail = email.toLowerCase();
    final existing = _clients.where(
      (client) => client.email.toLowerCase() == normalizedEmail,
    );
    if (existing.isEmpty) {
      _messengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Compte démo inconnu. Créez un compte pour continuer.'),
        ),
      );
      return;
    }
    setState(() {
      _currentUser = existing.first;
      _isAdmin = false;
    });
  }

  void _register(User user) {
    final duplicate = _clients.any(
      (client) => client.email.toLowerCase() == user.email.toLowerCase(),
    );
    if (duplicate) {
      _messengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Cette adresse e-mail est déjà inscrite.'),
        ),
      );
      return;
    }
    setState(() {
      _clients.add(user);
      _currentUser = user;
      _isAdmin = false;
    });
  }

  void _signOut() {
    setState(() {
      _currentUser = null;
      _isAdmin = false;
    });
  }
}

class _ClientShell extends StatefulWidget {
  const _ClientShell({
    required this.user,
    required this.clients,
    required this.wallet,
    required this.savings,
    required this.credit,
    required this.paymentGateway,
    required this.onSignOut,
    required this.isDark,
    required this.onToggleTheme,
  });

  final User user;
  final List<User> clients;
  final WalletService wallet;
  final SavingsService savings;
  final CreditService credit;
  final PaymentGateway paymentGateway;
  final VoidCallback onSignOut;
  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  State<_ClientShell> createState() => _ClientShellState();
}

class _ClientShellState extends State<_ClientShell>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late final AnimationController _pageTransitionController;

  @override
  void initState() {
    super.initState();
    _pageTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1,
    );
  }

  @override
  void dispose() {
    _pageTransitionController.dispose();
    super.dispose();
  }

  static const _titles = [
    'Accueil',
    'Mes soldes',
    'Portefeuille',
    'Mon profil',
    'Épargne',
    'Crédit',
    'Analyses',
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        wallet: widget.wallet,
        paymentGateway: widget.paymentGateway,
        phoneNumber: widget.user.phoneNumber,
        userId: widget.user.id,
        firstName: widget.user.firstName,
      ),
      BalancesPage(user: widget.user, wallet: widget.wallet),
      WalletPage(
        user: widget.user,
        clients: widget.clients,
        wallet: widget.wallet,
      ),
      ProfilePage(user: widget.user, onSignOut: widget.onSignOut),
      SavingsPage(user: widget.user, savings: widget.savings),
      CreditPage(user: widget.user, credit: widget.credit),
      AnalyticsPage(user: widget.user, wallet: widget.wallet),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        titleSpacing: 8,
        title: Row(
          children: [
            const AtfLogo(width: 68, height: 36, padding: 3),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _titles[_selectedIndex],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        actions: [
          IconButton(
            tooltip: widget.isDark
                ? 'Activer le mode clair'
                : 'Activer le mode sombre',
            onPressed: widget.onToggleTheme,
            icon: Icon(
              widget.isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: _openNotifications,
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        top: false,
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _pageTransitionController,
            curve: Curves.easeOut,
          ),
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.025, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _pageTransitionController,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: IndexedStack(index: _selectedIndex, children: pages),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex < 4 ? _selectedIndex : 0,
        onDestinationSelected: _showPage,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Soldes',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_rounded),
            selectedIcon: Icon(Icons.swap_horiz_rounded),
            label: 'Portefeuille',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer() => Drawer(
    backgroundColor: Theme.of(context).colorScheme.surface,
    child: SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: Theme.of(context).brightness == Brightness.dark
                    ? const [Color(0xFFE2B84B), Color(0xFFF4D782)]
                    : const [Color(0xFF087A52), Color(0xFF20A66F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AtfLogo(width: 194, height: 66),
                const SizedBox(height: 15),
                Text(
                  widget.user.fullName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.user.email,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary
                        .withValues(alpha: 0.78),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            secondary: Icon(
              widget.isDark
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Mode sombre'),
            value: widget.isDark,
            onChanged: (_) => widget.onToggleTheme(),
          ),
          _DrawerItem(
            icon: Icons.home_outlined,
            label: 'Accueil',
            selected: _selectedIndex == 0,
            onTap: () => _selectPage(0),
          ),
          _DrawerItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Mes soldes',
            selected: _selectedIndex == 1,
            onTap: () => _selectPage(1),
          ),
          _DrawerItem(
            icon: Icons.swap_horiz_rounded,
            label: 'Portefeuille & virements',
            selected: _selectedIndex == 2,
            onTap: () => _selectPage(2),
          ),
          _DrawerItem(
            icon: Icons.person_outline_rounded,
            label: 'Mon profil',
            selected: _selectedIndex == 3,
            onTap: () => _selectPage(3),
          ),
          _DrawerItem(
            icon: Icons.savings_outlined,
            label: 'Épargne',
            selected: _selectedIndex == 4,
            onTap: () => _selectPage(4),
          ),
          _DrawerItem(
            icon: Icons.request_quote_outlined,
            label: 'Crédit',
            selected: _selectedIndex == 5,
            onTap: () => _selectPage(5),
          ),
          _DrawerItem(
            icon: Icons.show_chart_rounded,
            label: 'Analyses financières',
            selected: _selectedIndex == 6,
            onTap: () => _selectPage(6),
          ),
          const Spacer(),
          const Divider(indent: 18, endIndent: 18),
          _DrawerItem(
            icon: Icons.logout_rounded,
            label: 'Se déconnecter',
            selected: false,
            onTap: () {
              Navigator.pop(context);
              widget.onSignOut();
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );

  void _selectPage(int index) {
    Navigator.pop(context);
    _showPage(index);
  }

  void _showPage(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    _pageTransitionController.forward(from: 0);
  }

  void _openNotifications() {
    Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const NotificationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(
      icon,
      color: selected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onSurfaceVariant,
    ),
    title: Text(
      label,
      style: TextStyle(
        color: selected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
        fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
        fontSize: 13,
      ),
    ),
    selected: selected,
    selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    onTap: onTap,
  );
}

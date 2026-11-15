# 🔧 Guide d'intégration du Main.dart avec Riverpod

## 📝 Conversion du main.dart actuel

Votre `main.dart` actuel utilise une architecture traditionnelle avec StateManagement local.
Nous allons le modifier pour utiliser Riverpod tout en gardant la compatibilité.

## ✅ Option 1: Migration complète à Riverpod (Recommandée)

### Étape 1: Importer les packages
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

### Étape 2: Envelopper l'app avec ProviderScope
```dart
void main() {
  runApp(
    const ProviderScope(  // ← NOUVEAU
      child: AfricanTrustFundApp(),
    ),
  );
}
```

### Étape 3: Remplacer la logique d'authentification
**AVANT:**
```dart
class _AfricanTrustFundAppState extends State<AfricanTrustFundApp> {
  User? _currentUser;
  bool _isAdmin = false;
  
  void _login(String email) {
    // Logique locale...
    setState(() {
      _currentUser = user;
    });
  }
}
```

**APRÈS:**
```dart
class AfricanTrustFundApp extends ConsumerWidget {
  const AfricanTrustFundApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'African Trust Fund',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: theme,
      home: authState.when(
        loading: () => SplashScreen(),
        error: (err, stack) => LoginScreen(),
        data: (auth) => auth.isAuthenticated 
          ? DashboardPage(
              user: auth.currentUser,
              onSignOut: () => ref.read(authProvider.notifier).logout(),
            )
          : LoginScreen(),
      ),
    );
  }
}
```

## 📊 Modification détaillée du main.dart

### Fichier complet révisé:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/dashboard/presentation/pages/dashboard_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: AfricanTrustFundApp(),
    ),
  );
}

class AfricanTrustFundApp extends ConsumerWidget {
  const AfricanTrustFundApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Regarder l'état d'authentification
    final authState = ref.watch(authProvider);
    
    // Regarder le thème
    final isDark = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'African Trust Fund',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: authState.when(
        // État de chargement
        loading: () => Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF087A52),
                  Color(0xFF20A66F),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ),
        ),
        // État d'erreur
        error: (error, stack) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('Erreur: $error'),
              ],
            ),
          ),
        ),
        // État avec données
        data: (authState) {
          // Vérifier si authentifié
          if (authState.isAuthenticated && authState.user != null) {
            return DashboardScreen();
          }
          // Sinon afficher login
          return LoginScreen();
        },
      ),
    );
  }
}

// Provider pour le thème
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, bool>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}
```

## 🔄 Option 2: Migration progressive (Moins de changements)

Si vous voulez garder la structure actuelle en parties:

### Ajouter juste ProviderScope
```dart
void main() {
  runApp(
    const ProviderScope(  // ← Envelopper seulement
      child: AfricanTrustFundApp(),
    ),
  );
}
```

### Garder la classe StatefulWidget
```dart
class _AfricanTrustFundAppState extends State<AfricanTrustFundApp> {
  // Conserver tout le code existant
  
  @override
  Widget build(BuildContext context) {
    // Utiliser les providers DANS le build
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authProvider);
        
        // Synchroniser avec votre logique existante
        if (authState.isAuthenticated) {
          // Mettre à jour _currentUser
          _currentUser = authState.user;
        }
        
        return MaterialApp(
          // Votre code existant
        );
      },
    );
  }
}
```

## 📋 Comparaison des deux options

| Aspect | Migration Complète | Migration Progressive |
|--------|-------------------|----------------------|
| Effort | 30 minutes | 10 minutes |
| Risque | Bas | Très bas |
| Performance | Excellente | Bonne |
| Maintenabilité | Excellente | Bonne |
| Compatibilité | 100% Riverpod | Hybride |

**Recommandation:** Migration complète (Option 1)

## 🚀 Étapes de migration complète

### 1. Sauvegarder le main.dart actuel
```bash
cp lib/main.dart lib/main.dart.backup
```

### 2. Créer le nouveau main.dart
Copier le code complet fourni ci-dessus

### 3. Vérifier les imports
```bash
flutter pub get
```

### 4. Tester
```bash
flutter run
```

### 5. Corriger les erreurs
Chercher les providers manquants

## 🔗 Providers requis

Assurez-vous que ces providers existent:

```dart
// auth_provider.dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

// dashboard_provider.dart
final dashboardProvider = FutureProvider<DashboardData>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getDashboard();
});
```

## ✅ Checklist de migration

- [ ] Sauvegarde du main.dart original
- [ ] Import de `flutter_riverpod`
- [ ] ProviderScope ajouté
- [ ] ConsumerWidget utilisé
- [ ] authProvider disponible
- [ ] Tests de compilation (`flutter build web --debug`)
- [ ] Tests de navigation
- [ ] Tests d'authentification
- [ ] Performance acceptable

## 🎯 Résultat final

Après la migration, vous aurez:
- ✅ Une architecture propre avec Riverpod
- ✅ State management centralisé
- ✅ Meilleure maintenabilité
- ✅ Réutilisabilité des providers
- ✅ Injection de dépendances automatique
- ✅ Compatibilité avec toutes les pages UI

## 💡 Bonnes pratiques

### 1. Utiliser Consumer pour l'accès aux providers
```dart
// ✅ BON
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return Text('Connecté');
  }
}

// ❌ MAUVAIS
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider); // 'ref' n'existe pas!
    return Text('Connecté');
  }
}
```

### 2. Écouter les changements avec listen
```dart
ref.listen(authProvider, (previous, next) {
  if (next.error != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur: ${next.error}')),
    );
  }
});
```

### 3. Utiliser les sélecteurs pour l'optimisation
```dart
// Ne reconstruire que si isAuthenticated change
final isAuth = ref.watch(
  authProvider.select((state) => state.isAuthenticated),
);
```

## 📞 Support

Si vous avez des erreurs:
1. Vérifiez que ProviderScope enveloppe MaterialApp
2. Assurez-vous d'utiliser ConsumerWidget
3. Vérifiez les imports des providers
4. Exécutez `flutter clean && flutter pub get`

---

**Créé par:** AI Assistant  
**Date:** 14 Novembre 2026  
**Version:** 1.0  
**Status:** ✅ Complet

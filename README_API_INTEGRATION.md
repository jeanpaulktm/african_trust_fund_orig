# 🏦 African Trust Fund - Intégration API Mobile

Intégration complète de l'API African Trust Fund dans une application Flutter avec une architecture propre utilisant Riverpod.

## 📋 Table des matières

- [📋 Vue d'ensemble](#vue-densemble)
- [✨ Fonctionnalités](#fonctionnalités)
- [🏗️ Architecture](#architecture)
- [🚀 Installation](#installation)
- [📖 Documentation](#documentation)
- [🧪 Utilisation](#utilisation)
- [🔐 Sécurité](#sécurité)
- [📝 Endpoints implémentés](#endpoints-implémentés)

## 📋 Vue d'ensemble

Cette implémentation fournit une intégration complète entre l'application Flutter **African Trust Fund** et son backend PHP. Elle couvre:

- ✅ **PART 1** - Authentification & Dashboard
- ✅ **PART 2** - Gestion des Prêts  
- 📝 **PART 3** - Transactions Financières
- 📝 **PART 4** - Placements & Épargne
- 📝 **PART 5** - Profil, Documents & Autres

## ✨ Fonctionnalités

### Authentification
- ✅ Connexion utilisateur
- ✅ Enregistrement nouvel utilisateur
- ✅ Renouvellement automatique du token
- ✅ Déconnexion sécurisée
- ✅ Stockage sécurisé du token (FlutterSecureStorage)

### Dashboard
- ✅ Soldes en CDF et USD
- ✅ Statistiques des prêts
- ✅ Statistiques des placements
- ✅ Transactions récentes
- ✅ Prochain paiement dû

### Prêts
- ✅ Liste complète des prêts
- ✅ Détails prêt avec échéancier
- ✅ Simulateur de prêt
- ✅ Demande de nouveau prêt
- ✅ Remboursement de prêt

### Transactions (À implémenter)
- 📝 Liste des transactions
- 📝 Dépôts
- 📝 Retraits
- 📝 Virements inter-clients

### Placements (À implémenter)
- 📝 Liste des placements
- 📝 Création de placement
- 📝 Simulateur de placement
- 📝 Retrait de placement

### Profil (À implémenter)
- 📝 Voir le profil complet
- 📝 Modifier les informations
- 📝 Upload d'avatar
- 📝 Gestion des documents
- 📝 Téléchargement de contrats

## 🏗️ Architecture

```
lib/
├── core/
│   └── api/
│       ├── api_config.dart          # Configuration API
│       └── api_service.dart         # Service HTTP principal
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── auth_models.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       └── providers/
│   │           └── auth_provider.dart
│   ├── dashboard/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── dashboard_models.dart
│   │   │   └── repositories/
│   │   │       └── dashboard_repository.dart
│   │   └── presentation/
│   │       └── providers/
│   │           └── dashboard_provider.dart
│   ├── credit/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── loan_models.dart
│   │   │   └── repositories/
│   │   │       └── loan_repository.dart
│   ├── wallet/
│   ├── savings/
│   └── profile/
```

**Architecture en couches:**

1. **Présentation** → Widgets Flutter + Riverpod Providers
2. **Données** → Repositories + API Service
3. **Modèles** → Classes JSON sérialisables
4. **API** → Service HTTP centralisé

## 🚀 Installation

### Prérequis
- Flutter 3.13.7+
- Dart 3.1.0+
- Android Studio / Xcode

### Étapes

1. **Cloner le projet**
```bash
git clone <url-repo>
cd african
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Générer les modèles JSON**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Configurer l'URL de base**

Éditer `lib/core/api/api_config.dart`:
```dart
static const String baseUrl = 'https://votre-api.cd';
```

5. **Lancer l'application**
```bash
flutter run
```

## 📖 Documentation

### Guides complets

- **[API_INTEGRATION_GUIDE.md](./API_INTEGRATION_GUIDE.md)** - Guide complet d'intégration
- **[UI_INTEGRATION_GUIDE.md](./UI_INTEGRATION_GUIDE.md)** - Intégration dans les widgets
- **[PARTS_3_4_5_IMPLEMENTATION.md](./PARTS_3_4_5_IMPLEMENTATION.md)** - Implémentation des PART 3, 4, 5

### Configuration

**lib/core/api/api_config.dart**
```dart
class ApiConfig {
  static const String baseUrl = 'https://api.africantrust.cd';
  static const String apiVersion = '/api/v1';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
```

## 🧪 Utilisation

### Exemple 1: Authentification

```dart
import 'package:african/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return ElevatedButton(
      onPressed: () {
        ref.read(authProvider.notifier).login(
          email: 'user@example.com',
          password: 'password123',
        );
      },
      child: const Text('Se connecter'),
    );
  }
}
```

### Exemple 2: Dashboard

```dart
import 'package:african/features/dashboard/presentation/providers/dashboard_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(dashboardProvider.notifier).fetchDashboard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);
    
    return RefreshIndicator(
      onRefresh: () => ref
          .read(dashboardProvider.notifier)
          .refreshDashboard(),
      child: ListView(
        children: [
          Text('Solde CDF: ${dashboardState.data?.balances.cdf}'),
          Text('Solde USD: ${dashboardState.data?.balances.usd}'),
        ],
      ),
    );
  }
}
```

### Exemple 3: Prêts

```dart
final loanRepository = ref.watch(loanRepositoryProvider);

// Récupérer la liste des prêts
final loans = await loanRepository.getLoans(page: 1);

// Simuler un prêt
final simulation = await loanRepository.simulateLoan(
  amount: 1000000,
  currency: 'CDF',
  loanType: 'classique',
  termMonths: 24,
);

// Demander un prêt
final response = await loanRepository.requestLoan(
  amount: 1000000,
  currency: 'CDF',
  loanType: 'classique',
  termMonths: 24,
  purpose: 'Besoin professionnel',
);
```

## 🔐 Sécurité

- ✅ Tokens stockés dans FlutterSecureStorage
- ✅ Jamais de mots de passe stockés
- ✅ Bearer tokens automatiquement ajoutés
- ✅ Renouvellement automatique du token
- ✅ Gestion des erreurs 401
- ✅ HTTPS obligatoire en production
- ✅ Validation HMAC-SHA256

## 📝 Endpoints implémentés

### Authentification (PART 1)
```
✅ POST   /api/v1/auth/login              Connexion
✅ POST   /api/v1/auth/register           Enregistrement
✅ POST   /api/v1/auth/refresh            Renouveler token
✅ POST   /api/v1/auth/logout             Déconnexion
✅ GET    /api/v1/auth/profile            Profil utilisateur
✅ GET    /api/v1/dashboard               Dashboard complet
```

### Prêts (PART 2)
```
✅ GET    /api/v1/prets                   Liste prêts
✅ GET    /api/v1/prets/{id}              Détails prêt
✅ POST   /api/v1/prets/demand            Demander prêt
✅ POST   /api/v1/prets/{id}/repay        Rembourser prêt
✅ POST   /api/v1/prets/simuler           Simuler prêt
```

### Transactions (PART 3)
```
📝 GET    /api/v1/transactions            Liste transactions
📝 POST   /api/v1/transactions/deposit    Créer dépôt
📝 POST   /api/v1/transactions/withdrawal Créer retrait
📝 POST   /api/v1/transactions/transfer   Virement
```

### Placements (PART 4)
```
📝 GET    /api/v1/placements              Liste placements
📝 POST   /api/v1/placements              Créer placement
📝 POST   /api/v1/placements/{id}/withdraw Retirer placement
📝 POST   /api/v1/placements/simuler      Simuler placement
```

### Profil (PART 5)
```
📝 GET    /api/v1/profil                  Récupérer profil
📝 PUT    /api/v1/profil                  Modifier profil
📝 POST   /api/v1/profil/avatar           Upload avatar
📝 GET    /api/v1/profil/documents        Liste documents
📝 POST   /api/v1/profil/documents        Upload document
```

## 📦 Dépendances

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # API & HTTP
  dio: ^5.4.0
  flutter_secure_storage: ^9.0.0
  
  # State Management
  riverpod: ^2.4.0
  flutter_riverpod: ^2.4.0
  
  # Serialization
  json_serializable: ^6.7.1
  json_annotation: ^4.8.1
  
  # Utils
  intl: ^0.20.0
  logger: ^2.1.0

dev_dependencies:
  build_runner: ^2.4.6
  json_serializable: ^6.7.1
```

## 🚀 Prochaines étapes

- [ ] Implémenter PART 3 - Transactions
- [ ] Implémenter PART 4 - Placements
- [ ] Implémenter PART 5 - Profil
- [ ] Tester tous les endpoints
- [ ] Ajouter des tests unitaires
- [ ] Intégrer à la UI existante
- [ ] Déployer en production

## 📞 Support

Pour plus d'informations, consultez:
- [Documentation API](./API_INTEGRATION_GUIDE.md)
- [Guide UI](./UI_INTEGRATION_GUIDE.md)
- [Implémentation PART 3, 4, 5](./PARTS_3_4_5_IMPLEMENTATION.md)

## 📄 Licence

Ce projet est propriétaire et confidentiel. Tous droits réservés.

---

**Créé par:** AI Assistant  
**Date:** 14 Novembre 2026  
**Version:** 1.0

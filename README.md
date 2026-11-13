# African Trust Fund

Prototype Flutter de microfinance USD/CDF avec un thème fintech clair/sombre,
un parcours client, des espaces d'épargne/crédit et des analyses.

## Architecture

```text
lib/
├── core/
│   ├── money/currency.dart
│   ├── theme/app_theme.dart
│   └── widgets/{atf_logo,gradient_button}.dart
├── features/
│   ├── admin/presentation/admin_page.dart
│   ├── analytics/presentation/analytics_page.dart
│   ├── auth/
│   │   ├── domain/models/{mandataire,user}.dart
│   │   └── presentation/{auth_page,splash_screen}.dart
│   ├── credit/
│   │   ├── domain/models/credit_request.dart
│   │   ├── domain/services/credit_service.dart
│   │   └── presentation/credit_page.dart
│   ├── dashboard/presentation/dashboard_page.dart
│   ├── payments/
│   │   ├── domain/models/{payment_result,withdrawal_ticket}.dart
│   │   ├── domain/services/payment_gateway.dart
│   │   └── presentation/counter_withdrawal_scanner_page.dart
│   ├── profile/presentation/profile_page.dart
│   ├── savings/
│   │   ├── domain/models/savings_investment.dart
│   │   ├── domain/services/savings_service.dart
│   │   └── presentation/savings_page.dart
│   └── wallet/
│       ├── domain/models/{solde,transaction}.dart
│       ├── domain/services/wallet_service.dart
│       └── presentation/{balances_page,wallet_page}.dart
└── main.dart
```

Le logo officiel est `lib/atf.jpg`, déclaré dans les assets Flutter et partagé
entre l'écran d'accueil, la connexion, l'inscription, l'espace client et
l'administration. Le thème sombre utilise un fond bleu marine, des accents or
et une typographie claire. Le formulaire d'inscription et le profil affichent
le téléphone et l'adresse complète (ville, commune, quartier, cellule et
numéro de maison).

Les services et modèles métier sont isolés de leur présentation et peuvent être
remplacés par des adaptateurs de données/API lorsque le backend sera disponible.

## Fonctionnalités

- Splash d'accueil de 15 secondes avec le logo officiel, thème basculable et
  palette émeraude en mode clair, bleu marine/or/blanc en mode sombre.
- Inscription avec sélection des justificatifs depuis la galerie, connexion
  démo, profil et menu client.
- Portefeuille USD/CDF, virements convertis au taux administré et journal des
  opérations. Dépôt et retrait démarrent un flux Mobile Money via une interface
  fournisseur; les retraits proposent aussi un bordereau QR au guichet avec
  confirmation par scanner opérateur.
- Épargne : placement débité du portefeuille, intérêts simples calculés au fil
  du temps et affichage actualisé chaque seconde.
- Crédit : création et suivi local des demandes, décaissement et remboursement
  partiel/complet. Chaque mouvement exige le vérificateur de mot de passe; le
  décaissement est bloqué si celui-ci n'est pas configuré ou ne valide pas
  l'identité.
- Analyses interactives `fl_chart` sur 7 jours, 30 jours ou 12 mois, par devise.

## Paramètres de démonstration

Le taux d'intérêt annuel de 5 % est une valeur illustrative configurée dans
`main.dart`; le calcul est à intérêt simple, sur une base de 365 jours. Aucun
taux ni rendement n'est garanti.

## Limites de sécurité et mise en production

Cette version ne persiste pas les données et n'effectue aucun mouvement
financier réel. Les flux Mobile Money, d'émission de bordereau et de validation
au guichet utilisent par défaut `UnavailablePaymentGateway` et indiquent
explicitement qu'aucun fonds n'a été déplacé. Il faut remplacer ce service par
un adaptateur vers un backend/API réel; aucun fournisseur, endpoint ni secret
n'est inclus. Seule une confirmation authentifiée du backend doit faire
apparaître un mouvement dans le ledger. Le QR contient uniquement un identifiant
opaque; le backend doit vérifier le rôle du guichetier, l'expiration, le statut,
le montant et empêcher les doubles validations de façon atomique. Le scanner
présent dans la console de démonstration n'est pas une authentification ni une
autorisation de guichetier. Soldes, placements, demandes, taux et opérations
sont tenus en mémoire. Le décaissement utilise l'interface `PasswordVerifier`, mais la
configuration de démo `UnavailablePasswordVerifier` refuse toujours le
décaissement : l'application ne stocke ni ne compare localement le mot de passe
initial, et ne conserve pas le mot de passe saisi. Il faut relier cette
interface à une API d'authentification qui vérifie le mot de passe côté serveur,
puis traiter l'approbation et le versement dans une transaction serveur atomique.

Avant toute mise en production, authentification, rôles, KYC, ledger, taux,
intérêts, demandes de crédit, journal d'audit et mouvements de fonds doivent
être gérés par un backend sécurisé, persisté et conforme aux règles applicables.

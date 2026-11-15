/// ============================================================================
/// 📋 IMPLÉMENTATION COMPLÈTE PARTS 3, 4, 5
/// ============================================================================
/// 
/// Ce document contient les modèles et repositories pour les 3 dernières
/// parties de l'intégration API African Trust Fund.
///
/// À faire:
/// 1. Créer les dossiers: wallet/data/models, savings/data/models, profile/data/models
/// 2. Copier-coller les codes des sections appropriées ci-dessous
/// 3. Générer les fichiers .g.dart avec:
///    flutter pub run build_runner build --delete-conflicting-outputs
///
/// ============================================================================
/// 📌 PART 3 - TRANSACTIONS FINANCIÈRES
/// ============================================================================
///
/// Fichier: lib/features/wallet/data/models/transaction_models.dart
/// ----
/// 
/// import 'package:json_annotation/json_annotation.dart';
/// part 'transaction_models.g.dart';
/// 
/// @JsonSerializable()
/// class TransactionsListResponse {
///   @JsonKey(name: 'success') final bool success;
///   @JsonKey(name: 'data') final List<TransactionDetail> data;
///   @JsonKey(name: 'pagination') final Pagination? pagination;
///   @JsonKey(name: 'timestamp') final String timestamp;
///   TransactionsListResponse({...});
///   factory TransactionsListResponse.fromJson(Map<String, dynamic> json) => ...;
///   Map<String, dynamic> toJson() => ...;
/// }
/// 
/// @JsonSerializable()
/// class TransactionDetail {
///   @JsonKey(name: 'id') final String id;
///   @JsonKey(name: 'reference') final String reference;
///   @JsonKey(name: 'type') final String type;  // deposit, withdrawal, transfer
///   @JsonKey(name: 'amount') final double amount;
///   @JsonKey(name: 'currency') final String currency;
///   @JsonKey(name: 'fees') final double fees;
///   @JsonKey(name: 'net_amount') final double netAmount;
///   @JsonKey(name: 'status') final String status;  // complete, pending, failed
///   @JsonKey(name: 'description') final String description;
///   @JsonKey(name: 'beneficiary') final String? beneficiary;
///   @JsonKey(name: 'created_at') final String createdAt;
///   @JsonKey(name: 'completed_at') final String? completedAt;
///   ...
/// }
/// 
/// ----
/// Fichier: lib/features/wallet/data/repositories/transaction_repository.dart
/// ----
/// 
/// class TransactionRepository {
///   final ApiService apiService;
///   TransactionRepository({required this.apiService});
/// 
///   Future<TransactionsListResponse> getTransactions({
///     int page = 1,
///     int perPage = 10,
///   }) async {
///     final response = await apiService.get(
///       '/api/v1/transactions',
///       queryParameters: {'page': page, 'per_page': perPage},
///     );
///     return TransactionsListResponse.fromJson(response);
///   }
/// 
///   Future<TransactionResponse> deposit({
///     required double amount,
///     required String currency,
///     required String paymentMethod,
///   }) async {
///     final response = await apiService.post(
///       '/api/v1/transactions/deposit',
///       data: {
///         'amount': amount,
///         'currency': currency,
///         'payment_method': paymentMethod,
///       },
///     );
///     return TransactionResponse.fromJson(response);
///   }
/// 
///   Future<TransactionResponse> withdrawal({
///     required double amount,
///     required String currency,
///     required String paymentMethod,
///   }) async {
///     final response = await apiService.post(
///       '/api/v1/transactions/withdrawal',
///       data: {
///         'amount': amount,
///         'currency': currency,
///         'payment_method': paymentMethod,
///       },
///     );
///     return TransactionResponse.fromJson(response);
///   }
/// 
///   Future<TransactionResponse> transfer({
///     required double amount,
///     required String currency,
///     required String beneficiaryEmail,
///     required String reason,
///   }) async {
///     final response = await apiService.post(
///       '/api/v1/transactions/transfer',
///       data: {
///         'amount': amount,
///         'currency': currency,
///         'beneficiary_email': beneficiaryEmail,
///         'reason': reason,
///       },
///     );
///     return TransactionResponse.fromJson(response);
///   }
/// }
///
/// ============================================================================
/// 📌 PART 4 - PLACEMENTS & ÉPARGNE
/// ============================================================================
///
/// Fichier: lib/features/savings/data/models/placement_models.dart
/// ----
/// 
/// import 'package:json_annotation/json_annotation.dart';
/// part 'placement_models.g.dart';
/// 
/// @JsonSerializable()
/// class PlacementsListResponse {
///   @JsonKey(name: 'success') final bool success;
///   @JsonKey(name: 'data') final List<PlacementSummary> data;
///   @JsonKey(name: 'pagination') final Pagination? pagination;
///   @JsonKey(name: 'timestamp') final String timestamp;
///   ...
/// }
/// 
/// @JsonSerializable()
/// class PlacementSummary {
///   @JsonKey(name: 'id') final String id;
///   @JsonKey(name: 'reference') final String reference;
///   @JsonKey(name: 'capital_invested') final double capitalInvested;
///   @JsonKey(name: 'currency') final String currency;
///   @JsonKey(name: 'interest_rate') final double interestRate;
///   @JsonKey(name: 'term_months') final int termMonths;
///   @JsonKey(name: 'status') final String status;  // actif, cloture, anticipe
///   @JsonKey(name: 'accumulated_interest') final double accumulatedInterest;
///   @JsonKey(name: 'start_date') final String startDate;
///   @JsonKey(name: 'maturity_date') final String maturityDate;
///   ...
/// }
/// 
/// @JsonSerializable()
/// class PlacementDetailResponse {
///   @JsonKey(name: 'success') final bool success;
///   @JsonKey(name: 'data') final PlacementDetail data;
///   @JsonKey(name: 'timestamp') final String timestamp;
///   ...
/// }
/// 
/// @JsonSerializable()
/// class PlacementDetail {
///   @JsonKey(name: 'id') final String id;
///   @JsonKey(name: 'reference') final String reference;
///   @JsonKey(name: 'capital_invested') final double capitalInvested;
///   @JsonKey(name: 'interest_rate') final double interestRate;
///   @JsonKey(name: 'term_months') final int termMonths;
///   @JsonKey(name: 'currency') final String currency;
///   @JsonKey(name: 'status') final String status;
///   @JsonKey(name: 'accumulated_interest') final double accumulatedInterest;
///   @JsonKey(name: 'monthly_breakdown') final List<MonthlyInterest> monthlyBreakdown;
///   @JsonKey(name: 'start_date') final String startDate;
///   @JsonKey(name: 'maturity_date') final String maturityDate;
///   @JsonKey(name: 'creation_date') final String creationDate;
///   ...
/// }
/// 
/// @JsonSerializable()
/// class MonthlyInterest {
///   @JsonKey(name: 'month') final int month;
///   @JsonKey(name: 'interest_earned') final double interestEarned;
///   @JsonKey(name: 'total_accumulated') final double totalAccumulated;
///   ...
/// }
/// 
/// ----
/// Fichier: lib/features/savings/data/repositories/placement_repository.dart
/// ----
/// 
/// class PlacementRepository {
///   final ApiService apiService;
///   PlacementRepository({required this.apiService});
/// 
///   Future<PlacementsListResponse> getPlacements({
///     int page = 1,
///     int perPage = 10,
///     String? status,
///   }) async {
///     final response = await apiService.get(
///       '/api/v1/placements',
///       queryParameters: {
///         'page': page,
///         'per_page': perPage,
///         if (status != null) 'status': status,
///       },
///     );
///     return PlacementsListResponse.fromJson(response);
///   }
/// 
///   Future<PlacementDetailResponse> getPlacementDetails(String placementId) async {
///     final response = await apiService.get('/api/v1/placements/$placementId');
///     return PlacementDetailResponse.fromJson(response);
///   }
/// 
///   Future<TransactionResponse> createPlacement({
///     required double capital,
///     required String currency,
///     required int termMonths,
///   }) async {
///     final response = await apiService.post(
///       '/api/v1/placements',
///       data: {
///         'capital': capital,
///         'currency': currency,
///         'term_months': termMonths,
///       },
///     );
///     return TransactionResponse.fromJson(response);
///   }
/// 
///   Future<PlacementSimulationResponse> simulatePlacement({
///     required double capital,
///     required String currency,
///     required int termMonths,
///   }) async {
///     final response = await apiService.post(
///       '/api/v1/placements/simuler',
///       data: {
///         'capital': capital,
///         'currency': currency,
///         'term_months': termMonths,
///       },
///     );
///     return PlacementSimulationResponse.fromJson(response);
///   }
/// 
///   Future<TransactionResponse> withdrawPlacement(String placementId) async {
///     final response = await apiService.post(
///       '/api/v1/placements/$placementId/withdraw',
///       data: {},
///     );
///     return TransactionResponse.fromJson(response);
///   }
/// }
///
/// ============================================================================
/// 📌 PART 5 - PROFIL, DOCUMENTS & AUTRES
/// ============================================================================
///
/// Fichier: lib/features/profile/data/models/profile_models.dart
/// ----
/// 
/// import 'package:json_annotation/json_annotation.dart';
/// part 'profile_models.g.dart';
/// 
/// @JsonSerializable()
/// class ProfileDetailResponse {
///   @JsonKey(name: 'success') final bool success;
///   @JsonKey(name: 'data') final ProfileDataDetail data;
///   @JsonKey(name: 'timestamp') final String timestamp;
///   ...
/// }
/// 
/// @JsonSerializable()
/// class ProfileDataDetail {
///   @JsonKey(name: 'id') final String id;
///   @JsonKey(name: 'email') final String email;
///   @JsonKey(name: 'phone_number') final String phoneNumber;
///   @JsonKey(name: 'first_name') final String firstName;
///   @JsonKey(name: 'last_name') final String lastName;
///   @JsonKey(name: 'date_of_birth') final String? dateOfBirth;
///   @JsonKey(name: 'identity_number') final String? identityNumber;
///   @JsonKey(name: 'identity_type') final String? identityType;
///   @JsonKey(name: 'street') final String? street;
///   @JsonKey(name: 'city') final String? city;
///   @JsonKey(name: 'commune') final String? commune;
///   @JsonKey(name: 'neighborhood') final String? neighborhood;
///   @JsonKey(name: 'country') final String? country;
///   @JsonKey(name: 'profession') final String? profession;
///   @JsonKey(name: 'employer') final String? employer;
///   @JsonKey(name: 'avatar') final String? avatar;
///   @JsonKey(name: 'account_status') final String accountStatus;
///   @JsonKey(name: 'kyc_status') final String kycStatus;
///   @JsonKey(name: 'created_at') final String createdAt;
///   @JsonKey(name: 'updated_at') final String updatedAt;
///   ...
/// }
/// 
/// @JsonSerializable()
/// class UpdateProfileRequest {
///   @JsonKey(name: 'first_name') final String? firstName;
///   @JsonKey(name: 'last_name') final String? lastName;
///   @JsonKey(name: 'phone_number') final String? phoneNumber;
///   @JsonKey(name: 'date_of_birth') final String? dateOfBirth;
///   @JsonKey(name: 'street') final String? street;
///   @JsonKey(name: 'city') final String? city;
///   @JsonKey(name: 'commune') final String? commune;
///   @JsonKey(name: 'neighborhood') final String? neighborhood;
///   @JsonKey(name: 'profession') final String? profession;
///   @JsonKey(name: 'employer') final String? employer;
///   ...
/// }
/// 
/// @JsonSerializable()
/// class DocumentsListResponse {
///   @JsonKey(name: 'success') final bool success;
///   @JsonKey(name: 'data') final List<DocumentDetail> data;
///   @JsonKey(name: 'timestamp') final String timestamp;
///   ...
/// }
/// 
/// @JsonSerializable()
/// class DocumentDetail {
///   @JsonKey(name: 'id') final String id;
///   @JsonKey(name: 'type') final String type;  // passport, visa, contract, etc
///   @JsonKey(name: 'name') final String name;
///   @JsonKey(name: 'file_path') final String filePath;
///   @JsonKey(name: 'file_size') final int fileSize;
///   @JsonKey(name: 'status') final String status;  // approved, pending, rejected
///   @JsonKey(name: 'uploaded_at') final String uploadedAt;
///   ...
/// }
/// 
/// ----
/// Fichier: lib/features/profile/data/repositories/profile_repository.dart
/// ----
/// 
/// class ProfileRepository {
///   final ApiService apiService;
///   ProfileRepository({required this.apiService});
/// 
///   Future<ProfileDetailResponse> getProfile() async {
///     final response = await apiService.get('/api/v1/profil');
///     return ProfileDetailResponse.fromJson(response);
///   }
/// 
///   Future<ProfileDetailResponse> updateProfile({
///     String? firstName,
///     String? lastName,
///     String? phoneNumber,
///     String? dateOfBirth,
///     String? street,
///     String? city,
///     String? commune,
///     String? neighborhood,
///     String? profession,
///     String? employer,
///   }) async {
///     final data = <String, dynamic>{};
///     if (firstName != null) data['first_name'] = firstName;
///     if (lastName != null) data['last_name'] = lastName;
///     if (phoneNumber != null) data['phone_number'] = phoneNumber;
///     if (dateOfBirth != null) data['date_of_birth'] = dateOfBirth;
///     if (street != null) data['street'] = street;
///     if (city != null) data['city'] = city;
///     if (commune != null) data['commune'] = commune;
///     if (neighborhood != null) data['neighborhood'] = neighborhood;
///     if (profession != null) data['profession'] = profession;
///     if (employer != null) data['employer'] = employer;
///     
///     final response = await apiService.put(
///       '/api/v1/profil',
///       data: data,
///     );
///     return ProfileDetailResponse.fromJson(response);
///   }
/// 
///   Future<Map<String, dynamic>> uploadAvatar(String filePath) async {
///     return await apiService.uploadFile(
///       '/api/v1/profil/avatar',
///       filePath: filePath,
///       fieldName: 'avatar',
///     );
///   }
/// 
///   Future<DocumentsListResponse> getDocuments() async {
///     final response = await apiService.get('/api/v1/profil/documents');
///     return DocumentsListResponse.fromJson(response);
///   }
/// 
///   Future<Map<String, dynamic>> uploadDocument(
///     String filePath,
///     String documentType,
///   ) async {
///     return await apiService.uploadFile(
///       '/api/v1/profil/documents',
///       filePath: filePath,
///       fieldName: 'document',
///       additionalData: {'type': documentType},
///     );
///   }
/// 
///   Future<Map<String, dynamic>> getLoanContract(String loanId) async {
///     return await apiService.get('/api/v1/prets/$loanId/contrat');
///   }
/// 
///   Future<Map<String, dynamic>> getAccountStatement() async {
///     return await apiService.get('/api/v1/releve');
///   }
/// }
///
/// ============================================================================
/// 🔧 CRÉER LES PROVIDERS RIVERPOD
/// ============================================================================
///
/// Fichier: lib/features/wallet/presentation/providers/transaction_provider.dart
/// ----
/// 
/// final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
///   final apiService = ref.watch(apiServiceProvider);
///   return TransactionRepository(apiService: apiService);
/// });
/// 
/// final transactionsProvider =
///   StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
///   final repository = ref.watch(transactionRepositoryProvider);
///   return TransactionNotifier(repository: repository);
/// });
///
/// Fichier: lib/features/savings/presentation/providers/placement_provider.dart
/// ----
/// 
/// final placementRepositoryProvider = Provider<PlacementRepository>((ref) {
///   final apiService = ref.watch(apiServiceProvider);
///   return PlacementRepository(apiService: apiService);
/// });
/// 
/// final placementsProvider =
///   StateNotifierProvider<PlacementNotifier, PlacementState>((ref) {
///   final repository = ref.watch(placementRepositoryProvider);
///   return PlacementNotifier(repository: repository);
/// });
///
/// Fichier: lib/features/profile/presentation/providers/profile_provider.dart
/// ----
/// 
/// final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
///   final apiService = ref.watch(apiServiceProvider);
///   return ProfileRepository(apiService: apiService);
/// });
/// 
/// final profileProvider =
///   StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
///   final repository = ref.watch(profileRepositoryProvider);
///   return ProfileNotifier(repository: repository);
/// });
///
/// ============================================================================
/// ✅ CHECKLIST D'IMPLÉMENTATION
/// ============================================================================
/// 
/// [ ] Créer dossiers: wallet/data/models, wallet/data/repositories
/// [ ] Copier-coller transaction_models.dart
/// [ ] Copier-coller transaction_repository.dart
/// [ ] Générer .g.dart files
/// [ ] Créer transaction_provider.dart
/// 
/// [ ] Créer dossiers: savings/data/models, savings/data/repositories
/// [ ] Copier-coller placement_models.dart
/// [ ] Copier-coller placement_repository.dart
/// [ ] Générer .g.dart files
/// [ ] Créer placement_provider.dart
/// 
/// [ ] Créer dossiers: profile/data/models, profile/data/repositories
/// [ ] Copier-coller profile_models.dart
/// [ ] Copier-coller profile_repository.dart
/// [ ] Générer .g.dart files
/// [ ] Créer profile_provider.dart
/// 
/// [ ] Intégrer les providers dans la UI
/// [ ] Tester chaque endpoint
/// [ ] Déployer en production
/// 
/// ============================================================================

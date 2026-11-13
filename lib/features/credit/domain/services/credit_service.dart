import '../../../../core/money/currency.dart';
import '../../../wallet/domain/services/wallet_service.dart';
import '../models/credit_request.dart';

enum PasswordVerificationResult { verified, rejected, unavailable }

abstract interface class PasswordVerifier {
  Future<PasswordVerificationResult> verifyPassword({
    required String userId,
    required String password,
  });
}

class UnavailablePasswordVerifier implements PasswordVerifier {
  const UnavailablePasswordVerifier();

  @override
  Future<PasswordVerificationResult> verifyPassword({
    required String userId,
    required String password,
  }) async => PasswordVerificationResult.unavailable;
}

class CreditService {
  CreditService({
    required this.wallet,
    required this.passwordVerifier,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final WalletService wallet;
  final PasswordVerifier passwordVerifier;
  final DateTime Function() _clock;
  final List<CreditRequest> _requests = [];
  final Set<String> _processingRequestIds = {};
  int _nextId = 0;

  List<CreditRequest> requestsFor(String userId) =>
      List.unmodifiable(_requests.where((request) => request.userId == userId));

  CreditRequest request({
    required String userId,
    required Currency currency,
    required double amount,
  }) {
    if (userId.trim().isEmpty || !amount.isFinite || amount <= 0) {
      throw ArgumentError('Identifiant ou montant invalide.');
    }
    final roundedAmount = (amount * 100).roundToDouble() / 100;
    if (!roundedAmount.isFinite || roundedAmount <= 0) {
      throw ArgumentError('Identifiant ou montant invalide.');
    }
    final request = CreditRequest(
      id: 'credit-${++_nextId}',
      userId: userId,
      amount: roundedAmount,
      currency: currency,
      createdAt: _clock(),
    );
    _requests.insert(0, request);
    return request;
  }

  Future<PasswordVerificationResult> disburse({
    required String userId,
    required String requestId,
    required String password,
  }) async {
    final index = _requests.indexWhere(
      (request) => request.id == requestId && request.userId == userId,
    );
    if (index < 0) throw StateError('Demande de crédit introuvable.');
    final request = _requests[index];
    if (request.status != CreditRequestStatus.pending) {
      throw StateError('Cette demande a déjà été décaissée.');
    }
    if (password.isEmpty) return PasswordVerificationResult.rejected;
    if (!_processingRequestIds.add(requestId)) {
      throw StateError('Une opération est déjà en cours pour ce crédit.');
    }

    try {
      final verification = await passwordVerifier.verifyPassword(
        userId: userId,
        password: password,
      );
      if (verification != PasswordVerificationResult.verified) {
        return verification;
      }

      final currentIndex = _requests.indexWhere(
        (item) => item.id == requestId && item.userId == userId,
      );
      if (currentIndex < 0 ||
          _requests[currentIndex].status != CreditRequestStatus.pending) {
        throw StateError('Cette demande ne peut plus être décaissée.');
      }
      final currentRequest = _requests[currentIndex];
      wallet.disburseLoan(
        userId: userId,
        currency: currentRequest.currency,
        amount: currentRequest.amount,
      );
      _requests[currentIndex] = currentRequest.copyWith(
        status: CreditRequestStatus.disbursed,
      );
      return PasswordVerificationResult.verified;
    } finally {
      _processingRequestIds.remove(requestId);
    }
  }

  Future<PasswordVerificationResult> repay({
    required String userId,
    required String requestId,
    required double amount,
    required String password,
  }) async {
    final index = _requests.indexWhere(
      (request) => request.id == requestId && request.userId == userId,
    );
    if (index < 0) throw StateError('Demande de crédit introuvable.');
    final request = _requests[index];
    if (request.status != CreditRequestStatus.disbursed) {
      throw StateError('Ce crédit ne peut pas être remboursé.');
    }

    if (!amount.isFinite || amount <= 0) {
      throw ArgumentError('Montant de remboursement invalide.');
    }
    final roundedAmount = (amount * 100).roundToDouble() / 100;
    if (!roundedAmount.isFinite ||
        roundedAmount <= 0 ||
        roundedAmount > request.outstandingAmount) {
      throw ArgumentError('Montant de remboursement invalide.');
    }
    if (password.isEmpty) return PasswordVerificationResult.rejected;
    if (!_processingRequestIds.add(requestId)) {
      throw StateError('Une opération est déjà en cours pour ce crédit.');
    }

    try {
      final verification = await passwordVerifier.verifyPassword(
        userId: userId,
        password: password,
      );
      if (verification != PasswordVerificationResult.verified) {
        return verification;
      }

      final currentIndex = _requests.indexWhere(
        (item) => item.id == requestId && item.userId == userId,
      );
      if (currentIndex < 0 ||
          _requests[currentIndex].status != CreditRequestStatus.disbursed) {
        throw StateError('Ce crédit ne peut plus être remboursé.');
      }
      final currentRequest = _requests[currentIndex];
      if (roundedAmount > currentRequest.outstandingAmount) {
        throw StateError('Le remboursement dépasse le solde restant dû.');
      }
      wallet.repayLoan(
        userId: userId,
        currency: currentRequest.currency,
        amount: roundedAmount,
      );
      final repaidAmount =
          ((currentRequest.repaidAmount + roundedAmount) * 100)
              .roundToDouble() /
          100;
      _requests[currentIndex] = currentRequest.copyWith(
        repaidAmount: repaidAmount,
        status: repaidAmount >= currentRequest.amount
            ? CreditRequestStatus.repaid
            : CreditRequestStatus.disbursed,
      );
      return PasswordVerificationResult.verified;
    } finally {
      _processingRequestIds.remove(requestId);
    }
  }
}

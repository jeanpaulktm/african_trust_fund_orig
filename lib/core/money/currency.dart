enum Currency {
  usd(code: 'USD', label: 'Dollar américain', symbol: r'$'),
  cdf(code: 'CDF', label: 'Franc congolais', symbol: 'FC');

  const Currency({
    required this.code,
    required this.label,
    required this.symbol,
  });

  final String code;
  final String label;
  final String symbol;

  String format(double amount) {
    final fixed = amount.toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = parts.first;
    final grouped = StringBuffer();
    for (var index = 0; index < whole.length; index++) {
      if (index > 0 && (whole.length - index) % 3 == 0) {
        grouped.write(' ');
      }
      grouped.write(whole[index]);
    }
    return '$grouped,${parts.last} $code';
  }
}

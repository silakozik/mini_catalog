// 2499 -> "$2,499" (binlik ayırıcılı dolar metni)
String formatPrice(double value) {
  final digits = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return '\$$buffer';
}
import 'dart:math';


String customPhoneNumber(String phoneNumber) {
  final chunks = <String>[];
  for (var i = 0; i < phoneNumber.length; i += 4) {
    chunks.add(phoneNumber.substring(i, min(i + 4, phoneNumber.length)));
  }
  return chunks.join(' ');
}

import 'dart:typed_data';

class Mandataire {
  const Mandataire({
    required this.fullName,
    required this.contact,
    required this.relationship,
    this.email = '',
    this.identityNumber = '',
    this.identityDocumentPages = const [],
  });

  final String fullName;
  final String contact;
  final String relationship;
  final String email;
  final String identityNumber;
  final List<Uint8List> identityDocumentPages;
}

import 'dart:typed_data';

class Mandataire {
  const Mandataire({
    required this.fullName,
    required this.contact,
    required this.relationship,
    required this.identityDocumentPath,
    this.identityDocumentBytes,
  });

  final String fullName;
  final String contact;
  final String relationship;
  final String identityDocumentPath;
  final Uint8List? identityDocumentBytes;
}

import 'package:african/features/auth/domain/models/mandataire.dart';
import 'package:african/features/auth/domain/models/user.dart';
import 'package:african/features/profile/presentation/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('profile displays registered contact and address details', (
    tester,
  ) async {
    final user = User(
      id: 'client',
      lastName: 'Test',
      postName: 'Demo',
      firstName: 'Client',
      email: 'client@example.cd',
      dateOfBirth: DateTime(1995, 6, 12),
      identityNumber: 'ID-TEST',
      profilePhotoPath: '',
      identityFrontPath: '',
      identityBackPath: '',
      phoneNumber: '+243 900 000 000',
      city: 'Kinshasa',
      commune: 'Gombe',
      neighborhood: 'Centre',
      cell: 'Cellule 1',
      houseNumber: '10A',
      passwordHash: 'pending-server-authentication',
      mandataire: const Mandataire(
        fullName: 'Mandataire Test',
        contact: '000',
        relationship: 'Proche',
        identityDocumentPath: '',
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfilePage(user: user, onSignOut: () {}),
        ),
      ),
    );

    expect(find.text('+243 900 000 000'), findsOneWidget);
    expect(find.text('Kinshasa'), findsOneWidget);
    expect(find.text('Gombe'), findsOneWidget);
    expect(find.text('Centre'), findsOneWidget);
    expect(find.text('Cellule 1'), findsOneWidget);
    expect(find.text('10A'), findsOneWidget);
  });
}

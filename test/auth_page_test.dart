import 'package:african/features/auth/presentation/auth_page.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeScanner extends CunningDocumentScannerPlatform {
  _FakeScanner(this.paths);

  final List<String> paths;
  final calls = <ScannerSource>[];
  bool cancel = false;
  bool deny = false;

  @override
  Future<ScanResult?> scanDocuments({
    required int noOfPages,
    required ScannerSource scannerSource,
    required ScanOutput output,
    required AndroidScannerMode androidScannerMode,
    IosScannerOptions? iosScannerOptions,
  }) async {
    expect(noOfPages, 2);
    expect(output, ScanOutput.images);
    calls.add(scannerSource);
    if (deny) throw const CunningDocumentScannerException.permissionDenied();
    return cancel ? null : ScanResult(images: paths);
  }

  @override
  Future<void> cleanCache() async {}
}

void main() {
  testWidgets('registration rejects matching client and proxy details', (
    tester,
  ) async {
    var registered = false;
    await tester.pumpWidget(
      MaterialApp(
        home: AuthPage(
          onClientLogin: (_) {},
          onAdminLogin: () {},
          onRegister: (_) => registered = true,
        ),
      ),
    );
    await tester.tap(find.text('Nouveau client ? Créer un compte'));
    await tester.pumpAndSettle();

    Finder field(String label) => find.ancestor(
      of: find.text(label),
      matching: find.byType(TextFormField),
    );

    Future<void> enter(String label, String value) async {
      await tester.ensureVisible(field(label));
      await tester.enterText(field(label), value);
      await tester.pump();
    }

    await enter('Adresse e-mail', 'Client@example.com');
    await enter('N° carte d’identité ou NIF', 'id-123');
    await enter('Numéro de téléphone', '+243 812 345 678');
    await enter('Mot de passe', 'weakpass');
    await enter('Téléphone du mandataire', '00243812345678');
    await enter('E-mail du mandataire', ' client@EXAMPLE.com ');
    await enter('N° carte d’identité ou NIF du mandataire', 'ID123');
    await tester.ensureVisible(find.text('Créer mon compte'));
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Le téléphone doit être différent'),
      findsOneWidget,
    );
    expect(find.textContaining('L’e-mail doit être différent'), findsOneWidget);
    expect(
      find.textContaining('La pièce doit être différente'),
      findsOneWidget,
    );
    expect(find.textContaining('8 caractères minimum, avec'), findsOneWidget);
    expect(registered, isFalse);

    await enter('Mot de passe', 'Abcdef1!');
    await enter('Téléphone du mandataire', '+243 812 345 679');
    await enter('E-mail du mandataire', 'agent@example.com');
    await enter('N° carte d’identité ou NIF du mandataire', 'ID124');
    await tester.ensureVisible(find.text('Créer mon compte'));
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Le téléphone doit être différent'),
      findsNothing,
    );
    expect(find.textContaining('L’e-mail doit être différent'), findsNothing);
    expect(find.textContaining('La pièce doit être différente'), findsNothing);
    expect(find.textContaining('8 caractères minimum, avec'), findsNothing);
    expect(registered, isFalse);
  });

  testWidgets('a minor can choose a birthday and receives a recommendation', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AuthPage(
          onClientLogin: (_) {},
          onAdminLogin: () {},
          onRegister: (_) {},
        ),
      ),
    );
    await tester.tap(find.text('Nouveau client ? Créer un compte'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Date de naissance'));
    await tester.tap(find.text('Date de naissance'));
    await tester.pumpAndSettle();

    final today = DateTime.now();
    final birthday = DateTime(today.year - 17, today.month, today.day);
    final dialog = find.byType(DatePickerDialog);
    final dateText = MaterialLocalizations.of(tester.element(dialog))
        .formatCompactDate(birthday);
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(of: dialog, matching: find.byType(TextFormField)),
      dateText,
    );
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('recommandée à partir de 18 ans'),
      findsOneWidget,
    );
  });

  testWidgets('registration screen exposes client and mandatory proxy fields', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AuthPage(
          onClientLogin: (_) {},
          onAdminLogin: () {},
          onRegister: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Nouveau client ? Créer un compte'));
    await tester.pumpAndSettle();

    expect(find.text('Vos informations'), findsOneWidget);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -350),
    );
    await tester.pumpAndSettle();
    expect(find.text('Téléphone et adresse'), findsOneWidget);
    expect(find.text('Numéro de téléphone'), findsOneWidget);
    expect(find.text('Ville'), findsOneWidget);
    expect(find.text('Commune'), findsOneWidget);
    expect(find.text('Quartier'), findsOneWidget);
    expect(find.text('Cellule'), findsOneWidget);
    expect(find.text('Numéro de maison'), findsOneWidget);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -700),
    );
    await tester.pumpAndSettle();
    expect(find.text('Photo de profil et pièce d’identité'), findsOneWidget);
    expect(find.text('Photo de profil'), findsOneWidget);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -250),
    );
    await tester.pumpAndSettle();
    expect(find.text('Pièce d’identité du client'), findsOneWidget);
    expect(find.text('Recto de la pièce'), findsNothing);
    expect(find.text('Verso de la pièce'), findsNothing);
    expect(
      find.text('Scannez jusqu’au recto et verso'),
      findsAtLeastNWidgets(1),
    );
    expect(find.text('Scanner'), findsAtLeastNWidgets(1));
    expect(find.text('Photo de profil (nom du fichier)'), findsNothing);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -900),
    );
    await tester.pumpAndSettle();
    expect(find.text('Votre mandataire'), findsOneWidget);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    expect(find.text('Pièce d’identité du mandataire'), findsOneWidget);
    expect(find.text('Scanner'), findsAtLeastNWidgets(1));
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();
    expect(find.text('Créer mon compte'), findsOneWidget);
  });

  testWidgets('identity scan requests camera and reports permission errors', (
    tester,
  ) async {
    final original = CunningDocumentScannerPlatform.instance;
    final scanner = _FakeScanner([]);
    CunningDocumentScannerPlatform.instance = scanner;
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() {
      CunningDocumentScannerPlatform.instance = original;
      debugDefaultTargetPlatformOverride = null;
    });

    await tester.pumpWidget(
      MaterialApp(
        home: AuthPage(
          onClientLogin: (_) {},
          onAdminLogin: () {},
          onRegister: (_) {},
        ),
      ),
    );
    await tester.tap(find.text('Nouveau client ? Créer un compte'));
    await tester.pumpAndSettle();

    final client = find.byKey(const ValueKey('client-identity-scanner'));
    final agent = find.byKey(const ValueKey('agent-identity-scanner'));
    final scrollable = find
        .descendant(
          of: find.byKey(const ValueKey('registration')),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(client, 300, scrollable: scrollable);
    await tester.pumpAndSettle();
    scanner.cancel = true;
    await tester.tap(
      find.descendant(of: client, matching: find.text('Scanner')),
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: client, matching: find.text('Scanner')),
      findsOneWidget,
    );

    scanner.cancel = false;
    scanner.deny = true;
    await tester.scrollUntilVisible(agent, 300, scrollable: scrollable);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: agent, matching: find.text('Scanner')),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Autorisez l’accès à la caméra pour scanner la pièce.'),
      findsOneWidget,
    );
    expect(scanner.calls, everyElement(ScannerSource.camera));
    expect(scanner.calls, hasLength(2));
    debugDefaultTargetPlatformOverride = null;
  });
}

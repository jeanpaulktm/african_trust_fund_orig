import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/atf_logo.dart';
import '../../auth/domain/models/user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user, required this.onSignOut});

  final User user;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    const heroForeground = Colors.white;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: context.isDarkMode
                  ? const [Color(0xFF243665), Color(0xFF111A3A)]
                  : const [Color(0xFF087A52), Color(0xFF20A66F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              const AtfLogo(width: 188, height: 66),
              const SizedBox(height: 17),
              CircleAvatar(
                radius: 39,
                backgroundColor: heroForeground.withValues(alpha: 0.18),
                backgroundImage: user.profilePhotoBytes == null
                    ? null
                    : MemoryImage(user.profilePhotoBytes!),
                child: user.profilePhotoBytes == null
                    ? Text(
                        _initials(user),
                        style: TextStyle(
                          color: heroForeground,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 13),
              Text(
                user.fullName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: heroForeground,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                user.email,
                style: TextStyle(color: heroForeground.withValues(alpha: 0.82)),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: heroForeground.withValues(alpha: 0.17),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Compte client',
                  style: TextStyle(
                    color: heroForeground,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _ProfileHeading(title: 'Informations personnelles'),
        const SizedBox(height: 10),
        _ProfileCard(
          children: [
            _ProfileRow(label: 'Nom complet', value: user.fullName),
            _ProfileRow(label: 'E-mail', value: user.email),
            _ProfileRow(label: 'Téléphone', value: user.phoneNumber),
            _ProfileRow(
              label: 'Date de naissance',
              value:
                  '${user.dateOfBirth.day.toString().padLeft(2, '0')}/'
                  '${user.dateOfBirth.month.toString().padLeft(2, '0')}/'
                  '${user.dateOfBirth.year}',
            ),
            _ProfileRow(label: 'N° identité / NIF', value: user.identityNumber),
            _ProfileRow(label: 'Ville', value: user.city),
            _ProfileRow(label: 'Commune', value: user.commune),
            _ProfileRow(label: 'Quartier', value: user.neighborhood),
            _ProfileRow(label: 'Cellule', value: user.cell),
            _ProfileRow(
              label: 'Numéro de maison',
              value: user.houseNumber,
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 21),
        const _ProfileHeading(title: 'Mandataire du compte'),
        const SizedBox(height: 10),
        _ProfileCard(
          children: [
            _ProfileRow(label: 'Nom', value: user.mandataire.fullName),
            _ProfileRow(label: 'Contact', value: user.mandataire.contact),
            _ProfileRow(
              label: 'Lien',
              value: user.mandataire.relationship,
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 21),
        const _ProfileHeading(title: 'Vérification KYC'),
        const SizedBox(height: 10),
        _ProfileCard(
          children: [
            _DocumentStatus(
              label: 'Photo de profil',
              fileName: user.profilePhotoPath,
              imageBytes: user.profilePhotoBytes,
            ),
            _DocumentStatus(
              label: 'Pièce d’identité recto',
              fileName: user.identityFrontPath,
              imageBytes: user.identityFrontBytes,
            ),
            _DocumentStatus(
              label: 'Pièce d’identité verso',
              fileName: user.identityBackPath,
              imageBytes: user.identityBackBytes,
            ),
            _DocumentStatus(
              label: 'Pièce du mandataire',
              fileName: user.mandataire.identityDocumentPath,
              imageBytes: user.mandataire.identityDocumentBytes,
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: onSignOut,
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Se déconnecter'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            minimumSize: const Size.fromHeight(50),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }

  static String _initials(User user) {
    final names = [
      user.firstName,
      user.lastName,
    ].where((name) => name.isNotEmpty).toList();
    return names.map((name) => name[0].toUpperCase()).join();
  }
}

class _ProfileHeading extends StatelessWidget {
  const _ProfileHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    ),
  );
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(children: children),
  );
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: Text(
                value.isEmpty ? 'Non renseigné' : value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      if (showDivider)
        Divider(color: Theme.of(context).colorScheme.outlineVariant),
    ],
  );
}

class _DocumentStatus extends StatelessWidget {
  const _DocumentStatus({
    required this.label,
    required this.fileName,
    required this.imageBytes,
    this.showDivider = true,
  });

  final String label;
  final String fileName;
  final Uint8List? imageBytes;
  final bool showDivider;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Container(
                width: 40,
                height: 40,
                color: Theme.of(context).colorScheme.primaryContainer,
                child: imageBytes == null
                    ? Icon(
                        Icons.description_outlined,
                        color: Theme.of(context).colorScheme.primary,
                        size: 19,
                      )
                    : Image.memory(imageBytes!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    fileName.isEmpty ? 'Aucun fichier' : fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 7),
            Icon(
              Icons.check_circle_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 18,
            ),
          ],
        ),
      ),
      if (showDivider)
        Divider(color: Theme.of(context).colorScheme.outlineVariant),
    ],
  );
}

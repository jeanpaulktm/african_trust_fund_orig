import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/atf_logo.dart';
import '../../../core/widgets/gradient_button.dart';
import '../domain/models/mandataire.dart';
import '../domain/models/user.dart';
import '../domain/registration_validation.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({
    super.key,
    required this.onClientLogin,
    required this.onAdminLogin,
    required this.onRegister,
    this.isDark = false,
    this.onToggleTheme,
  });

  final ValueChanged<String> onClientLogin;
  final VoidCallback onAdminLogin;
  final ValueChanged<User> onRegister;
  final bool isDark;
  final VoidCallback? onToggleTheme;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _registering = false;
  final _loginFormKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: _registering
              ? _RegistrationForm(
                  key: const ValueKey('registration'),
                  onBack: () => setState(() => _registering = false),
                  onRegister: widget.onRegister,
                )
              : _buildLogin(),
        ),
      ),
    );
  }

  Widget _buildLogin() {
    return ListView(
      key: const ValueKey('login'),
      padding: const EdgeInsets.fromLTRB(26, 42, 26, 30),
      children: [
        Row(
          children: [
            const AtfLogo(width: 156, height: 52),
            const Spacer(),
            IconButton.filledTonal(
              tooltip: widget.isDark
                  ? 'Activer le mode clair'
                  : 'Activer le mode sombre',
              onPressed: widget.onToggleTheme,
              icon: Icon(
                widget.isDark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 34),
        Text(
          'Bienvenue chez vous',
          style: TextStyle(
            color: context.appText,
            fontSize: 27,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Connectez-vous pour gérer votre argent en toute simplicité.',
          style: TextStyle(color: context.appMuted, height: 1.5),
        ),
        const SizedBox(height: 28),
        Form(
          key: _loginFormKey,
          child: Column(
            children: [
              _InputField(
                controller: _email,
                label: 'Adresse e-mail',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value != null && value.contains('@')
                    ? null
                    : 'E-mail invalide.',
              ),
              const SizedBox(height: 14),
              _InputField(
                controller: _password,
                label: 'Mot de passe',
                icon: Icons.lock_outline_rounded,
                obscureText: true,
                validator: (value) => value != null && value.length >= 6
                    ? null
                    : '6 caractères minimum.',
              ),
              const SizedBox(height: 24),
              GradientButton(
                label: 'Se connecter',
                icon: Icons.arrow_forward_rounded,
                onPressed: () {
                  if (_loginFormKey.currentState!.validate()) {
                    widget.onClientLogin(_email.text.trim());
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: TextButton(
            onPressed: () => setState(() => _registering = true),
            child: Text(
              'Nouveau client ? Créer un compte',
              style: TextStyle(
                color: context.appAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: widget.onAdminLogin,
          icon: const Icon(Icons.admin_panel_settings_outlined),
          label: const Text('Espace administrateur (démo)'),
          style: OutlinedButton.styleFrom(
            foregroundColor: context.appText,
            minimumSize: const Size.fromHeight(50),
            side: BorderSide(color: context.appBorder),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Prototype local : les identifiants ne sont pas authentifiés par un serveur.',
          textAlign: TextAlign.center,
          style: TextStyle(color: context.appMuted, fontSize: 11),
        ),
      ],
    );
  }
}

class _RegistrationForm extends StatefulWidget {
  const _RegistrationForm({
    super.key,
    required this.onBack,
    required this.onRegister,
  });

  final VoidCallback onBack;
  final ValueChanged<User> onRegister;

  @override
  State<_RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<_RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = List.generate(17, (_) => TextEditingController());
  final _imagePicker = ImagePicker();
  DateTime? _dateOfBirth;
  _PickedImage? _profileImage;
  _ScannedDocument? _identityDocument;
  _ScannedDocument? _agentIdentityDocument;
  String? _imageError;
  String? _dateError;
  bool _obscurePassword = true;
  bool _scanningDocument = false;

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController get _lastName => _controllers[0];
  TextEditingController get _postName => _controllers[1];
  TextEditingController get _firstName => _controllers[2];
  TextEditingController get _email => _controllers[3];
  TextEditingController get _identity => _controllers[4];
  TextEditingController get _phone => _controllers[5];
  TextEditingController get _city => _controllers[6];
  TextEditingController get _commune => _controllers[7];
  TextEditingController get _neighborhood => _controllers[8];
  TextEditingController get _cell => _controllers[9];
  TextEditingController get _houseNumber => _controllers[10];
  TextEditingController get _password => _controllers[11];
  TextEditingController get _agentName => _controllers[12];
  TextEditingController get _agentContact => _controllers[13];
  TextEditingController get _agentRelation => _controllers[14];
  TextEditingController get _agentEmail => _controllers[15];
  TextEditingController get _agentIdentity => _controllers[16];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        key: const ValueKey('registration'),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          children: [
            Row(
              children: [
                IconButton.filledTonal(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: context.appAccentSoft,
                    foregroundColor: context.appAccent,
                  ),
                ),
                const Spacer(),
                const AtfLogo(width: 142, height: 48),
              ],
            ),
            const SizedBox(height: 16),
            const _RegistrationHero(),
            const SizedBox(height: 20),
            _RegistrationSection(
              number: '01',
              title: 'Vos informations',
              subtitle: 'Elles nous permettent de créer votre compte.',
              icon: Icons.person_outline_rounded,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _InputField(
                        controller: _lastName,
                        label: 'Nom',
                        validator: _required,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _InputField(
                        controller: _postName,
                        label: 'Post-nom',
                        validator: _required,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _InputField(
                  controller: _firstName,
                  label: 'Prénom',
                  validator: _required,
                ),
                const SizedBox(height: 12),
                _InputField(
                  controller: _email,
                  label: 'Adresse e-mail',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: validateRegistrationEmail,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _chooseBirthDate,
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: Text(
                    _dateOfBirth == null
                        ? 'Date de naissance'
                        : '${_dateOfBirth!.day.toString().padLeft(2, '0')}/'
                              '${_dateOfBirth!.month.toString().padLeft(2, '0')}/'
                              '${_dateOfBirth!.year}',
                  ),
                  style: _outlineStyle,
                ),
                if (_dateError != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    _dateError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ],
                if (_dateOfBirth != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    ageOnDate(_dateOfBirth!, DateTime.now()) < 18
                        ? 'Âge : ${ageOnDate(_dateOfBirth!, DateTime.now())} ans. L’inscription est recommandée à partir de 18 ans.'
                        : 'Âge : ${ageOnDate(_dateOfBirth!, DateTime.now())} ans.',
                    style: TextStyle(color: context.appMuted, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 12),
                _InputField(
                  controller: _identity,
                  label: 'N° carte d’identité ou NIF',
                  icon: Icons.badge_outlined,
                  validator: _required,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _RegistrationSection(
              number: '02',
              title: 'Téléphone et adresse',
              subtitle:
                  'Le téléphone sera utilisé pour vos transactions en ligne.',
              icon: Icons.location_on_outlined,
              children: [
                _InputField(
                  controller: _phone,
                  label: 'Numéro de téléphone',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: validateRegistrationPhone,
                ),
                const SizedBox(height: 12),
                _InputField(
                  controller: _city,
                  label: 'Ville',
                  icon: Icons.location_city_outlined,
                  validator: _required,
                ),
                const SizedBox(height: 12),
                _InputField(
                  controller: _commune,
                  label: 'Commune',
                  validator: _required,
                ),
                const SizedBox(height: 12),
                _InputField(
                  controller: _neighborhood,
                  label: 'Quartier',
                  validator: _required,
                ),
                const SizedBox(height: 12),
                _InputField(
                  controller: _cell,
                  label: 'Cellule',
                  validator: _required,
                ),
                const SizedBox(height: 12),
                _InputField(
                  controller: _houseNumber,
                  label: 'Numéro de maison',
                  icon: Icons.home_outlined,
                  validator: _required,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _RegistrationSection(
              number: '03',
              title: 'Photo de profil et pièce d’identité',
              subtitle: 'Scannez votre pièce avec la caméra du téléphone.',
              icon: Icons.verified_user_outlined,
              children: [
                _ProfilePhotoPicker(
                  image: _profileImage,
                  hasError: _imageError != null && _profileImage == null,
                  onTap: () => _pickImage(
                    (image) => setState(() {
                      _profileImage = image;
                      _imageError = null;
                    }),
                  ),
                  onRemove: _profileImage == null
                      ? null
                      : () => setState(() => _profileImage = null),
                ),
                const SizedBox(height: 15),
                _DocumentScannerCard(
                  key: const ValueKey('client-identity-scanner'),
                  title: 'Pièce d’identité du client',
                  document: _identityDocument,
                  hasError: _imageError != null && _identityDocument == null,
                  isScanning: _scanningDocument,
                  onScan: () => _scanDocument(
                    (document) => setState(() {
                      _identityDocument = document;
                      _imageError = null;
                    }),
                  ),
                  onRemove: _identityDocument == null
                      ? null
                      : () => setState(() => _identityDocument = null),
                ),
                const SizedBox(height: 16),
                _InputField(
                  controller: _password,
                  label: 'Mot de passe',
                  icon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  suffix: IconButton(
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                  validator: validateRegistrationPassword,
                ),
                const SizedBox(height: 6),
                Text(
                  '8 caractères minimum : majuscule, minuscule, chiffre et symbole.',
                  style: TextStyle(color: context.appMuted, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _RegistrationSection(
              number: '04',
              title: 'Votre mandataire',
              subtitle: 'Personne de confiance liée à votre compte.',
              icon: Icons.people_outline_rounded,
              children: [
                _InputField(
                  controller: _agentName,
                  label: 'Nom complet du mandataire',
                  validator: _required,
                ),
                const SizedBox(height: 12),
                _InputField(
                  controller: _agentContact,
                  label: 'Téléphone du mandataire',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    final error = validateRegistrationPhone(value);
                    if (error != null) return error;
                    if (normalizePhone(value!) == normalizePhone(_phone.text)) {
                      return 'Le téléphone doit être différent de celui du client.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _InputField(
                  controller: _agentEmail,
                  label: 'E-mail du mandataire',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final error = validateRegistrationEmail(value);
                    if (error != null) return error;
                    if (value!.trim().toLowerCase() ==
                        _email.text.trim().toLowerCase()) {
                      return 'L’e-mail doit être différent de celui du client.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _InputField(
                  controller: _agentIdentity,
                  label: 'N° carte d’identité ou NIF du mandataire',
                  icon: Icons.badge_outlined,
                  validator: (value) {
                    final error = _required(value);
                    if (error != null) return error;
                    if (normalizeIdentityNumber(value!) ==
                        normalizeIdentityNumber(_identity.text)) {
                      return 'La pièce doit être différente de celle du client.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _InputField(
                  controller: _agentRelation,
                  label: 'Lien avec le client',
                  validator: _required,
                ),
                const SizedBox(height: 16),
                _DocumentScannerCard(
                  key: const ValueKey('agent-identity-scanner'),
                  title: 'Pièce d’identité du mandataire',
                  document: _agentIdentityDocument,
                  hasError:
                      _imageError != null && _agentIdentityDocument == null,
                  isScanning: _scanningDocument,
                  onScan: () => _scanDocument(
                    (document) => setState(() {
                      _agentIdentityDocument = document;
                      _imageError = null;
                    }),
                  ),
                  onRemove: _agentIdentityDocument == null
                      ? null
                      : () => setState(() => _agentIdentityDocument = null),
                ),
                if (_imageError != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _imageError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            GradientButton(
              label: 'Créer mon compte',
              icon: Icons.check_circle_outline_rounded,
              onPressed: _submit,
            ),
            const SizedBox(height: 14),
            Text(
              'Les pièces sont scannées par la caméra et conservées uniquement '
              'dans cette démo. Elles ne sont pas envoyées à un serveur.',
              textAlign: TextAlign.center,
              style: TextStyle(color: context.appMuted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle get _outlineStyle => OutlinedButton.styleFrom(
    foregroundColor: Theme.of(context).colorScheme.primary,
    minimumSize: const Size.fromHeight(50),
    alignment: Alignment.centerLeft,
    side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  );

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Champ obligatoire.' : null;

  Future<void> _pickImage(ValueChanged<_PickedImage> onPicked) async {
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 86,
        maxWidth: 1800,
      );
      if (file == null || !mounted) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      onPicked(_PickedImage(file: file, bytes: bytes));
    } on Exception catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible de charger cette image : $error')),
      );
    }
  }

  Future<void> _scanDocument(ValueChanged<_ScannedDocument> onScanned) async {
    if (_scanningDocument) return;
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Le scan de documents est disponible sur Android et iOS uniquement.',
          ),
        ),
      );
      return;
    }
    setState(() => _scanningDocument = true);
    try {
      final result = await CunningDocumentScanner.scanDocuments(
        noOfPages: 2,
        scannerSource: ScannerSource.camera,
        output: ScanOutput.images,
      );
      if (result == null) return;
      if (result.images.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Le scan ne contient aucune page.')),
          );
        }
        return;
      }
      final pages = <_PickedImage>[];
      for (final path in result.images) {
        final file = XFile(path);
        pages.add(_PickedImage(file: file, bytes: await file.readAsBytes()));
      }
      if (!mounted || pages.isEmpty) return;
      onScanned(_ScannedDocument(pages: pages));
      if (result.discardedPages > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${result.discardedPages} page(s) au-delà de la limite de 2 n’ont pas été conservées.',
            ),
          ),
        );
      }
    } on CunningDocumentScannerException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.code == 'permission_denied'
                ? 'Autorisez l’accès à la caméra pour scanner la pièce.'
                : 'Le scan du document a échoué : ${error.message}',
          ),
        ),
      );
    } on Exception catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible de scanner la pièce : $error')),
      );
    } finally {
      if (mounted) setState(() => _scanningDocument = false);
    }
  }

  Future<void> _chooseBirthDate() async {
    final today = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(today.year - 20, today.month, today.day),
      firstDate: DateTime(1900),
      lastDate: DateTime(today.year, today.month, today.day),
      helpText: 'Date de naissance',
    );
    if (date != null) {
      setState(() {
        _dateOfBirth = date;
        _dateError = null;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_dateOfBirth == null) {
      setState(() => _dateError = 'Choisissez votre date de naissance.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La date de naissance est obligatoire.')),
      );
      return;
    }
    if (_profileImage == null ||
        _identityDocument == null ||
        _agentIdentityDocument == null) {
      setState(() {
        _imageError =
            'Ajoutez votre photo de profil et scannez les pièces d’identité '
            'du client et du mandataire.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La photo de profil et les deux pièces scannées sont obligatoires.',
          ),
        ),
      );
      return;
    }

    final user = User(
      id: 'client-${DateTime.now().microsecondsSinceEpoch}',
      lastName: _lastName.text.trim(),
      postName: _postName.text.trim(),
      firstName: _firstName.text.trim(),
      email: _email.text.trim(),
      dateOfBirth: _dateOfBirth!,
      identityNumber: _identity.text.trim(),
      phoneNumber: _phone.text.trim(),
      city: _city.text.trim(),
      commune: _commune.text.trim(),
      neighborhood: _neighborhood.text.trim(),
      cell: _cell.text.trim(),
      houseNumber: _houseNumber.text.trim(),
      profilePhotoPath: _profileImage!.file.path,
      profilePhotoBytes: _profileImage!.bytes,
      identityDocumentPages: _identityDocument!.pages
          .map((page) => page.bytes)
          .toList(),
      passwordHash: 'pending-server-authentication',
      mandataire: Mandataire(
        fullName: _agentName.text.trim(),
        contact: _agentContact.text.trim(),
        email: _agentEmail.text.trim(),
        identityNumber: _agentIdentity.text.trim(),
        relationship: _agentRelation.text.trim(),
        identityDocumentPages: _agentIdentityDocument!.pages
            .map((page) => page.bytes)
            .toList(),
      ),
    );
    widget.onRegister(user);
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.label,
    this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
        suffixIcon: suffix,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class _PickedImage {
  const _PickedImage({required this.file, required this.bytes});

  final XFile file;
  final Uint8List bytes;
}

class _ScannedDocument {
  const _ScannedDocument({required this.pages});

  final List<_PickedImage> pages;
}

class _RegistrationHero extends StatelessWidget {
  const _RegistrationHero();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: context.isDarkMode
            ? const [Color(0xFFE2B84B), Color(0xFFF4D782)]
            : const [Color(0xFF087A52), Color(0xFF20A66F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(26),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.18),
          blurRadius: 22,
          offset: Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary
                .withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'INSCRIPTION CLIENT',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 17),
        Text(
          'Un compte pensé\npour vos projets.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 26,
            height: 1.12,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          'Complétez vos informations et ajoutez des photos lisibles de vos documents.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary
                .withValues(alpha: 0.82),
            fontSize: 12,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 19),
        const Row(
          children: [
            _ProgressDot(label: 'Profil', active: true),
            _ProgressLine(),
            _ProgressDot(label: 'Identité', active: true),
            _ProgressLine(),
            _ProgressDot(label: 'Mandataire', active: true),
          ],
        ),
      ],
    ),
  );
}

class _ProgressDot extends StatelessWidget {
  const _ProgressDot({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.check_circle_rounded,
        color: active
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.54),
        size: 15,
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine();

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.38),
    ),
  );
}

class _RegistrationSection extends StatelessWidget {
  const _RegistrationSection({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
  });

  final String number;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.04),
          blurRadius: 16,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              number,
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 17),
        ...children,
      ],
    ),
  );
}

class _ProfilePhotoPicker extends StatelessWidget {
  const _ProfilePhotoPicker({
    required this.image,
    required this.hasError,
    required this.onTap,
    required this.onRemove,
  });

  final _PickedImage? image;
  final bool hasError;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(
        color: hasError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.outlineVariant,
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primaryContainer,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary
                  .withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: image == null
              ? Icon(
                  Icons.person_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 31,
                )
              : Image.memory(image!.bytes, fit: BoxFit.cover),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Photo de profil',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                image?.file.name ?? 'Ajoutez une photo récente',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 6),
              TextButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.photo_library_outlined, size: 15),
                label: Text(image == null ? 'Choisir une photo' : 'Modifier'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(10, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (onRemove != null)
          IconButton(
            tooltip: 'Supprimer la photo',
            onPressed: onRemove,
            icon: const Icon(Icons.close_rounded, size: 18),
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
      ],
    ),
  );
}

class _DocumentScannerCard extends StatelessWidget {
  const _DocumentScannerCard({
    super.key,
    required this.title,
    required this.document,
    required this.hasError,
    required this.isScanning,
    required this.onScan,
    required this.onRemove,
  });

  final String title;
  final _ScannedDocument? document;
  final bool hasError;
  final bool isScanning;
  final VoidCallback onScan;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstPage = document?.pages.firstOrNull;
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: hasError
              ? theme.colorScheme.error
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 76,
              height: 76,
              color: theme.colorScheme.primaryContainer,
              child: firstPage == null
                  ? Icon(
                      Icons.document_scanner_outlined,
                      color: theme.colorScheme.primary,
                      size: 30,
                    )
                  : Image.memory(firstPage.bytes, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  document == null
                      ? 'Scannez jusqu’au recto et verso'
                      : '${document!.pages.length} page'
                            '${document!.pages.length > 1 ? 's' : ''} scannée'
                            '${document!.pages.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [
                    TextButton.icon(
                      onPressed: isScanning ? null : onScan,
                      icon: isScanning
                          ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(
                              Icons.document_scanner_outlined,
                              size: 16,
                            ),
                      label: Text(
                        isScanning
                            ? 'Ouverture…'
                            : document == null
                            ? 'Scanner'
                            : 'Rescanner',
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(10, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (onRemove != null)
                      TextButton(
                        onPressed: isScanning ? null : onRemove,
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(10, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: const TextStyle(fontSize: 11),
                        ),
                        child: const Text('Supprimer'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

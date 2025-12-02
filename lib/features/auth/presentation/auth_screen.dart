import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speakup_mvp/core/providers/auth_provider.dart';
import '../../../common/constants/app_colors.dart';
import '../../../common/constants/app_routes.dart';
import '../../../common/widgets/primary_button.dart';

/// Écran d'authentification (Connexion / Inscription)

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isLoginMode = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Soumettre le formulaire (connexion ou inscription)
  Future<void> _handleSubmit() async {
    // Valider le formulaire
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Effacer les erreurs précédentes
    ref.read(authProvider.notifier).clearError();

    final authNotifier = ref.read(authProvider.notifier);

    try {
      if (_isLoginMode) {
        // ========== CONNEXION ==========
        await authNotifier.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        // ========== INSCRIPTION ==========
        // Vérifier que les mots de passe correspondent
        if (_passwordController.text != _confirmPasswordController.text) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Les mots de passe ne correspondent pas'),
                backgroundColor: AppColors.error,
              ),
            );
          }
          return;
        }

        await authNotifier.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
        );
      }

      // La redirection se fera automatiquement via le router
      // grâce au redirect dans app.dart
    } catch (e) {
      // Les erreurs sont gérées par le provider
      // Elles s'afficheront via le listener ci-dessous
    }
  }

  @override
  Widget build(BuildContext context) {
    // Écouter l'état d'authentification
    final authState = ref.watch(authProvider);

    // Afficher les erreurs via SnackBar
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
      }

      // Si authentifié, rediriger vers home
      if (next.isAuthenticated && mounted) {
        context.go(AppRoutes.home);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // ========== LOGO & TITRE ==========
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.mic,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'SpeakUp',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimaryLight,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pratique, Améliore-toi, Partage',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // ========== ONGLETS CONNEXION / INSCRIPTION ==========
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTabButton(
                          label: 'Connexion',
                          isSelected: _isLoginMode,
                          onTap: () => setState(() => _isLoginMode = true),
                        ),
                      ),
                      Expanded(
                        child: _buildTabButton(
                          label: 'Inscription',
                          isSelected: !_isLoginMode,
                          onTap: () => setState(() => _isLoginMode = false),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ========== FORMULAIRE ==========

                // Champ Nom (inscription uniquement)
                if (!_isLoginMode) ...[
                  TextFormField(
                    controller: _nameController,
                    enabled: !authState.isLoading,
                    decoration: InputDecoration(
                      labelText: 'Nom complet',
                      hintText: 'Ex: Mamadou Diallo',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Le nom est requis';
                      }
                      if (value.trim().length < 2) {
                        return 'Le nom doit contenir au moins 2 caractères';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Champ Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !authState.isLoading,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'exemple@email.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'L\'email est requis';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Champ Mot de passe
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  enabled: !authState.isLoading,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    hintText: 'Min. 6 caractères',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le mot de passe est requis';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                ),

                // Champ Confirmation (inscription uniquement)
                if (!_isLoginMode) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    enabled: !authState.isLoading,
                    decoration: InputDecoration(
                      labelText: 'Confirmez le mot de passe',
                      hintText: 'Ressaisir le mot de passe',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (!_isLoginMode) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez confirmer le mot de passe';
                        }
                        if (value != _passwordController.text) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 24),

                // ========== BOUTON DE SOUMISSION ==========
                PrimaryButton(
                  text: _isLoginMode ? 'Se connecter' : 'S\'inscrire',
                  onPressed: authState.isLoading ? null : _handleSubmit,
                  isLoading: authState.isLoading,
                ),

                // Lien "Mot de passe oublié"
                if (_isLoginMode) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: authState.isLoading
                          ? null
                          : () => context.go(AppRoutes.resetPassword),
                      child: const Text('Mot de passe oublié ?'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget pour les onglets
  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondaryLight,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/constants/app_colors.dart';
import '../../../common/widgets/primary_button.dart';

/// Écran 1 : Authentification (Connexion / Inscription)
///
/// Cet écran permet à l'utilisateur de :
/// - Se connecter avec email/mot de passe
/// - S'inscrire (créer un compte)
/// - Réinitialiser son mot de passe (TODO: à implémenter)
///
/// TODO SUPABASE (pour ton collègue) :
/// - Implémenter la connexion avec Supabase Auth: supabase.auth.signInWithPassword()
/// - Implémenter l'inscription avec Supabase Auth: supabase.auth.signUp()
/// - Gérer les erreurs d'authentification
/// - Rediriger vers HomeScreen après connexion réussie
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  // Contrôle si on affiche l'écran de connexion (true) ou d'inscription (false)
  bool _isLoginMode = true;

  // Contrôleurs pour récupérer le texte des champs
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController =
      TextEditingController(); // Uniquement pour l'inscription
  final _confirmPasswordController =
      TextEditingController(); // Confirmation (inscription)

  // Clé pour valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // État de chargement (pendant l'authentification)
  bool _isLoading = false;

  @override
  void dispose() {
    // Nettoyer les contrôleurs quand l'écran est détruit
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Fonction appelée lors de la soumission du formulaire
  ///
  /// TODO SUPABASE : Remplacer la logique fictive par les appels Supabase
  Future<void> _handleSubmit() async {
    // Valider le formulaire
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO SUPABASE : Implémenter l'authentification réelle
      if (_isLoginMode) {
        // ==================== CONNEXION ====================
        // Code à implémenter :
        // final response = await Supabase.instance.client.auth.signInWithPassword(
        //   email: _emailController.text.trim(),
        //   password: _passwordController.text,
        // );
        //
        // if (response.user != null) {
        //   // Rediriger vers HomeScreen
        //   if (mounted) {
        //     context.go(AppRoutes.home);
        //   }
        // }

        // Simulation temporaire (2 secondes)
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Connexion simulée réussie')),
          );
          // TODO: Rediriger vers HomeScreen après intégration Supabase
          // context.go(AppRoutes.home);
        }
      } else {
        // ==================== INSCRIPTION ====================
        // Vérifier que les mots de passe correspondent
        if (_passwordController.text != _confirmPasswordController.text) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Les mots de passe ne correspondent pas'),
              ),
            );
          }
          setState(() {
            _isLoading = false;
          });
          return;
        }
        // Code à implémenter :
        // final response = await Supabase.instance.client.auth.signUp(
        //   email: _emailController.text.trim(),
        //   password: _passwordController.text,
        //   data: {'name': _nameController.text.trim()},
        // );
        //
        // if (response.user != null) {
        //   // Créer le profil utilisateur dans la table 'users'
        //   await Supabase.instance.client.from('users').insert({
        //     'id': response.user!.id,
        //     'name': _nameController.text.trim(),
        //     'email': _emailController.text.trim(),
        //   });
        //
        //   // Rediriger vers HomeScreen
        //   if (mounted) {
        //     context.go(AppRoutes.home);
        //   }
        // }

        // Simulation temporaire
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Inscription simulée réussie')),
          );
        }
      }
    } catch (e) {
      // TODO SUPABASE : Gérer les erreurs Supabase (email déjà utilisé, mot de passe faible, etc.)
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Erreur : ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      // TODO: Remplacer par le vrai logo depuis assets/images/
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

                // Champ Nom (uniquement pour inscription)
                if (!_isLoginMode) ...[
                  TextFormField(
                    controller: _nameController,
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
                    // Validation basique de l'email
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

                // Champ Confirmation (uniquement pour inscription)
                if (!_isLoginMode) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
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
                  onPressed: _isLoading ? null : _handleSubmit,
                  isLoading: _isLoading,
                ),

                // Bouton Google
                const SizedBox(height: 16),
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            // TODO: Implémenter la connexion Google via Supabase ou Firebase
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Connexion Google à implémenter'),
                              ),
                            );
                          },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo Google depuis assets
                        Image.asset(
                          'assets/icons/google-g-logo.webp',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Continuer avec Google',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),

                // Lien "Mot de passe oublié" (uniquement en mode connexion)
                if (_isLoginMode) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => context.go('/reset-password'),
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

  /// Widget pour construire un bouton d'onglet (Connexion / Inscription)
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

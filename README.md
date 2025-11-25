# 🎤 SpeakUp MVP - Plateforme de Pratique de Prise de Parole

> Votre voix, votre confiance.

SpeakUp est une application mobile Flutter permettant aux étudiants et professionnels de s'entraîner à la prise de parole en public, de recevoir des feedbacks de la communauté et de progresser grâce à la gamification.

---

## 📋 Table des Matières

- [Aperçu](#aperçu)
- [Fonctionnalités Principales](#fonctionnalités-principales)
- [Stack Technique](#stack-technique)
- [Installation](#installation)
- [Structure du Projet](#structure-du-projet)
- [Design System](#design-system)
- [Roadmap](#roadmap)

---

## 🎯 Aperçu

**Objectif** : Fournir une plateforme mobile unifiée pour la pratique, le feedback et le partage des compétences de prise de parole.

**Cible** : Étudiants (Licence/Master) des universités publiques, membres de clubs/associations, et participants à des incubateurs en Guinée.

**KPI MVP** : Atteindre 500 DAU (utilisateurs actifs quotidiens) et un taux de rétention J30 > 30%.

---

## ✨ Fonctionnalités Principales

### 🎙️ Core Practice (Entraînement Solo)
- Enregistrement audio/vidéo avec chronomètre
- Sujets de pratique quotidiens
- Ambiances sonores (Silent, Salle de classe, Auditorium)
- Statistiques en temps réel (débit, pauses, fillers)
- Conseils personnalisés post-session

### 📊 Feedback & Gamification
- Système XP et niveaux
- Badges de réussite
- Journal de progrès personnel
- Analytics avancés (Premium)

### 👥 Communauté
- Feed communautaire avec publications
- Système de votes (👏 Clap, 👍 Like)
- Commentaires structurés (Liked, Improve, Advice)
- Classements (Top Semaine, Top Mois)
- Modération et signalements

### ⚙️ Fonctionnalités Annexes
- Profils utilisateurs avec avatars
- Recherche de contenu
- Notifications
- Mode clair/sombre automatique

---

## 🛠️ Stack Technique

### Frontend
- **Framework** : Flutter 3.9+ (Dart)
- **State Management** : Riverpod 2.6+
- **Navigation** : GoRouter 14.7+
- **UI** : Material Design 3

### Backend
- **BaaS** : Supabase
  - PostgreSQL (Database)
  - Auth (Authentification)
  - Storage (Médias)
  - Edge Functions (Serverless)

### Média
- **Enregistrement Audio** : record 5.1+
- **Enregistrement Vidéo** : camera 0.11+
- **Compression Vidéo** : ffmpeg_kit_flutter 6.0+
- **Lecture Média** : audioplayers, video_player

### Autres
- **Cache Images** : cached_network_image
- **Stockage Local** : flutter_secure_storage
- **Utils** : intl, uuid, path_provider

---

## 🚀 Installation

### Prérequis
- Flutter SDK 3.9+
- Dart 3.9+
- Android Studio / Xcode (pour émulateurs)
- Compte Supabase

### Étapes

1. **Cloner le projet**
```bash
git clone https://github.com/votre-username/speakup.git
cd speakup
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Télécharger la police Inter**
- Suivez les instructions dans `assets/fonts/README.md`
- Téléchargez depuis : https://fonts.google.com/specimen/Inter
- Copiez les fichiers `.ttf` dans `assets/fonts/`

4. **Configurer Supabase**
- Créez un projet sur https://supabase.com
- Copiez votre URL et clé anonyme
- Ajoutez-les dans `lib/main.dart` :
```dart
await Supabase.initialize(
  url: 'VOTRE_SUPABASE_URL',
  anonKey: 'VOTRE_SUPABASE_ANON_KEY',
);
```

5. **Lancer l'application**
```bash
flutter run
```

---

## 📁 Structure du Projet

```
lib/
├── main.dart                    # Point d'entrée
├── core/                        # Configuration (thème, providers, services)
│   ├── app.dart                 # Configuration app (thème clair/sombre)
│   ├── providers/               # Providers Riverpod globaux
│   └── services/                # Services (auth, API, etc.)
├── common/                      # Éléments réutilisables
│   ├── constants/               # Couleurs, dimensions, styles, routes
│   │   ├── app_colors.dart
│   │   ├── app_dimens.dart
│   │   ├── app_text_styles.dart
│   │   └── app_routes.dart
│   ├── widgets/                 # Widgets réutilisables
│   │   ├── primary_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── custom_app_bar.dart
│   │   └── loading_indicator.dart
│   └── utils/                   # Fonctions utilitaires
│       └── validator.dart
└── features/                    # Modules fonctionnels
    ├── auth/                    # Authentification
    ├── home/                    # Accueil
    ├── practice/                # Entraînement
    ├── community/               # Feed & Communauté
    ├── profile/                 # Profil & Gamification
    └── settings/                # Paramètres
```

---

## 🎨 Design System

### Couleurs
- **Primary** : `#1152D4` (Bleu)
- **Background Light** : `#F6F6F8`
- **Background Dark** : `#101622`
- **Record Button** : `#EF4444` (Rouge)

### Typographie
- **Police** : Inter (Google Fonts)
- **Poids** : Regular (400), Medium (500), SemiBold (600), Bold (700)

### Composants
Tous les widgets sont documentés et réutilisables :
- `PrimaryButton` - Bouton principal
- `CustomTextField` - Champ de saisie
- `CustomAppBar` - Barre d'application
- `LoadingIndicator` - Indicateur de chargement

📖 **Documentation complète** : Voir `DESIGN_SYSTEM_IMPLEMENTATION.md`

---

## 🗓️ Roadmap

### Phase 1 : Fondations ✅
- [x] Design System extrait et implémenté
- [x] Structure du projet
- [x] Configuration des thèmes
- [x] Widgets réutilisables

### Phase 2 : Authentification ⏳
- [ ] Configuration Supabase
- [ ] Écrans Splash & Onboarding
- [ ] Inscription / Connexion
- [ ] Gestion de session

### Phase 3 : Core Practice ⏳
- [ ] Écran d'enregistrement (audio/vidéo)
- [ ] Timer et sélection de durée
- [ ] Ambiances sonores
- [ ] Analyse des statistiques
- [ ] Écran de revue

### Phase 4 : Communauté ⏳
- [ ] Feed communautaire
- [ ] Système de votes
- [ ] Commentaires structurés
- [ ] Publication de contenu
- [ ] Modération

### Phase 5 : Gamification ⏳
- [ ] Système XP/Niveaux
- [ ] Badges
- [ ] Classements
- [ ] Journal de progrès

### Phase 6 : Polish & MVP ⏳
- [ ] Notifications
- [ ] Recherche
- [ ] Paramètres
- [ ] Tests & Debug
- [ ] Déploiement

---

## 📝 Conventions de Code

### Nommage
- **Fichiers** : `snake_case.dart`
- **Classes** : `PascalCase`
- **Variables** : `camelCase`
- **Constantes** : `camelCase` (dans classes statiques)

### Documentation
- Commenter les classes et fonctions publiques
- Utiliser les triple slashes `///` pour la documentation
- Exemples d'utilisation dans les widgets

### Organisation
- Un widget par fichier
- Grouper les imports (dart, packages, projet)
- Respecter la structure des dossiers

---

## 🤝 Contribution

Ce projet est actuellement en développement actif pour le MVP. Les contributions seront ouvertes après la version 1.0.

---

## 📄 Licence

Propriétaire - Tous droits réservés

---

## 📞 Contact

Pour toute question sur le projet :
- **Email** : contact@speakup.app
- **Documentation** : Voir `DESIGN_SYSTEM_IMPLEMENTATION.md`

---

**Développé avec ❤️ pour la communauté étudiante guinéenne**

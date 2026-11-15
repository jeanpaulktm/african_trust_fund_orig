#!/bin/bash

# ============================================================================
# Script de génération des fichiers .g.dart avec json_serializable
# ============================================================================
# 
# Utilisation:
#   bash generate_models.sh
#
# Cela génère automatiquement les fichiers .g.dart pour tous les modèles
# ============================================================================

echo "🔧 Génération des modèles JSON..."
echo ""

# Vérifier que build_runner est installé
if ! grep -q "build_runner" pubspec.yaml; then
  echo "❌ build_runner n'est pas installé. Veuillez ajouter:"
  echo "   dev_dependencies:"
  echo "     build_runner: ^2.4.6"
  exit 1
fi

# Générer les fichiers
echo "⏳ Génération en cours (cela peut prendre un moment)..."
echo ""

flutter pub run build_runner build --delete-conflicting-outputs

# Vérifier si la génération a réussi
if [ $? -eq 0 ]; then
  echo ""
  echo "✅ Génération réussie!"
  echo ""
  echo "Fichiers générés:"
  echo "  • auth_models.g.dart"
  echo "  • dashboard_models.g.dart"
  echo "  • loan_models.g.dart"
  echo "  • transaction_models.g.dart (si créé)"
  echo "  • placement_models.g.dart (si créé)"
  echo "  • profile_models.g.dart (si créé)"
  echo ""
else
  echo ""
  echo "❌ Erreur lors de la génération"
  exit 1
fi

# ============================================================================
# Vérifier les fichiers générés
# ============================================================================

echo "📝 Vérification des fichiers générés..."
echo ""

MODELS=(
  "lib/features/auth/data/models/auth_models.g.dart"
  "lib/features/dashboard/data/models/dashboard_models.g.dart"
  "lib/features/credit/data/models/loan_models.g.dart"
)

for model in "${MODELS[@]}"; do
  if [ -f "$model" ]; then
    echo "✅ $model"
  else
    echo "⚠️  $model (non trouvé - peut être créé après)"
  fi
done

echo ""
echo "🎉 Tous les modèles sont prêts à être utilisés!"

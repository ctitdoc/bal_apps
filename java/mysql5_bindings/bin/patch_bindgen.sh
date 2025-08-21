#!/usr/bin/env bash
set -euo pipefail

TARGET="modules/cosmobilis.mysql5/DatabaseWrapper.bal"

# Fonctions publiques (méthodes du wrapper) à forcer en `isolated`
# - init : constructeur côté Ballerina de la classe DatabaseWrapper
# - newDatabaseWrapper1 : wrapper public du constructeur Java
# - executeUpdate / executeQueryAsJson : les deux appels critiques
PUB_FUNCS=(
  "init"
  "newDatabaseWrapper1"
  "executeUpdate"
  "executeQueryAsJson"
)

# Fonctions externals générées à forcer en `isolated`
EXT_FUNCS=(
  "cosmobilis_mysql5_DatabaseWrapper_newDatabaseWrapper1"
  "cosmobilis_mysql5_DatabaseWrapper_executeUpdate"
  "cosmobilis_mysql5_DatabaseWrapper_executeQueryAsJson"
)

echo "Patching $TARGET …"

# Patch méthodes publiques : "public function X(" -> "public isolated function X("
for f in "${PUB_FUNCS[@]}"; do
  sed -i -E "s/public function ($f\\b)/public isolated function \1/" "$TARGET"
done

# Patch des externals : "function cosmobilis_...(" -> "isolated function cosmobilis_...("
for f in "${EXT_FUNCS[@]}"; do
  sed -i -E "s/^function ($f\\b)/isolated function \1/" "$TARGET"
done

echo "✅ Patch OK : init, newDatabaseWrapper1, executeUpdate, executeQueryAsJson + externals correspondants sont 'isolated'"

#!/bin/bash

INPUT_GEOJSON="/tmp/cantons.geojson"
OUTPUT_SQL="mysql/init/99_cantons_geojson.sql"

# Créer le dossier si nécessaire
mkdir -p mysql/init

echo "=== Import GeoJSON des cantons ==="
echo "Fichier source: $INPUT_GEOJSON"

# Vérifier que le fichier existe
if [ ! -f "$INPUT_GEOJSON" ]; then
    echo "✗ Fichier $INPUT_GEOJSON non trouvé"
    exit 1
fi

echo "=== Génération du fichier SQL ==="

# Parser le GeoJSON avec AWK pur (sans jq)
# Le fichier est sur une seule ligne, on va extraire chaque feature

awk '
BEGIN {
    print "SET NAMES utf8mb4;"
    print "SET CHARACTER SET utf8mb4;"
    print "SET autocommit=0;"
    print ""
    print "-- Mise à jour des GeoJSON pour les cantons"
    print ""
    count = 0
}

function escape_sql(str) {
    gsub(/\\/, "\\\\", str)
    gsub(/'\''/, "\\'\''", str)
    return str
}

{
    # Le fichier GeoJSON est sur une ligne
    # On cherche chaque feature individuellement

    content = $0

    # Supprimer le début {"type":"FeatureCollection","features":[
    sub(/^.*"features":\[/, "", content)
    # Supprimer la fin ]}
    sub(/\]\}$/, "", content)

    # Maintenant on a les features séparées par },{
    # On split sur },{
    n = split(content, features, /\},\{/)

    for (i = 1; i <= n; i++) {
        feat = features[i]

        # Restaurer les accolades
        if (i > 1) feat = "{" feat
        if (i < n) feat = feat "}"

        # Extraire le code canton
        # Format: "code":"01001"
        if (match(feat, /"code":"[^"]+"/)) {
            code_part = substr(feat, RSTART, RLENGTH)
            gsub(/"code":"/, "", code_part)
            gsub(/"/, "", code_part)
            code = code_part
        } else {
            continue
        }

        # Extraire département et canton du code
        # Format: 01001 = dept 01, canton 01 (ou 1)
        # Format: 2A001 = dept 2A, canton 01
        # Format: 97105 = dept 971, canton 05

        if (length(code) >= 5) {
            # Vérifier si c est Corse (2A ou 2B)
            if (substr(code, 1, 2) == "2A" || substr(code, 1, 2) == "2B") {
                dept = substr(code, 1, 2)
                canton = substr(code, 3) + 0
            }
            # Vérifier si c est DOM-TOM (971, 972, 973, 974, 976)
            else if (substr(code, 1, 3) ~ /^97[1-6]/) {
                dept = substr(code, 1, 3)
                canton = substr(code, 4) + 0
            }
            # Sinon format standard: 2 chiffres dept + reste canton
            else {
                dept = substr(code, 1, 2) + 0
                canton = substr(code, 3) + 0
            }
        } else {
            continue
        }

        # Échapper le JSON pour SQL
        geojson_escaped = escape_sql(feat)

        # Générer l UPDATE
        printf "UPDATE t_cantons SET geojson = '\''%s'\'' WHERE departement_numero = '\''%s'\'' AND canton_code = '\''%s'\'' AND geojson IS NULL;\n", geojson_escaped, dept, canton
        count++
    }
}

END {
    print ""
    print "COMMIT;"
    print ""
    print "-- Total: " count " cantons traités"
}' "$INPUT_GEOJSON" > "$OUTPUT_SQL"

echo "✓ Fichier SQL généré: $OUTPUT_SQL"
echo "✓ Taille du fichier: $(du -h "$OUTPUT_SQL" | cut -f1)"
echo "✓ Nombre de lignes SQL: $(wc -l < "$OUTPUT_SQL")"

# Compter le nombre d'UPDATE
UPDATE_COUNT=$(grep -c "UPDATE t_cantons" "$OUTPUT_SQL" || echo "0")
echo "✓ Nombre d'UPDATE: $UPDATE_COUNT"

echo ""
echo "=== Import dans MySQL ==="
docker exec -i mysql_db mysql -uroot -proot annuairesMairesDeFrance < "$OUTPUT_SQL" 2>&1

if [ $? -eq 0 ]; then
    echo "✓ Import réussi!"
    # Vérifier le nombre de cantons avec GeoJSON
    docker exec mysql_db mysql -uroot -proot annuairesMairesDeFrance -e "
    SELECT
        COUNT(*) as total_cantons,
        SUM(geojson IS NOT NULL) as avec_geojson,
        SUM(geojson IS NULL) as sans_geojson
    FROM t_cantons" 2>/dev/null
else
    echo "✗ Erreur lors de l'import"
fi

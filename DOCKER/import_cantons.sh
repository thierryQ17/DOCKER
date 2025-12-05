#!/bin/bash

OUTPUT_SQL="mysql/init/98_t_cantons.sql"

# Créer le dossier si nécessaire
mkdir -p mysql/init

echo "=== Génération de la table t_cantons ==="

# Extraire les données de t_toutesLesInfos et générer le SQL avec AWK
docker exec mysql_db mysql -uroot -proot annuairesMairesDeFrance --default-character-set=utf8mb4 -N -e "
SELECT DISTINCT
    code_region,
    nom_region,
    code_dept,
    nom_dept,
    code_canton,
    nom_canton,
    circonscription
FROM t_toutesLesInfos
WHERE code_dept != '' AND code_canton != ''
ORDER BY code_dept, code_canton, circonscription
" 2>/dev/null | awk -F'\t' 'BEGIN {
    print "SET NAMES utf8mb4;"
    print "SET CHARACTER SET utf8mb4;"
    print "SET autocommit=0;"
    print "SET unique_checks=0;"
    print "SET foreign_key_checks=0;"
    print ""
    print "-- Table t_cantons"
    print "DROP TABLE IF EXISTS t_cantons;"
    print ""
    print "CREATE TABLE t_cantons ("
    print "    id INT AUTO_INCREMENT PRIMARY KEY,"
    print "    region_id INT,"
    print "    region_nom VARCHAR(50),"
    print "    departement_id INT,"
    print "    departement_nom VARCHAR(50),"
    print "    departement_numero VARCHAR(5),"
    print "    circonscription VARCHAR(10),"
    print "    canton_code VARCHAR(10),"
    print "    canton_nom VARCHAR(100),"
    print "    INDEX idx_region_id (region_id),"
    print "    INDEX idx_departement_id (departement_id),"
    print "    INDEX idx_departement_numero (departement_numero),"
    print "    INDEX idx_circonscription (circonscription),"
    print "    INDEX idx_canton_code (canton_code),"
    print "    UNIQUE KEY uk_dept_cantons_circo (departement_numero, canton_code, circonscription)"
    print ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
    print ""
    print "-- Insertion des données par lots de 500"
    print ""
    batch_count = 0
    row_count = 0
}

function escape_sql(str) {
    gsub(/\\/, "\\\\", str)
    gsub(/'\''/, "\\'\''", str)
    gsub(/\r/, "", str)
    gsub(/\n/, "", str)
    return str
}

{
    # Si début de lot, commencer INSERT
    if (batch_count == 0) {
        printf "INSERT INTO t_cantons (region_id, region_nom, departement_id, departement_nom, departement_numero, circonscription, canton_code, canton_nom) VALUES\n"
    }

    # Extraire et échapper les champs
    code_region = escape_sql($1)
    nom_region = escape_sql($2)
    code_dept = escape_sql($3)
    nom_dept = escape_sql($4)
    code_canton = escape_sql($5)
    nom_canton = escape_sql($6)
    circonscription = escape_sql($7)

    # Construire la ligne VALUES avec subquery pour les IDs
    if (batch_count > 0) printf ",\n"
    printf "((SELECT id FROM regions WHERE code_region = '\''%s'\'' LIMIT 1), '\''%s'\'', (SELECT id FROM departements WHERE numero_departement = '\''%s'\'' LIMIT 1), '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'')", \
        code_region, nom_region, code_dept, nom_dept, code_dept, circonscription, code_canton, nom_canton

    batch_count++
    row_count++

    # Tous les 100 enregistrements, terminer le lot (plus petit car subqueries)
    if (batch_count >= 100) {
        print ";"
        print ""
        batch_count = 0
    }
}

END {
    # Terminer le dernier lot si nécessaire
    if (batch_count > 0) {
        print ";"
        print ""
    }
    print "COMMIT;"
    print "SET unique_checks=1;"
    print "SET foreign_key_checks=1;"
    print "SET autocommit=1;"
    print ""
    print "-- Total: " row_count " cantons importés"
}' > "$OUTPUT_SQL"

echo "✓ Fichier SQL généré: $OUTPUT_SQL"
echo "✓ Taille du fichier: $(du -h "$OUTPUT_SQL" | cut -f1)"
echo "✓ Nombre de lignes SQL: $(wc -l < "$OUTPUT_SQL")"

# Compter le nombre d'INSERT
INSERT_COUNT=$(grep -c "INSERT INTO t_cantons" "$OUTPUT_SQL" || echo "0")
echo "✓ Nombre de lots INSERT: $INSERT_COUNT"

echo ""
echo "=== Import dans MySQL ==="
docker exec -i mysql_db mysql -uroot -proot annuairesMairesDeFrance < "$OUTPUT_SQL" 2>&1

if [ $? -eq 0 ]; then
    echo "✓ Import réussi!"
    # Vérifier le nombre d'enregistrements
    docker exec mysql_db mysql -uroot -proot annuairesMairesDeFrance -e "SELECT COUNT(*) as total_cantons FROM t_cantons" 2>/dev/null
    echo ""
    echo "=== Aperçu des données ==="
    docker exec mysql_db mysql -uroot -proot annuairesMairesDeFrance -e "SELECT departement_numero, departement_nom, canton_code, canton_nom, circonscription FROM t_cantons ORDER BY departement_numero, canton_code LIMIT 15" 2>/dev/null
else
    echo "✗ Erreur lors de l'import"
fi

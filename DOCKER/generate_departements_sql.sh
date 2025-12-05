#!/bin/bash

INPUT_CSV="www/Annuaire/data/globalCirco.csv"
OUTPUT_SQL="mysql/init/03_departements.sql"

# Créer le dossier si nécessaire
mkdir -p mysql/init

# Générer le fichier SQL avec AWK
awk -F';' 'BEGIN {
    print "SET NAMES utf8mb4;"
    print "SET CHARACTER SET utf8mb4;"
    print ""
    print "-- Table pour les départements"
    print "DROP TABLE IF EXISTS departements;"
    print ""
    print "CREATE TABLE departements ("
    print "    id INT AUTO_INCREMENT PRIMARY KEY,"
    print "    numero_departement VARCHAR(10) NOT NULL,"
    print "    nom_departement VARCHAR(100) NOT NULL,"
    print "    region VARCHAR(100) NOT NULL,"
    print "    UNIQUE KEY unique_dept (numero_departement, nom_departement),"
    print "    INDEX idx_numero (numero_departement),"
    print "    INDEX idx_nom (nom_departement),"
    print "    INDEX idx_region (region)"
    print ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
    print ""
    print "-- Insertion des départements uniques"
    print ""
}
NR > 1 {
    # Supprimer BOM UTF-8 et retours chariot
    gsub(/^\xef\xbb\xbf/, "")
    gsub(/\r$/, "")

    # Extraire les champs
    region = $1
    numero_dept = $2
    nom_dept = $3

    # Échapper les apostrophes pour SQL
    gsub(/'\''/, "'\'''\''", region)
    gsub(/'\''/, "'\'''\''", numero_dept)
    gsub(/'\''/, "'\'''\''", nom_dept)

    # Créer une clé unique pour éviter les doublons
    key = numero_dept "|" nom_dept

    # Stocker les départements uniques
    if (key != "" && !(key in departements)) {
        departements[key] = 1
        dept_data[key] = region "|" numero_dept "|" nom_dept
        dept_numero[key] = numero_dept
        dept_nom[key] = nom_dept
    }
}
END {
    # Trier par numéro de département puis par nom
    n = asorti(dept_numero, sorted_keys)

    # Créer un tableau trié avec ID explicite
    for (i = 1; i <= n; i++) {
        key = sorted_keys[i]
        split(dept_data[key], fields, "|")
        region = fields[1]
        numero = fields[2]
        nom = fields[3]

        printf "INSERT INTO departements (id, numero_departement, nom_departement, region) VALUES (%d, '\''%s'\'', '\''%s'\'', '\''%s'\'');\n", i, numero, nom, region
    }

    print ""
    print "COMMIT;"
}' "$INPUT_CSV" > "$OUTPUT_SQL"

echo "✓ Fichier SQL des départements généré: $OUTPUT_SQL"
echo "✓ Taille du fichier: $(du -h "$OUTPUT_SQL" | cut -f1)"
echo "✓ Nombre de lignes SQL: $(wc -l < "$OUTPUT_SQL")"

# Compter le nombre de départements uniques
DEPT_COUNT=$(grep -c "INSERT INTO departements" "$OUTPUT_SQL" || echo "0")
echo "✓ Nombre de départements uniques: $DEPT_COUNT"

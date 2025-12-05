#!/bin/bash

INPUT_CSV="www/Annuaire/data/globalCirco.csv"
OUTPUT_SQL="mysql/init/02_regions.sql"

# Créer le dossier si nécessaire
mkdir -p mysql/init

# Générer le fichier SQL avec AWK
awk -F';' 'BEGIN {
    print "SET NAMES utf8mb4;"
    print "SET CHARACTER SET utf8mb4;"
    print ""
    print "-- Table pour les régions"
    print "DROP TABLE IF EXISTS regions;"
    print ""
    print "CREATE TABLE regions ("
    print "    id INT AUTO_INCREMENT PRIMARY KEY,"
    print "    nom_region VARCHAR(100) NOT NULL UNIQUE,"
    print "    INDEX idx_nom_region (nom_region)"
    print ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
    print ""
    print "-- Insertion des régions uniques"
    print ""
}
NR > 1 {
    # Supprimer BOM UTF-8 et retours chariot
    gsub(/^\xef\xbb\xbf/, "")
    gsub(/\r$/, "")

    # Échapper les apostrophes pour SQL
    region = $1
    gsub(/'\''/, "'\'''\''", region)

    # Stocker les régions uniques dans un tableau
    if (region != "" && !(region in regions)) {
        regions[region] = 1
        regions_ordered[++count] = region
    }
}
END {
    # Trier et insérer les régions avec ID explicite
    n = asort(regions_ordered)
    for (i = 1; i <= n; i++) {
        printf "INSERT INTO regions (id, nom_region) VALUES (%d, '\''%s'\'');\n", i, regions_ordered[i]
    }
    print ""
    print "COMMIT;"
}' "$INPUT_CSV" > "$OUTPUT_SQL"

echo "✓ Fichier SQL des régions généré: $OUTPUT_SQL"
echo "✓ Taille du fichier: $(du -h "$OUTPUT_SQL" | cut -f1)"
echo "✓ Nombre de lignes SQL: $(wc -l < "$OUTPUT_SQL")"

# Compter le nombre de régions uniques
REGION_COUNT=$(grep -c "INSERT INTO regions" "$OUTPUT_SQL" || echo "0")
echo "✓ Nombre de régions uniques: $REGION_COUNT"

#!/bin/bash

INPUT_CSV="www/Annuaire/data/globalCirco.csv"
OUTPUT_SQL="mysql/init/01_circonscriptions.sql"

# Créer le dossier si nécessaire
mkdir -p mysql/init

# Générer tout le fichier SQL d'un coup avec AWK (très rapide)
awk -F';' 'BEGIN {
    print "SET NAMES utf8mb4;"
    print "SET CHARACTER SET utf8mb4;"
    print ""
    print "-- Table pour les circonscriptions"
    print "DROP TABLE IF EXISTS circonscriptions;"
    print ""
    print "CREATE TABLE circonscriptions ("
    print "    id INT AUTO_INCREMENT PRIMARY KEY,"
    print "    region VARCHAR(100) NOT NULL,"
    print "    numero_departement VARCHAR(10) NOT NULL,"
    print "    nom_departement VARCHAR(100) NOT NULL,"
    print "    circonscription VARCHAR(50) NOT NULL,"
    print "    canton VARCHAR(150) NOT NULL,"
    print "    INDEX idx_departement (numero_departement),"
    print "    INDEX idx_circonscription (circonscription),"
    print "    INDEX idx_region (region)"
    print ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
    print ""
    print "-- Insertion des données"
    print ""
}
NR > 1 {
    # Supprimer BOM UTF-8 et retours chariot
    gsub(/^\xef\xbb\xbf/, "")
    gsub(/\r$/, "")

    # Échapper les apostrophes pour SQL
    gsub(/'\''/, "'\'''\''", $1)
    gsub(/'\''/, "'\'''\''", $2)
    gsub(/'\''/, "'\'''\''", $3)
    gsub(/'\''/, "'\'''\''", $4)
    gsub(/'\''/, "'\'''\''", $5)

    # Générer INSERT
    printf "INSERT INTO circonscriptions (region, numero_departement, nom_departement, circonscription, canton) VALUES ('\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'');\n", $1, $2, $3, $4, $5
}
END {
    print ""
    print "COMMIT;"
}' "$INPUT_CSV" > "$OUTPUT_SQL"

echo "✓ Fichier SQL généré: $OUTPUT_SQL"
echo "✓ Taille du fichier: $(du -h "$OUTPUT_SQL" | cut -f1)"
echo "✓ Nombre de lignes SQL: $(wc -l < "$OUTPUT_SQL")"

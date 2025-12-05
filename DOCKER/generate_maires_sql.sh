#!/bin/bash

INPUT_CSV="www/Annuaire/data/regions_circo_dept_maires.csv"
OUTPUT_SQL="mysql/init/06_maires.sql"

# Créer le dossier si nécessaire
mkdir -p mysql/init

# Générer le fichier SQL avec AWK (très rapide)
awk -F';' 'BEGIN {
    print "SET NAMES utf8mb4;"
    print "SET CHARACTER SET utf8mb4;"
    print ""
    print "-- Table pour les maires"
    print "DROP TABLE IF EXISTS maires;"
    print ""
    print "CREATE TABLE maires ("
    print "    id INT AUTO_INCREMENT PRIMARY KEY,"
    print "    circonscription_id INT,"
    print "    region VARCHAR(100) NOT NULL,"
    print "    numero_departement VARCHAR(10) NOT NULL,"
    print "    nom_departement VARCHAR(100) NOT NULL,"
    print "    circonscription VARCHAR(50) NOT NULL,"
    print "    ville VARCHAR(150) NOT NULL,"
    print "    code_postal VARCHAR(10),"
    print "    nom_maire VARCHAR(150),"
    print "    telephone VARCHAR(20),"
    print "    email VARCHAR(150),"
    print "    url_mairie VARCHAR(255),"
    print "    lien_google_maps TEXT,"
    print "    lien_waze TEXT,"
    print "    cle_unique VARCHAR(100),"
    print "    INDEX idx_circonscription_id (circonscription_id),"
    print "    INDEX idx_region (region),"
    print "    INDEX idx_numero_departement (numero_departement),"
    print "    INDEX idx_nom_departement (nom_departement),"
    print "    INDEX idx_circonscription (circonscription),"
    print "    INDEX idx_ville (ville),"
    print "    INDEX idx_code_postal (code_postal),"
    print "    INDEX idx_cle_unique (cle_unique),"
    print "    FOREIGN KEY (circonscription_id) REFERENCES circonscriptions(id) ON DELETE SET NULL"
    print ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
    print ""
    print "-- Insertion des données avec subquery pour obtenir circonscription_id"
    print ""
}
NR > 1 {
    # Supprimer BOM UTF-8 et retours chariot
    gsub(/^\xef\xbb\xbf/, "")
    gsub(/\r$/, "")

    # Extraire les champs (13 colonnes)
    region = $1
    numero_dept = $2
    nom_dept = $3
    circo = $4
    ville = $5
    code_postal = $6
    nom_maire = $7
    telephone = $8
    email = $9
    url_mairie = $10
    lien_google = $11
    lien_waze = $12
    cle = $13

    # Échapper les apostrophes pour SQL
    gsub(/'\''/, "'\'''\''", region)
    gsub(/'\''/, "'\'''\''", numero_dept)
    gsub(/'\''/, "'\'''\''", nom_dept)
    gsub(/'\''/, "'\'''\''", circo)
    gsub(/'\''/, "'\'''\''", ville)
    gsub(/'\''/, "'\'''\''", code_postal)
    gsub(/'\''/, "'\'''\''", nom_maire)
    gsub(/'\''/, "'\'''\''", telephone)
    gsub(/'\''/, "'\'''\''", email)
    gsub(/'\''/, "'\'''\''", url_mairie)
    gsub(/'\''/, "'\'''\''", lien_google)
    gsub(/'\''/, "'\'''\''", lien_waze)
    gsub(/'\''/, "'\'''\''", cle)

    # Générer l'\''INSERT avec subquery pour obtenir circonscription_id
    printf "INSERT INTO maires (circonscription_id, region, numero_departement, nom_departement, circonscription, ville, code_postal, nom_maire, telephone, email, url_mairie, lien_google_maps, lien_waze, cle_unique)\n"
    printf "SELECT c.id, '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\''\n", region, numero_dept, nom_dept, circo, ville, code_postal, nom_maire, telephone, email, url_mairie, lien_google, lien_waze, cle
    printf "FROM circonscriptions c\n"
    printf "WHERE c.region = '\''%s'\'' AND c.numero_departement = '\''%s'\'' AND c.nom_departement = '\''%s'\'' AND c.circonscription = '\''%s'\''\n", region, numero_dept, nom_dept, circo
    printf "LIMIT 1;\n"
    printf "\n"
}
END {
    print "COMMIT;"
}' "$INPUT_CSV" > "$OUTPUT_SQL"

echo "✓ Fichier SQL des maires généré: $OUTPUT_SQL"
echo "✓ Taille du fichier: $(du -h "$OUTPUT_SQL" | cut -f1)"
echo "✓ Nombre de lignes SQL: $(wc -l < "$OUTPUT_SQL")"

# Compter le nombre de maires
MAIRES_COUNT=$(grep -c "INSERT INTO maires" "$OUTPUT_SQL" || echo "0")
echo "✓ Nombre de maires: $MAIRES_COUNT"

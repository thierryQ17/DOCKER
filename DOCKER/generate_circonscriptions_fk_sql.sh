#!/bin/bash

INPUT_CSV="www/Annuaire/data/globalCirco.csv"
OUTPUT_SQL="mysql/init/05_circonscriptions.sql"

# Créer le dossier si nécessaire
mkdir -p mysql/init

# Générer le fichier SQL avec AWK
awk -F';' 'BEGIN {
    print "SET NAMES utf8mb4;"
    print "SET CHARACTER SET utf8mb4;"
    print ""
    print "-- Table pour les circonscriptions avec foreign keys"
    print "DROP TABLE IF EXISTS circonscriptions;"
    print ""
    print "CREATE TABLE circonscriptions ("
    print "    id INT AUTO_INCREMENT PRIMARY KEY,"
    print "    region_id INT NOT NULL,"
    print "    departement_id INT NOT NULL,"
    print "    region VARCHAR(100) NOT NULL,"
    print "    numero_departement VARCHAR(10) NOT NULL,"
    print "    nom_departement VARCHAR(100) NOT NULL,"
    print "    circonscription VARCHAR(50) NOT NULL,"
    print "    canton VARCHAR(150) NOT NULL,"
    print "    INDEX idx_region_id (region_id),"
    print "    INDEX idx_departement_id (departement_id),"
    print "    INDEX idx_region (region),"
    print "    INDEX idx_numero_departement (numero_departement),"
    print "    INDEX idx_circonscription (circonscription),"
    print "    FOREIGN KEY (region_id) REFERENCES regions(id) ON DELETE CASCADE,"
    print "    FOREIGN KEY (departement_id) REFERENCES departements(id) ON DELETE CASCADE"
    print ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
    print ""
    print "-- Insertion des données avec subqueries pour obtenir les foreign keys"
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
    circo = $4
    canton = $5

    # Échapper les apostrophes pour SQL
    gsub(/'\''/, "'\'''\''", region)
    gsub(/'\''/, "'\'''\''", numero_dept)
    gsub(/'\''/, "'\'''\''", nom_dept)
    gsub(/'\''/, "'\'''\''", circo)
    gsub(/'\''/, "'\'''\''", canton)

    # Générer l'\''INSERT avec subquery (avec toutes les colonnes)
    printf "INSERT INTO circonscriptions (region_id, departement_id, region, numero_departement, nom_departement, circonscription, canton)\n"
    printf "SELECT r.id, d.id, '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\''\n", region, numero_dept, nom_dept, circo, canton
    printf "FROM regions r\n"
    printf "INNER JOIN departements d ON d.numero_departement = '\''%s'\'' AND d.nom_departement = '\''%s'\'' AND d.region = r.nom_region\n", numero_dept, nom_dept
    printf "WHERE r.nom_region = '\''%s'\'';\n", region
    printf "\n"
}
END {
    print "COMMIT;"
}' "$INPUT_CSV" > "$OUTPUT_SQL"

echo "✓ Fichier SQL des circonscriptions généré: $OUTPUT_SQL"
echo "✓ Taille du fichier: $(du -h "$OUTPUT_SQL" | cut -f1)"
echo "✓ Nombre de lignes SQL: $(wc -l < "$OUTPUT_SQL")"

# Compter le nombre de circonscriptions
CIRCO_COUNT=$(grep -c "INSERT INTO circonscriptions" "$OUTPUT_SQL" || echo "0")
echo "✓ Nombre de circonscriptions: $CIRCO_COUNT"

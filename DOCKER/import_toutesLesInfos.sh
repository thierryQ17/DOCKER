#!/bin/bash

INPUT_CSV="www/Annuaire/data/base de travail/6-toutesLesCommunesDeFranceAvecMairesAvecCirco.csv"
OUTPUT_SQL="mysql/init/99_t_toutesLesInfos.sql"

# Créer le dossier si nécessaire
mkdir -p mysql/init

echo "=== Génération du fichier SQL pour t_toutesLesInfos ==="
echo "Fichier source: $INPUT_CSV"

# Générer le fichier SQL avec AWK - INSERT par lots de 500 pour performance maximale
awk -F';' 'BEGIN {
    print "SET NAMES utf8mb4;"
    print "SET CHARACTER SET utf8mb4;"
    print "SET autocommit=0;"
    print "SET unique_checks=0;"
    print "SET foreign_key_checks=0;"
    print ""
    print "-- Table temporaire t_toutesLesInfos"
    print "DROP TABLE IF EXISTS t_toutesLesInfos;"
    print ""
    print "CREATE TABLE t_toutesLesInfos ("
    print "    id INT AUTO_INCREMENT PRIMARY KEY,"
    print "    code_commune VARCHAR(10),"
    print "    longitude DECIMAL(12,8),"
    print "    latitude DECIMAL(12,8),"
    print "    code_postal VARCHAR(10),"
    print "    telephone VARCHAR(100),"
    print "    adresse_courriel VARCHAR(255),"
    print "    site_internet VARCHAR(255),"
    print "    plage_ouverture VARCHAR(500),"
    print "    numero_voie VARCHAR(100),"
    print "    nom_maire VARCHAR(50),"
    print "    prenom_maire VARCHAR(50),"
    print "    code_sexe VARCHAR(5),"
    print "    date_naissance VARCHAR(20),"
    print "    categorie_socio_pro VARCHAR(100),"
    print "    date_debut_mandat VARCHAR(20),"
    print "    date_debut_fonction VARCHAR(20),"
    print "    code_region VARCHAR(5),"
    print "    nom_region VARCHAR(50),"
    print "    code_dept VARCHAR(5),"
    print "    nom_dept VARCHAR(50),"
    print "    code_arrond VARCHAR(5),"
    print "    nom_arrond VARCHAR(50),"
    print "    code_canton VARCHAR(5),"
    print "    nom_canton VARCHAR(50),"
    print "    nom_commune VARCHAR(100),"
    print "    population VARCHAR(20),"
    print "    circonscription VARCHAR(10),"
    print "    INDEX idx_code_commune (code_commune),"
    print "    INDEX idx_code_dept (code_dept),"
    print "    INDEX idx_code_canton (code_canton),"
    print "    INDEX idx_circonscription (circonscription)"
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
    return str
}

function clean_number(str) {
    gsub(/\r/, "", str)
    if (str == "" || str == "NULL") return "NULL"
    return str
}

NR > 1 {
    # Supprimer BOM UTF-8 et retours chariot
    gsub(/^\xef\xbb\xbf/, "")
    gsub(/\r$/, "")

    # Si début de lot, commencer INSERT
    if (batch_count == 0) {
        printf "INSERT INTO t_toutesLesInfos (code_commune, longitude, latitude, code_postal, telephone, adresse_courriel, site_internet, plage_ouverture, numero_voie, nom_maire, prenom_maire, code_sexe, date_naissance, categorie_socio_pro, date_debut_mandat, date_debut_fonction, code_region, nom_region, code_dept, nom_dept, code_arrond, nom_arrond, code_canton, nom_canton, nom_commune, population, circonscription) VALUES\n"
    }

    # Extraire et échapper les champs
    code_commune = escape_sql($1)
    longitude = clean_number($2)
    latitude = clean_number($3)
    code_postal = escape_sql($4)
    telephone = escape_sql($5)
    adresse_courriel = escape_sql($6)
    site_internet = escape_sql($7)
    plage_ouverture = escape_sql($8)
    numero_voie = escape_sql($9)
    nom_maire = escape_sql($10)
    prenom_maire = escape_sql($11)
    code_sexe = escape_sql($12)
    date_naissance = escape_sql($13)
    categorie_socio_pro = escape_sql($14)
    date_debut_mandat = escape_sql($15)
    date_debut_fonction = escape_sql($16)
    code_region = escape_sql($17)
    nom_region = escape_sql($18)
    code_dept = escape_sql($19)
    nom_dept = escape_sql($20)
    code_arrond = escape_sql($21)
    nom_arrond = escape_sql($22)
    code_canton = escape_sql($23)
    nom_canton = escape_sql($24)
    nom_commune = escape_sql($25)
    population = escape_sql($26)
    circonscription = escape_sql($27)

    # Gérer les valeurs NULL pour longitude/latitude
    if (longitude == "NULL" || longitude == "") {
        lon_val = "NULL"
    } else {
        lon_val = longitude
    }
    if (latitude == "NULL" || latitude == "") {
        lat_val = "NULL"
    } else {
        lat_val = latitude
    }

    # Construire la ligne VALUES
    if (batch_count > 0) printf ",\n"
    printf "('\''%s'\'',%s,%s,'\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'','\''%s'\'')", \
        code_commune, lon_val, lat_val, code_postal, telephone, adresse_courriel, site_internet, plage_ouverture, numero_voie, \
        nom_maire, prenom_maire, code_sexe, date_naissance, categorie_socio_pro, date_debut_mandat, date_debut_fonction, \
        code_region, nom_region, code_dept, nom_dept, code_arrond, nom_arrond, code_canton, nom_canton, nom_commune, population, circonscription

    batch_count++
    row_count++

    # Tous les 500 enregistrements, terminer le lot
    if (batch_count >= 500) {
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
    print "-- Total: " row_count " enregistrements importés"
}' "$INPUT_CSV" > "$OUTPUT_SQL"

echo "✓ Fichier SQL généré: $OUTPUT_SQL"
echo "✓ Taille du fichier: $(du -h "$OUTPUT_SQL" | cut -f1)"
echo "✓ Nombre de lignes SQL: $(wc -l < "$OUTPUT_SQL")"

# Compter le nombre d'INSERT
INSERT_COUNT=$(grep -c "INSERT INTO t_toutesLesInfos" "$OUTPUT_SQL" || echo "0")
echo "✓ Nombre de lots INSERT: $INSERT_COUNT"

echo ""
echo "=== Import dans MySQL ==="
docker exec -i mysql_db mysql -uroot -proot annuairesMairesDeFrance < "$OUTPUT_SQL"

if [ $? -eq 0 ]; then
    echo "✓ Import réussi!"
    # Vérifier le nombre d'enregistrements
    docker exec mysql_db mysql -uroot -proot annuairesMairesDeFrance -e "SELECT COUNT(*) as total FROM t_toutesLesInfos"
else
    echo "✗ Erreur lors de l'import"
fi

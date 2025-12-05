#!/bin/bash

# Script ultra-rapide avec AWK pour générer 06_maires.sql avec la colonne NombreHabitants
# Chemins des fichiers
CSV_FILE="C:/DEV POWERSHELL/DOCKER/www/Annuaire/data/regions_circo_dept_maires.csv"
SQL_FILE="C:/DEV POWERSHELL/DOCKER/mysql/init/06_maires.sql"

echo "Génération du fichier SQL avec AWK..."

# Générer le fichier SQL
{
    # En-tête SQL
    cat << 'EOF'
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- Table pour les maires
DROP TABLE IF EXISTS maires;

CREATE TABLE maires (
    id INT AUTO_INCREMENT PRIMARY KEY,
    circonscription_id INT,
    region VARCHAR(100) NOT NULL,
    numero_departement VARCHAR(10) NOT NULL,
    nom_departement VARCHAR(100) NOT NULL,
    circonscription VARCHAR(50) NOT NULL,
    nombre_habitants INT,
    canton VARCHAR(150),
    commune VARCHAR(150),
    ville VARCHAR(150) NOT NULL,
    code_postal VARCHAR(10),
    nom_maire VARCHAR(150),
    telephone VARCHAR(20),
    email VARCHAR(150),
    url_mairie VARCHAR(255),
    lien_google_maps TEXT,
    lien_waze TEXT,
    cle_unique VARCHAR(100),
    INDEX idx_circonscription_id (circonscription_id),
    INDEX idx_region (region),
    INDEX idx_numero_departement (numero_departement),
    INDEX idx_nom_departement (nom_departement),
    INDEX idx_circonscription (circonscription),
    INDEX idx_nombre_habitants (nombre_habitants),
    INDEX idx_ville (ville),
    INDEX idx_code_postal (code_postal),
    INDEX idx_cle_unique (cle_unique),
    FOREIGN KEY (circonscription_id) REFERENCES circonscriptions(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertion des données
INSERT INTO maires (region, numero_departement, nom_departement, circonscription, nombre_habitants, canton, commune, ville, code_postal, nom_maire, telephone, email, url_mairie, lien_google_maps, lien_waze, cle_unique) VALUES
EOF

    # Traiter le CSV avec AWK
    awk -F';' '
    BEGIN {
        OFS = ""
    }

    # Fonction pour échapper les quotes SQL
    function escape_sql(str) {
        if (str == "" || str == "\"\"") return "NULL"
        # Enlever les guillemets du début et de fin
        gsub(/^"|"$/, "", str)
        # Échapper les apostrophes
        gsub(/'\''/, "'\'''\''", str)
        # Échapper les backslashes
        gsub(/\\/, "\\\\", str)
        return "'\''" str "'\''"
    }

    # Fonction pour traiter les nombres
    function process_number(str) {
        gsub(/^"|"$/, "", str)
        if (str == "" || str == "NULL") return "NULL"
        # Vérifier si c'\''est un nombre
        if (str ~ /^[0-9]+$/) return str
        return "NULL"
    }

    # Ignorer la ligne d'\''en-tête
    NR == 1 { next }

    {
        # Extraire les colonnes (positions basées sur le CSV)
        # 1=Region, 2=NumeroDepartement, 3=NomDepartement, 4=Circonscription,
        # 5=NombreHabitants, 6=Canton, 7=Commune, 8=CodePostal,
        # 9=Ville, 10=NomMaire, 11=Telephone, 12=Email,
        # 13=UrlMairie, 14=LienGoogleMaps, 15=LienWaze, 16=KEY

        region = escape_sql($1)
        numero_dept = escape_sql($2)
        nom_dept = escape_sql($3)
        circo = escape_sql($4)
        nombre_hab = process_number($5)
        canton = escape_sql($6)
        commune = escape_sql($7)
        code_postal = escape_sql($8)
        # Si Ville est vide, utiliser Commune
        if ($9 == "" || $9 == "\"\"") {
            ville = escape_sql($7)
        } else {
            ville = escape_sql($9)
        }
        nom_maire = escape_sql($10)
        telephone = escape_sql($11)
        email = escape_sql($12)
        url_mairie = escape_sql($13)
        google_maps = escape_sql($14)
        waze = escape_sql($15)
        key_val = escape_sql($16)

        # Construire la ligne SQL
        printf("(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
            region, numero_dept, nom_dept, circo, nombre_hab,
            canton, commune, ville, code_postal, nom_maire,
            telephone, email, url_mairie, google_maps, waze, key_val)

        # Ajouter virgule ou point-virgule
        if (getline nextline < FILENAME > 0) {
            print ","
            close(FILENAME)
        } else {
            print ";"
        }
    }
    ' "$CSV_FILE"

} > "$SQL_FILE"

echo "✓ Fichier SQL généré avec succès: $SQL_FILE"
echo "$(wc -l < "$SQL_FILE") lignes générées"

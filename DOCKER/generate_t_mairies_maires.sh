#!/bin/bash
# Génère les fichiers SQL pour t_mairies et t_maires avec AWK
# Puis les exécute directement dans MySQL

INPUT_CSV="www/Annuaire/data/base de travail/toutesLesCommunesDeFranceAvecMaires.csv"
OUTPUT_DIR="mysql/init"
SQL_TABLES="$OUTPUT_DIR/10_t_mairies_tables.sql"
SQL_MAIRIES="$OUTPUT_DIR/11_t_mairies_data.sql"
SQL_MAIRES="$OUTPUT_DIR/12_t_maires_data.sql"

mkdir -p "$OUTPUT_DIR"

echo "=== GÉNÉRATION SQL t_mairies / t_maires ==="
echo ""

# =============================================
# Étape 1: Créer le fichier de structure des tables
# =============================================
echo "[1/4] Génération structure des tables..."

cat > "$SQL_TABLES" << 'EOSQL'
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Table t_mairies
DROP TABLE IF EXISTS t_maires;
DROP TABLE IF EXISTS t_mairies;

CREATE TABLE t_mairies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codeCommune VARCHAR(10) NOT NULL UNIQUE,
    nomCommune VARCHAR(255),
    codePostal VARCHAR(10),
    adresseMairie VARCHAR(500),
    telephone VARCHAR(50),
    email VARCHAR(255),
    siteInternet VARCHAR(500),
    plageOuverture TEXT,
    longitude DECIMAL(10, 8),
    latitude DECIMAL(10, 8),
    codeArrondissement VARCHAR(10),
    nomArrondissement VARCHAR(255),
    codeCanton VARCHAR(10),
    nomCanton VARCHAR(255),
    codeRegion VARCHAR(5),
    nomRegion VARCHAR(255),
    codeDept VARCHAR(5),
    nomDept VARCHAR(255),
    nbHabitants INT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_code_commune (codeCommune),
    INDEX idx_code_dept (codeDept),
    INDEX idx_code_postal (codePostal),
    INDEX idx_nom_commune (nomCommune(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table t_maires
CREATE TABLE t_maires (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codeCommune VARCHAR(10) NOT NULL,
    nomMaire VARCHAR(255),
    prenomMaire VARCHAR(255),
    nomPrenom VARCHAR(500),
    codeSexe CHAR(1),
    dateNaissance DATE,
    metierMaire VARCHAR(500),
    dateDebutMandat DATE,
    dateDebutFonction DATE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_code_commune (codeCommune),
    INDEX idx_nom_maire (nomMaire(100)),
    CONSTRAINT fk_maire_mairie FOREIGN KEY (codeCommune)
        REFERENCES t_mairies(codeCommune) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
EOSQL

echo "   ✓ $SQL_TABLES"

# =============================================
# Étape 2: Générer INSERT t_mairies avec AWK
# =============================================
echo "[2/4] Génération INSERT t_mairies (AWK)..."

awk -F';' 'BEGIN {
    print "SET NAMES utf8mb4;"
    print "SET FOREIGN_KEY_CHECKS = 0;"
    print "SET UNIQUE_CHECKS = 0;"
    print "SET AUTOCOMMIT = 0;"
    print ""
    print "-- Insertion des mairies"
    print "INSERT INTO t_mairies (codeCommune, nomCommune, codePostal, adresseMairie, telephone, email, siteInternet, plageOuverture, longitude, latitude, codeArrondissement, nomArrondissement, codeCanton, nomCanton, codeRegion, nomRegion, codeDept, nomDept, nbHabitants) VALUES"
    first = 1
    count = 0
}

function escape(s) {
    gsub(/\047/, "\047\047", s)  # Escape single quotes
    gsub(/\\/, "\\\\", s)
    gsub(/\r/, "", s)
    return s
}

function clean_num(s) {
    gsub(/[^0-9]/, "", s)
    return (s == "") ? "NULL" : s
}

NR == 1 {
    # Supprimer BOM UTF-8
    gsub(/^\xef\xbb\xbf/, "")
    next
}

{
    # Colonnes CSV:
    # 1:code_commune, 2:longitude, 3:latitude, 4:code_postal, 5:telephone
    # 6:email, 7:site_internet, 8:plage_ouverture, 9:adresse
    # 10-16: données maire (ignorées ici)
    # 17:code_region, 18:nom_region, 19:code_dept, 20:nom_dept
    # 21:code_arrond, 22:nom_arrond, 23:code_canton, 24:nom_canton
    # 25:nom_commune, 26:population

    code = escape($1)
    if (code == "") next

    count++

    # Longitude/Latitude
    lon = ($2 ~ /^-?[0-9.]+$/) ? $2 : "NULL"
    lat = ($3 ~ /^-?[0-9.]+$/) ? $3 : "NULL"

    if (!first) printf ",\n"
    first = 0

    printf "('\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', %s, %s, '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', %s)",
        code,
        escape($25),  # nomCommune
        escape($4),   # codePostal
        escape($9),   # adresseMairie
        escape($5),   # telephone
        escape($6),   # email
        escape($7),   # siteInternet
        escape($8),   # plageOuverture
        lon, lat,
        escape($21),  # codeArrondissement
        escape($22),  # nomArrondissement
        escape($23),  # codeCanton
        escape($24),  # nomCanton
        escape($17),  # codeRegion
        escape($18),  # nomRegion
        escape($19),  # codeDept
        escape($20),  # nomDept
        clean_num($26) # nbHabitants
}

END {
    print ";"
    print ""
    print "COMMIT;"
    print "SET UNIQUE_CHECKS = 1;"
    print "SET FOREIGN_KEY_CHECKS = 1;"
    print ""
    printf "-- Total mairies: %d\n", count
}' "$INPUT_CSV" > "$SQL_MAIRIES"

echo "   ✓ $SQL_MAIRIES"
echo "   ✓ Taille: $(du -h "$SQL_MAIRIES" | cut -f1)"

# =============================================
# Étape 3: Générer INSERT t_maires avec AWK
# =============================================
echo "[3/4] Génération INSERT t_maires (AWK)..."

awk -F';' 'BEGIN {
    print "SET NAMES utf8mb4;"
    print "SET FOREIGN_KEY_CHECKS = 0;"
    print "SET AUTOCOMMIT = 0;"
    print ""
    print "-- Insertion des maires"
    print "INSERT INTO t_maires (codeCommune, nomMaire, prenomMaire, nomPrenom, codeSexe, dateNaissance, metierMaire, dateDebutMandat, dateDebutFonction) VALUES"
    first = 1
    count = 0
}

function escape(s) {
    gsub(/\047/, "\047\047", s)
    gsub(/\\/, "\\\\", s)
    gsub(/\r/, "", s)
    return s
}

function convert_date(d) {
    if (d !~ /^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$/) return "NULL"
    split(d, a, "/")
    return sprintf("\047%s-%s-%s\047", a[3], a[2], a[1])
}

function proper_case(s) {
    return toupper(substr(s, 1, 1)) tolower(substr(s, 2))
}

NR == 1 {
    gsub(/^\xef\xbb\xbf/, "")
    next
}

{
    # Colonnes maire: 10:nom, 11:prenom, 12:sexe, 13:date_naiss, 14:metier, 15:date_mandat, 16:date_fonction
    code = escape($1)
    nom = escape($10)

    if (code == "" || nom == "") next

    count++

    prenom = escape($11)
    nom_prenom = proper_case($11) " " toupper($10)
    gsub(/\047/, "\047\047", nom_prenom)

    if (!first) printf ",\n"
    first = 0

    printf "('\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', '\''%s'\'', %s, '\''%s'\'', %s, %s)",
        code,
        nom,
        prenom,
        nom_prenom,
        escape($12),       # codeSexe
        convert_date($13), # dateNaissance
        escape($14),       # metierMaire
        convert_date($15), # dateDebutMandat
        convert_date($16)  # dateDebutFonction
}

END {
    print ";"
    print ""
    print "COMMIT;"
    print "SET FOREIGN_KEY_CHECKS = 1;"
    print ""
    printf "-- Total maires: %d\n", count
}' "$INPUT_CSV" > "$SQL_MAIRES"

echo "   ✓ $SQL_MAIRES"
echo "   ✓ Taille: $(du -h "$SQL_MAIRES" | cut -f1)"

# =============================================
# Étape 4: Exécuter les fichiers SQL dans MySQL
# =============================================
echo "[4/4] Exécution dans MySQL..."

# Exécuter les scripts SQL
mysql -uroot -proot annuairesMairesDeFrance < "$SQL_TABLES" 2>/dev/null
echo "   ✓ Tables créées"

mysql -uroot -proot annuairesMairesDeFrance < "$SQL_MAIRIES" 2>/dev/null
MAIRIES_COUNT=$(mysql -uroot -proot -N -e "SELECT COUNT(*) FROM t_mairies" annuairesMairesDeFrance 2>/dev/null)
echo "   ✓ $MAIRIES_COUNT mairies insérées"

mysql -uroot -proot annuairesMairesDeFrance < "$SQL_MAIRES" 2>/dev/null
MAIRES_COUNT=$(mysql -uroot -proot -N -e "SELECT COUNT(*) FROM t_maires" annuairesMairesDeFrance 2>/dev/null)
echo "   ✓ $MAIRES_COUNT maires insérés"

echo ""
echo "=== TERMINÉ ==="
echo "t_mairies: $MAIRIES_COUNT enregistrements"
echo "t_maires:  $MAIRES_COUNT enregistrements"

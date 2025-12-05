#!/usr/bin/awk -f
# Script AWK ultra-performant pour générer les INSERT SQL
# Usage: awk -f generateSQL.awk toutesLesCommunesDeFranceAvecMaires.csv

BEGIN {
    FS = ";"
    OFS = ""

    # Fichiers de sortie
    mairies_file = "insert_mairies.sql"
    maires_file = "insert_maires.sql"

    # En-têtes SQL
    print "SET NAMES utf8mb4;" > mairies_file
    print "SET FOREIGN_KEY_CHECKS = 0;" >> mairies_file
    print "SET UNIQUE_CHECKS = 0;" >> mairies_file
    print "SET AUTOCOMMIT = 0;" >> mairies_file
    print "" >> mairies_file

    print "SET NAMES utf8mb4;" > maires_file
    print "SET FOREIGN_KEY_CHECKS = 0;" >> maires_file
    print "SET AUTOCOMMIT = 0;" >> maires_file
    print "" >> maires_file

    batch_size = 500
    mairies_count = 0
    maires_count = 0
    mairies_batch = ""
    maires_batch = ""
}

# Fonction pour échapper les quotes SQL
function escape_sql(str) {
    gsub(/'/, "''", str)
    gsub(/\\/, "\\\\", str)
    gsub(/\r/, "", str)
    return str
}

# Fonction pour convertir date DD/MM/YYYY en YYYY-MM-DD
function convert_date(date_fr) {
    if (date_fr == "" || date_fr !~ /^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$/) {
        return "NULL"
    }
    split(date_fr, d, "/")
    return "'" d[3] "-" d[2] "-" d[1] "'"
}

# Fonction pour nettoyer population (enlever espaces)
function clean_number(num) {
    gsub(/[^0-9]/, "", num)
    if (num == "") return "NULL"
    return num
}

# Fonction pour formater nomPrenom: Prénom NOM
function format_nom_prenom(prenom, nom) {
    # properCase prénom
    p = tolower(prenom)
    first = toupper(substr(p, 1, 1))
    rest = substr(p, 2)
    prenom_fmt = first rest

    # upperCase nom
    nom_fmt = toupper(nom)

    return prenom_fmt " " nom_fmt
}

# Ignorer l'en-tête
NR == 1 { next }

# Traitement des données
{
    # Colonnes CSV (index 1-based):
    # 1:code_commune, 2:longitude, 3:latitude, 4:code_postal, 5:telephone
    # 6:email, 7:site_internet, 8:plage_ouverture, 9:adresse
    # 10:nom_maire, 11:prenom_maire, 12:code_sexe, 13:date_naissance
    # 14:metier, 15:date_mandat, 16:date_fonction
    # 17:code_region, 18:nom_region, 19:code_dept, 20:nom_dept
    # 21:code_arrond, 22:nom_arrond, 23:code_canton, 24:nom_canton
    # 25:nom_commune, 26:population

    code_commune = escape_sql($1)
    if (code_commune == "") next

    # ==================== MAIRIES ====================
    longitude = ($2 != "" && $2 ~ /^-?[0-9.]+$/) ? $2 : "NULL"
    latitude = ($3 != "" && $3 ~ /^-?[0-9.]+$/) ? $3 : "NULL"

    mairies_count++

    if (mairies_count == 1 || (mairies_count - 1) % batch_size == 0) {
        if (mairies_batch != "") {
            # Fermer le batch précédent
            sub(/,$/, ";", mairies_batch)
            print mairies_batch >> mairies_file
            print "" >> mairies_file
        }
        mairies_batch = "INSERT INTO t_mairies (codeCommune, nomCommune, codePostal, adresseMairie, telephone, email, siteInternet, plageOuverture, longitude, latitude, codeArrondissement, nomArrondissement, codeCanton, nomCanton, codeRegion, nomRegion, codeDept, nomDept, nbHabitants) VALUES\n"
    }

    mairies_batch = mairies_batch sprintf("('%s','%s','%s','%s','%s','%s','%s','%s',%s,%s,'%s','%s','%s','%s','%s','%s','%s','%s',%s),\n",
        code_commune,
        escape_sql($25),  # nomCommune
        escape_sql($4),   # codePostal
        escape_sql($9),   # adresseMairie
        escape_sql($5),   # telephone
        escape_sql($6),   # email
        escape_sql($7),   # siteInternet
        escape_sql($8),   # plageOuverture
        longitude,
        latitude,
        escape_sql($21),  # codeArrondissement
        escape_sql($22),  # nomArrondissement
        escape_sql($23),  # codeCanton
        escape_sql($24),  # nomCanton
        escape_sql($17),  # codeRegion
        escape_sql($18),  # nomRegion
        escape_sql($19),  # codeDept
        escape_sql($20),  # nomDept
        clean_number($26) # nbHabitants
    )

    # ==================== MAIRES ====================
    nom_maire = escape_sql($10)
    if (nom_maire != "") {
        maires_count++

        prenom_maire = escape_sql($11)
        nom_prenom = escape_sql(format_nom_prenom($11, $10))

        if (maires_count == 1 || (maires_count - 1) % batch_size == 0) {
            if (maires_batch != "") {
                sub(/,$/, ";", maires_batch)
                print maires_batch >> maires_file
                print "" >> maires_file
            }
            maires_batch = "INSERT INTO t_maires (codeCommune, nomMaire, prenomMaire, nomPrenom, codeSexe, dateNaissance, metierMaire, dateDebutMandat, dateDebutFonction) VALUES\n"
        }

        maires_batch = maires_batch sprintf("('%s','%s','%s','%s','%s',%s,'%s',%s,%s),\n",
            code_commune,
            nom_maire,
            prenom_maire,
            nom_prenom,
            escape_sql($12),        # codeSexe
            convert_date($13),      # dateNaissance
            escape_sql($14),        # metierMaire
            convert_date($15),      # dateDebutMandat
            convert_date($16)       # dateDebutFonction
        )
    }
}

END {
    # Écrire les derniers batchs
    if (mairies_batch != "") {
        sub(/,$/, ";", mairies_batch)
        print mairies_batch >> mairies_file
    }

    if (maires_batch != "") {
        sub(/,$/, ";", maires_batch)
        print maires_batch >> maires_file
    }

    # Finaliser les fichiers
    print "" >> mairies_file
    print "COMMIT;" >> mairies_file
    print "SET UNIQUE_CHECKS = 1;" >> mairies_file
    print "SET FOREIGN_KEY_CHECKS = 1;" >> mairies_file
    print "SET AUTOCOMMIT = 1;" >> mairies_file

    print "" >> maires_file
    print "COMMIT;" >> maires_file
    print "SET FOREIGN_KEY_CHECKS = 1;" >> maires_file
    print "SET AUTOCOMMIT = 1;" >> maires_file

    # Résumé
    print "\n=== GÉNÉRATION TERMINÉE ===" > "/dev/stderr"
    print "Mairies: " mairies_count " enregistrements" > "/dev/stderr"
    print "Maires: " maires_count " enregistrements" > "/dev/stderr"
    print "Fichiers générés:" > "/dev/stderr"
    print "  - insert_mairies.sql" > "/dev/stderr"
    print "  - insert_maires.sql" > "/dev/stderr"
}

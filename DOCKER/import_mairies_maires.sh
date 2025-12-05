#!/bin/bash
# Génère les fichiers SQL avec AWK puis les exécute

CSV_FILE="/var/www/html/Annuaire/data/base de travail/toutesLesCommunesDeFranceAvecMaires.csv"
SQL_DIR="/var/www/html/Annuaire/data/base de travail/SQL"

echo "=== GÉNÉRATION SQL (AWK) ==="
mkdir -p "$SQL_DIR"

# Supprimer BOM et générer SQL mairies
echo "[1/3] Génération insert_mairies.sql..."
sed '1s/^\xEF\xBB\xBF//' "$CSV_FILE" | awk -F';' '
BEGIN {
    print "SET NAMES utf8mb4;"
    print "SET FOREIGN_KEY_CHECKS=0;SET UNIQUE_CHECKS=0;SET AUTOCOMMIT=0;"
    batch=0; count=0
}
function esc(s) { gsub(/\047/,"\047\047",s); gsub(/\\/,"\\\\",s); gsub(/\r/,"",s); return s }
function num(s) { gsub(/[^0-9]/,"",s); return (s==""?"NULL":s) }
NR==1{next}
{
    c=esc($1); if(c=="")next; count++
    if(count%500==1){ if(batch>0)print";"; batch++
        print"INSERT INTO t_mairies(codeCommune,nomCommune,codePostal,adresseMairie,telephone,email,siteInternet,plageOuverture,longitude,latitude,codeArrondissement,nomArrondissement,codeCanton,nomCanton,codeRegion,nomRegion,codeDept,nomDept,nbHabitants)VALUES"
        f=1
    }
    lon=($2~/^-?[0-9.]+$/?$2:"NULL"); lat=($3~/^-?[0-9.]+$/?$3:"NULL")
    if(!f)print","; f=0
    printf"(\047%s\047,\047%s\047,\047%s\047,\047%s\047,\047%s\047,\047%s\047,\047%s\047,\047%s\047,%s,%s,\047%s\047,\047%s\047,\047%s\047,\047%s\047,\047%s\047,\047%s\047,\047%s\047,\047%s\047,%s)",c,esc($25),esc($4),esc($9),esc($5),esc($6),esc($7),esc($8),lon,lat,esc($21),esc($22),esc($23),esc($24),esc($17),esc($18),esc($19),esc($20),num($26)
}
END{if(batch>0)print";"; print"COMMIT;SET UNIQUE_CHECKS=1;SET FOREIGN_KEY_CHECKS=1;"; print "-- Total:",count > "/dev/stderr"}
' > "$SQL_DIR/insert_mairies.sql" 2>&1

# Générer SQL maires
echo "[2/3] Génération insert_maires.sql..."
sed '1s/^\xEF\xBB\xBF//' "$CSV_FILE" | awk -F';' '
BEGIN {
    print "SET NAMES utf8mb4;"
    print "SET FOREIGN_KEY_CHECKS=0;SET AUTOCOMMIT=0;"
    batch=0; count=0
}
function esc(s) { gsub(/\047/,"\047\047",s); gsub(/\\/,"\\\\",s); gsub(/\r/,"",s); return s }
function cvt(d) { if(d!~/^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$/)return"NULL"; split(d,a,"/"); return sprintf("\047%s-%s-%s\047",a[3],a[2],a[1]) }
function pc(s) { return toupper(substr(s,1,1)) tolower(substr(s,2)) }
NR==1{next}
{
    c=esc($1); n=esc($10); if(c==""||n=="")next; count++
    if(count%500==1){ if(batch>0)print";"; batch++
        print"INSERT INTO t_maires(codeCommune,nomMaire,prenomMaire,nomPrenom,codeSexe,dateNaissance,metierMaire,dateDebutMandat,dateDebutFonction)VALUES"
        f=1
    }
    p=esc($11); np=pc($11)" "toupper($10); gsub(/\047/,"\047\047",np)
    if(!f)print","; f=0
    printf"(\047%s\047,\047%s\047,\047%s\047,\047%s\047,\047%s\047,%s,\047%s\047,%s,%s)",c,n,p,np,esc($12),cvt($13),esc($14),cvt($15),cvt($16)
}
END{if(batch>0)print";"; print"COMMIT;SET FOREIGN_KEY_CHECKS=1;"; print "-- Total:",count > "/dev/stderr"}
' > "$SQL_DIR/insert_maires.sql" 2>&1

echo "[3/3] Fichiers générés:"
ls -lh "$SQL_DIR"/*.sql
echo ""
echo "=== TERMINÉ ==="
echo "Exécutez maintenant dans mysql_db:"
echo "  mysql -uroot -proot annuairesMairesDeFrance < createTables.sql"
echo "  mysql -uroot -proot annuairesMairesDeFrance < insert_mairies.sql"
echo "  mysql -uroot -proot annuairesMairesDeFrance < insert_maires.sql"

#!/bin/bash

INPUT_CSV="www/Annuaire/data/regions_circo_dept_maires.csv"
OUTPUT_REPORT="rapport_maires_non_inseres.txt"

echo "==================================================================" > "$OUTPUT_REPORT"
echo "RAPPORT DES MAIRES SANS CORRESPONDANCE AVEC LES CIRCONSCRIPTIONS" >> "$OUTPUT_REPORT"
echo "==================================================================" >> "$OUTPUT_REPORT"
echo "" >> "$OUTPUT_REPORT"
echo "Date: $(date)" >> "$OUTPUT_REPORT"
echo "" >> "$OUTPUT_REPORT"

# Compter le total dans le CSV
TOTAL_CSV=$(($(wc -l < "$INPUT_CSV") - 1))
echo "Nombre total de maires dans le CSV: $TOTAL_CSV" >> "$OUTPUT_REPORT"

# Compter le total dans la base
TOTAL_DB=$(docker-compose exec -T mysql bash -c "mysql -uroot -proot -sN -e 'SELECT COUNT(*) FROM annuairesMairesDeFrance.maires;'" 2>/dev/null)
echo "Nombre de maires insérés dans la base: $TOTAL_DB" >> "$OUTPUT_REPORT"

DIFF=$((TOTAL_CSV - TOTAL_DB))
echo "Nombre de maires NON insérés: $DIFF" >> "$OUTPUT_REPORT"
echo "" >> "$OUTPUT_REPORT"

echo "==================================================================" >> "$OUTPUT_REPORT"
echo "ANALYSE PAR RÉGION" >> "$OUTPUT_REPORT"
echo "==================================================================" >> "$OUTPUT_REPORT"
echo "" >> "$OUTPUT_REPORT"

# Extraire les combinaisons uniques région-département-circonscription du CSV
awk -F';' 'NR > 1 {
    gsub(/\r$/, "")
    key = $1 "|" $2 "|" $3 "|" $4
    if (!(key in seen)) {
        seen[key] = 1
        print $1 ";" $2 ";" $3 ";" $4
    }
}' "$INPUT_CSV" | sort > /tmp/csv_combos.txt

# Extraire les combinaisons uniques de la table circonscriptions
docker-compose exec -T mysql bash -c "mysql -uroot -proot -sN -e \"
    SELECT DISTINCT CONCAT(region, ';', numero_departement, ';', nom_departement, ';', circonscription)
    FROM annuairesMairesDeFrance.circonscriptions
    ORDER BY region, numero_departement, circonscription;
\"" 2>/dev/null > /tmp/db_combos.txt

# Trouver les différences
echo "Combinaisons Région-Département-Circonscription présentes dans le CSV mais ABSENTES de la table circonscriptions:" >> "$OUTPUT_REPORT"
echo "" >> "$OUTPUT_REPORT"

comm -23 /tmp/csv_combos.txt /tmp/db_combos.txt | while IFS=';' read -r region dept nom_dept circo; do
    # Compter combien de maires sont concernés
    COUNT=$(awk -F';' -v r="$region" -v d="$dept" -v nd="$nom_dept" -v c="$circo" '
        NR > 1 && $1 == r && $2 == d && $3 == nd && $4 == c { count++ }
        END { print count }
    ' "$INPUT_CSV")

    echo "- $region | Dept: $dept ($nom_dept) | Circo: $circo | Maires concernés: $COUNT" >> "$OUTPUT_REPORT"
done

echo "" >> "$OUTPUT_REPORT"
echo "==================================================================" >> "$OUTPUT_REPORT"
echo "RÉSUMÉ DES PROBLÈMES IDENTIFIÉS" >> "$OUTPUT_REPORT"
echo "==================================================================" >> "$OUTPUT_REPORT"
echo "" >> "$OUTPUT_REPORT"

# Analyser les types de problèmes
echo "Types de problèmes possibles:" >> "$OUTPUT_REPORT"
echo "1. Différence d'orthographe (accents, espaces, tirets)" >> "$OUTPUT_REPORT"
echo "2. Formatage différent des circonscriptions (1ere circo vs 1ère circo)" >> "$OUTPUT_REPORT"
echo "3. Circonscriptions manquantes dans la table circonscriptions" >> "$OUTPUT_REPORT"
echo "" >> "$OUTPUT_REPORT"

# Nettoyer les fichiers temporaires
rm -f /tmp/csv_combos.txt /tmp/db_combos.txt

echo "Rapport généré: $OUTPUT_REPORT"
cat "$OUTPUT_REPORT"

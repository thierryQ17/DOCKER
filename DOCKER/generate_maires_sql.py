#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script pour générer le fichier SQL 06_maires.sql à partir du CSV regions_circo_dept_maires.csv
avec la nouvelle colonne NombreHabitants
"""

import csv
import os

# Chemins des fichiers
csv_file = r'C:\DEV POWERSHELL\DOCKER\www\Annuaire\data\regions_circo_dept_maires.csv'
sql_file = r'C:\DEV POWERSHELL\DOCKER\mysql\init\06_maires.sql'

def escape_sql_string(s):
    """Échappe les caractères spéciaux pour SQL"""
    if s is None or s == '':
        return 'NULL'
    # Remplacer les guillemets simples par deux guillemets simples
    s = str(s).replace("'", "''")
    # Remplacer les backslashes
    s = s.replace("\\", "\\\\")
    return f"'{s}'"

def main():
    print("Lecture du fichier CSV...")

    # Lire le fichier CSV
    rows = []
    with open(csv_file, 'r', encoding='utf-8-sig') as f:
        # Le CSV utilise ; comme séparateur et " comme quote
        reader = csv.DictReader(f, delimiter=';', quotechar='"')
        for row in reader:
            rows.append(row)

    print(f"Nombre de lignes lues: {len(rows)}")

    # Générer le fichier SQL
    print("Génération du fichier SQL...")

    with open(sql_file, 'w', encoding='utf-8') as f:
        # En-tête
        f.write("SET NAMES utf8mb4;\n")
        f.write("SET CHARACTER SET utf8mb4;\n\n")

        # Suppression et création de la table
        f.write("-- Table pour les maires\n")
        f.write("DROP TABLE IF EXISTS maires;\n\n")

        f.write("CREATE TABLE maires (\n")
        f.write("    id INT AUTO_INCREMENT PRIMARY KEY,\n")
        f.write("    circonscription_id INT,\n")
        f.write("    region VARCHAR(100) NOT NULL,\n")
        f.write("    numero_departement VARCHAR(10) NOT NULL,\n")
        f.write("    nom_departement VARCHAR(100) NOT NULL,\n")
        f.write("    circonscription VARCHAR(50) NOT NULL,\n")
        f.write("    nombre_habitants INT,\n")  # NOUVELLE COLONNE
        f.write("    canton VARCHAR(150),\n")
        f.write("    commune VARCHAR(150),\n")
        f.write("    ville VARCHAR(150) NOT NULL,\n")
        f.write("    code_postal VARCHAR(10),\n")
        f.write("    nom_maire VARCHAR(150),\n")
        f.write("    telephone VARCHAR(20),\n")
        f.write("    email VARCHAR(150),\n")
        f.write("    url_mairie VARCHAR(255),\n")
        f.write("    lien_google_maps TEXT,\n")
        f.write("    lien_waze TEXT,\n")
        f.write("    cle_unique VARCHAR(100),\n")
        f.write("    INDEX idx_circonscription_id (circonscription_id),\n")
        f.write("    INDEX idx_region (region),\n")
        f.write("    INDEX idx_numero_departement (numero_departement),\n")
        f.write("    INDEX idx_nom_departement (nom_departement),\n")
        f.write("    INDEX idx_circonscription (circonscription),\n")
        f.write("    INDEX idx_nombre_habitants (nombre_habitants),\n")  # INDEX sur nouvelle colonne
        f.write("    INDEX idx_ville (ville),\n")
        f.write("    INDEX idx_code_postal (code_postal),\n")
        f.write("    INDEX idx_cle_unique (cle_unique),\n")
        f.write("    FOREIGN KEY (circonscription_id) REFERENCES circonscriptions(id) ON DELETE SET NULL\n")
        f.write(") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\n\n")

        # Insertion des données
        f.write("-- Insertion des données\n")
        f.write("INSERT INTO maires (region, numero_departement, nom_departement, circonscription, nombre_habitants, canton, commune, ville, code_postal, nom_maire, telephone, email, url_mairie, lien_google_maps, lien_waze, cle_unique) VALUES\n")

        for i, row in enumerate(rows):
            # Extraire les valeurs
            region = row.get('Region', '')
            numero_dept = row.get('NumeroDepartement', '')
            nom_dept = row.get('NomDepartement', '')
            circo = row.get('Circonscription', '')
            nombre_hab = row.get('NombreHabitants', '')
            canton = row.get('Canton', '')
            commune = row.get('Commune', '')
            ville = row.get('Ville', '')
            code_postal = row.get('CodePostal', '')
            nom_maire = row.get('NomMaire', '')
            telephone = row.get('Telephone', '')
            email = row.get('Email', '')
            url_mairie = row.get('UrlMairie', '')
            google_maps = row.get('LienGoogleMaps', '')
            waze = row.get('LienWaze', '')
            key = row.get('KEY', '')

            # Convertir nombre_habitants en INT ou NULL
            if nombre_hab and nombre_hab.strip():
                try:
                    nombre_hab_value = int(nombre_hab.strip())
                    nombre_hab_sql = str(nombre_hab_value)
                except:
                    nombre_hab_sql = 'NULL'
            else:
                nombre_hab_sql = 'NULL'

            # Construire la ligne SQL
            values = [
                escape_sql_string(region),
                escape_sql_string(numero_dept),
                escape_sql_string(nom_dept),
                escape_sql_string(circo),
                nombre_hab_sql,  # Pas d'escape pour les INT
                escape_sql_string(canton),
                escape_sql_string(commune),
                escape_sql_string(ville),
                escape_sql_string(code_postal),
                escape_sql_string(nom_maire),
                escape_sql_string(telephone),
                escape_sql_string(email),
                escape_sql_string(url_mairie),
                escape_sql_string(google_maps),
                escape_sql_string(waze),
                escape_sql_string(key)
            ]

            line = f"({', '.join(values)})"

            # Ajouter virgule sauf pour la dernière ligne
            if i < len(rows) - 1:
                line += ","
            else:
                line += ";"

            f.write(line + "\n")

            # Afficher progression tous les 1000 lignes
            if (i + 1) % 1000 == 0:
                print(f"  {i + 1} lignes traitées...")

    print(f"\nFichier SQL généré avec succès: {sql_file}")
    print(f"Nombre total de lignes insérées: {len(rows)}")

if __name__ == '__main__':
    main()

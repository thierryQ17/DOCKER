<?php
/**
 * Configuration personnalisée phpMyAdmin
 * Cache les bases de données système
 */

// Masquer information_schema et performance_schema
$cfg['Servers'][1]['hide_db'] = '^(information_schema|performance_schema|mysql|sys)$';

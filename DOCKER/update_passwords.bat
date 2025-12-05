@echo off
docker exec php_fpm php /var/www/html/Annuaire/update_passwords_cli.php
pause

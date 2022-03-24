function usage {
    echo "./pre_setup.sh   HOSTNAME   USERNAME   PASSWORD"
    echo "               Sets the environment variables for the peer that need to be administered"
    echo "               If [Identity] is specified then the MSP is set to the specified Identity instead of PEER MSP"
}


if [ -z $1 ];
then
    usage
    echo "Please provide the HOSTNAME!!!"
    exit 0
else
    HOSTNAME=$1
    
fi

if [ -z $2 ];
then
    usage
    echo "Please provide the USERNAME!!!"
    exit 0
else
    USERNAME=$2
    
fi

if [ -z $3 ];
then
    usage
    echo "Please provide the PASSWORD!!!"
    exit 0
else
    PASSWORD=$3
    
fi

SLEEP_TIME=1s
SLEEP_TIME2=2s


sudo apt update
sleep $SLEEP_TIME2


sudo apt install apache2
sleep $SLEEP_TIME2



echo "ServerName $HOSTNAME" | sudo tee -a /etc/apache2/apache2.conf
echo '<Directory "/var/www/html/">' | sudo tee -a /etc/apache2/apache2.conf
echo 'AllowOverride All' | sudo tee -a /etc/apache2/apache2.conf
echo '</Directory>' | sudo tee -a /etc/apache2/apache2.conf
sleep $SLEEP_TIME

sudo apache2ctl configtest
sleep $SLEEP_TIME

sudo systemctl restart apache2
sleep $SLEEP_TIME

sudo systemctl is-active apache2
sudo systemctl is-enabled apache2
sleep $SLEEP_TIME


sudo ufw allow http
sleep $SLEEP_TIME
sudo ufw allow https
sleep $SLEEP_TIME
sudo ufw reload
sleep $SLEEP_TIME

echo "AuthType Basic" | sudo tee /var/www/html/.htaccess
echo 'AuthName "Authentication Required"' | sudo tee -a /var/www/html/.htaccess
echo 'AuthUserFile /var/www/.htpasswd' | sudo tee -a /var/www/html/.htaccess
echo 'Require valid-user' | sudo tee -a /var/www/html/.htaccess

htpasswd -bnBC 11 "$USERNAME" $PASSWORD | sudo tee /var/www/.htpasswd


sudo openssl req -x509 -nodes -days 730 -newkey rsa:2048 -keyout /etc/ssl/private/apache.key -out /etc/ssl/certs/apache.crt

echo "<IfModule mod_ssl.c>" | sudo tee /etc/apache2/sites-available/default-ssl.conf
echo "<VirtualHost _default_:443>" | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo "ServerAdmin webmaster@$HOSTNAME" | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo "ServerName $HOSTNAME" | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo "DocumentRoot /var/www/html" | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo 'ErrorLog ${APACHE_LOG_DIR}/error.log' | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo 'CustomLog ${APACHE_LOG_DIR}/access.log combined' | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo "SSLEngine on" | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo "SSLCertificateFile      /etc/ssl/certs/apache.crt" | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo "SSLCertificateKeyFile /etc/ssl/private/apache.key" | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo '<FilesMatch "\.(cgi|shtml|phtml|php)$">' | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo "SSLOptions +StdEnvVars" | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo "</FilesMatch>" | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo "<Directory /usr/lib/cgi-bin>" | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo "SSLOptions +StdEnvVars" | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo "</Directory>" | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo "</VirtualHost>" | sudo tee -a /etc/apache2/sites-available/default-ssl.conf
echo "</IfModule>" | sudo tee -a /etc/apache2/sites-available/default-ssl.conf



sudo a2enmod ssl
sleep $SLEEP_TIME2

sudo a2ensite default-ssl.conf
sleep $SLEEP_TIME2

sudo systemctl restart apache2
sleep $SLEEP_TIME


sudo ufw allow 'OpenSSH'

echo "<VirtualHost *:80>" | sudo tee /etc/apache2/sites-available/000-default.conf
echo "Redirect '/' 'https://$HOSTNAME/'" | sudo tee -a /etc/apache2/sites-available/000-default.conf
echo "ServerAdmin webmaster@$HOSTNAME" | sudo tee -a /etc/apache2/sites-available/000-default.conf
echo "DocumentRoot /var/www/html" | sudo tee -a /etc/apache2/sites-available/000-default.conf
echo 'ErrorLog ${APACHE_LOG_DIR}/error.log' | sudo tee -a /etc/apache2/sites-available/000-default.conf
echo 'CustomLog ${APACHE_LOG_DIR}/access.log combined' | sudo tee -a /etc/apache2/sites-available/000-default.conf
echo "</VirtualHost>" | sudo tee -a /etc/apache2/sites-available/000-default.conf

sudo systemctl restart apache2
sleep $SLEEP_TIME


sudo apt install php libapache2-mod-php php-mysql
sleep $SLEEP_TIME2

php -v





echo "====> Apache and PHP installed!"

echo "https://$USERNAME:$PASSWORD@localhost OR https://$USERNAME:$PASSWORD@$HOSTNAME"

# ./pre_setup.sh ledger1.drosatos.eu username pass
# Startup script to launch the node app
#sudo mv /tmp/app/deployment/myapp.service /lib/systemd/system/myapp.service

# Point Apache to our config
#sudo mv /tmp/app/deployment/apache_conf/bitnami-apps-prefix.conf /opt/bitnami/apache2/conf/bitnami/bitnami-apps-prefix.conf


# Auto-start the service
#sudo systemctl enable myapp.service

# Move the module into Drupal's location
sudo mv /tmp/app /opt/bitnami/apps/drupal/htdocs/modules/mymod

# Enable all drupal modules
cd /opt/bitnami/apps/drupal/htdocs && drush pm-enable robotstxt -y

# With our code in place, restart Apache
sudo /opt/bitnami/ctlscript.sh restart apache



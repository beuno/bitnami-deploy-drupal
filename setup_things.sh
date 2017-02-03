# Move the module into Drupal's location
# IB path
#sudo mv /tmp/app /opt/bitnami/apps/drupal/htdocs/modules/mymod

# Move Drupal out of the way
sudo nami stop apache; nami stop php
sudo mv /opt/bitnami/drupal /opt/bitnami/drupal.bitnami.orig

# nami path
sudo mv /tmp/app /opt/bitnami/drupal
cd /opt/bitnami/drupal && composer install %% drush cr


# Enable our drupal module
#XXX Need to dynamically specify the module name
# cd /opt/bitnami/drupal && drush pm-enable robotstxt -y

# Move the module into Drupal's location
# IB path
#sudo mv /tmp/app /opt/bitnami/apps/drupal/htdocs/modules/mymod
# nami path
sudo mv /tmp/app /opt/bitnami/drupal/modules/mymod

# Enable our drupal module
#XXX Need to dynamically specify the module name
cd /opt/bitnami/drupal && drush pm-enable robotstxt -y

# Move the module into Drupal's location
sudo mv /tmp/app /opt/bitnami/apps/drupal/htdocs/modules/mymod

# Enable all drupal modules
cd /opt/bitnami/apps/drupal/htdocs && drush pm-enable robotstxt -y

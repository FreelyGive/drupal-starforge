#!/usr/bin/env bash
set -eu -o pipefail
cd $APP_ROOT

test -f composer.lock || (generate-composer-json > composer.json && composer install)

ln -s -f $(realpath -s --relative-to=web/profiles project_template/web/profiles/drupal_cms_installer) web/profiles

# Patch settings.php.
composer config scripts.post-drupal-scaffold-cmd \
    'cd web/sites/default && test -z "$(grep '\''include \$devpanel_settings;'\'' settings.php)" && patch -Np1 -r /dev/null < $APP_ROOT/.devpanel/drupal-settings.patch || :'

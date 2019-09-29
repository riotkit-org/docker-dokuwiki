#!/bin/bash

if [[ ${DOKUWIKI_INSTALL} == "false" ]]; then
    echo " >> Deleting install.php to not allow re-installation of the application"
    rm -f /var/www/html/install.php
fi

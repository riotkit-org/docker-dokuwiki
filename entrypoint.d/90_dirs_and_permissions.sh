#!/bin/bash

is_dir_empty() {
    if find "$1" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
        return 1
    fi

    return 0
}

set -xe

#
# Symlink all /data/* directories, populate from /template if empty
#

set +x

echo " >> Creating symlinks and populating volume directories"

for dirname in $(ls /template); do
    echo " >> Processing directory ${dirname}"
    dest_dir=/var/www/html/$dirname

    mkdir -p $dest_dir

    if is_dir_empty $dest_dir; then
        echo " .. Populating $dest_dir directory from /template/${dirname}"

        cp -pr /template/$dirname/* "$dest_dir/"
    fi
done

set -x
mkdir -p /var/www/html/data/cache
chown www-data:www-data /var/www/html -R

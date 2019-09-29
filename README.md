DokuWiki Docker Image (based on RiotKit's PHP-APP container)
============================================================

[![Build Status](https://travis-ci.org/riotkit-org/docker-dokuwiki.svg?branch=master)](https://travis-ci.org/riotkit-org/docker-dokuwiki)

![logo](logo.png)

## What is DokuWiki?

```
DokuWiki is a simple to use and highly versatile Open Source wiki software that doesn't require a database. 
It is loved by users for its clean and readable syntax. 
The ease of maintenance, backup and integration makes it an administrator's favorite. 
Built in access controls and authentication connectors make DokuWiki especially useful in the enterprise context 
and the large number of plugins contributed by its vibrant community allow for a broad range of 
use cases beyond a traditional wiki.
```

## Requirements to build image

- Docker
- JINJA2 CLI (j2cli - `pip install j2cli`)

## Image

The image is built with superpower of RiotKit's PHP image. See
[php-app](https://github.com/riotkit-org/docker-php-app) for available
envronment variables to configure.

**Running:**

1. Run the container

```bash
# run one of stable versions
sudo docker run \
  --name dokuwiki \
  -v $(pwd)/data:/var/www/html/data \
  -v $(pwd)/lib:/var/www/html/lib \
  -v $(pwd)/conf:/var/www/html/conf \
  -p 80:80 \
  -e DOKUWIKI_INSTALL=true \
  quay.io/riotkit/dokuwiki:stable-2018-04-22b
```

See the list of all versions there: https://quay.io/repository/riotkit/dokuwiki?tab=tags
Each stable, oldstable and development version has a snapshot if you do not like using just `stable` tag, as it is rebuilded on each release.

2. After the container started, navigate to the http://localhost/install.php to setup superuser account and WIKI settings.

3. Remove the container and recreate with installer deactivated

```
sudo docker rm -f dokuwiki

sudo docker run \
  --name dokuwiki \
  -v $(pwd)/data:/var/www/html/data \
  -v $(pwd)/lib:/var/www/html/lib \
  -v $(pwd)/conf:/var/www/html/conf \
  -p 80:80 \
  -e DOKUWIKI_INSTALL=true \
  quay.io/riotkit/dokuwiki:stable-2018-04-22b
```

## Extending

Please put your files and JINJA2 templates into the container with
bind-mount under /.etc.template - all files there will be copied into
/etc with additional JINJA2 rendering (only .j2 files)

The base image [php-app](https://github.com/riotkit-org/docker-php-app)
is supporting files in /.etc.template/nginx/conf.d/ to extend NGINX
configuration.

See also variables in
[php-app](https://github.com/riotkit-org/docker-php-app), they are very
useful, and there are a lot of options.

```
# building a stable version manually, without pushing to registry
make build VERSION=stable PUSH=false

# running
sudo docker run --name wiki --rm -p 80:80 quay.io/riotkit/dokuwiki:stable
```

## How does the image building work?

The variables required for building of the `Dockerfile` are in
`versions` directory. All variables are passed by Makefile with `--build-args`

`Makefile` is listing all versions, and going through them. For each
version it is executing a `docker build`, next `docker tag` and `docker push`.

**What about configuration files, huh?**

Files in `etc` directory are copied into `.etc.template`, and then the
entrypoint is rendering all jinja2 templates into `etc`, and the rest
files are just copied as is.

DokuWiki in Docker
==================

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

The image is built from RiotKit's PHP image. See
[php-app](https://github.com/riotkit-org/docker-php-app) for available
envronment variables to configure.

```
# building a stable version
make build VERSION=stable

# running
sudo docker run --name wiki --rm -p 80:80 quay.io/riotkit/dokuwiki:stable
```

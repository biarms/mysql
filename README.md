# About this Repo

This is a fork of the Git repo of the Docker [official image](https://docs.docker.com/docker-hub/official_repos/) for
[mysql](https://registry.hub.docker.com/_/mysql/). See [the Docker Hub page](https://registry.hub.docker.com/_/mysql/)
for the full readme on how to use this Docker image and for information regarding contributing and issues.

The goal of this fork was just to build an ARM compliant image, as the official 'mysql' don't currently contain such
ARM build (at least, not in January 2018), which could be confirmed by running this command:
```
# docker run --rm mplatform/mquery mysql
Image: mysql
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
```

The official 'mysql' readme (generated in [docker-library/docs](https://github.com/docker-library/docs),
specifically in [docker-library/docs/mysql](https://github.com/docker-library/docs/tree/master/mysql)) should be
fully applicable to this docker image, as this docker image was created to mimic as much as possible the official mysql build.



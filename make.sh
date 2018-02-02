#!/bin/bash
make -f Makefile-5.5
make

# When https://github.com/docker/cli/pull/138 merged branch will be part of an official release:
# docker manifest create biarms/mysql biarms/mysql-arm
# docker manifest annotate biarms/mysql biarms/mysql-arm --os linux --arch arm
# docker manifest push new-list-ref-name

# In the mean time, I use: https://github.com/estesp/manifest-tool
# sudo wget -O /usr/local/bin manifest-tool https://github.com/estesp/manifest-tool/releases/download/v0.7.0/manifest-tool-linux-armv7
# sudo chmod +x /usr/local/bin/manifest-tool
manifest-tool push from-spec manifest-5.5.yaml
manifest-tool push from-spec manifest.yaml

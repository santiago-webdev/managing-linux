#!/usr/bin/env bash

set +e

podman volume create zypper_caching
podman build -t main . -v "${XDG_DATA_HOME}"/containers/storage/volumes/zypper_caching:/var/cache/zypp:z

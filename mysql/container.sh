#!/usr/bin/env bash

podman run --detach --name mysql-testing -p 3306:3306 mysql-testing

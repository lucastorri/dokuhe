#!/bin/bash

cd "$(dirname "$0")"

for service_dir in `ls -d */`; do
  service_name=`basename "$service_dir"`
  docker build -t "$service_name:latest" "$service_dir"
done

#!/bin/bash

initial_dir=$(pwd)

download_dir="lib_jars"
mkdir -p "$download_dir"
cd "$download_dir"

# Read the package info
jq -c '.[]' ../maven_libraries.json | while read -r line; do
  name=$(echo $line | jq -r '.name')
  version=$(echo $line | jq -r '.version')

  # Construct Maven coordinates
  mvn_coord="${name}:${version}"

  # Use Maven to download the library
  mvn dependency:get -Dartifact="$mvn_coord" -Ddest=./
done

cd "$initial_dir"

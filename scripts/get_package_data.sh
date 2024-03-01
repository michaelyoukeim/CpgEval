#!/bin/bash

API_KEY="<your-libraries-io-api-key>"
URL="https://libraries.io/api/search?keywords=&languages=Java&order=desc&platforms=Maven&sort=dependent_repos_count&api_key=$API_KEY"

# Fetch data from Libraries.io
curl -s "$URL" | \
jq '[.[] | {name: .name, version: (if .latest_stable_release_number != null then .latest_stable_release_number else .latest_release_number end)}]' > maven_libraries.json

echo "Maven library data saved to maven_libraries.json"


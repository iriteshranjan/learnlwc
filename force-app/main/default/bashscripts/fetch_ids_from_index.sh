#!/bin/bash

# Ensure output is stored in the same folder as this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="$SCRIPT_DIR/moneycontrol_ids.txt"

# Clear the output file
> "$OUTPUT_FILE"

echo "🔎 Fetching company IDs A-Z (limit=1000, offset=0)..."

for letter in {a..z}; do
  echo "📘 Letter: $letter"

  response=$(curl -s --location "https://api-en.cnbctv18.com/nodeapi/v1/markets/companies?letter=$letter&limit=1000&offset=0&fields=companyName%2CcompanyShortName%2CmoneycontrolCompanyId%2CmoneycontrolCompanyCode%2Cslug&pagination=true" \
    --header 'Accept: */*' \
    --header 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8' \
    --header 'Connection: keep-alive' \
    --header 'Origin: https://www.cnbctv18.com' \
    --header 'Referer: https://www.cnbctv18.com/' \
    --header 'Sec-Fetch-Dest: empty' \
    --header 'Sec-Fetch-Mode: cors' \
    --header 'Sec-Fetch-Site: same-site' \
    --header 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36' \
    --header 'sec-ch-ua: "Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"' \
    --header 'sec-ch-ua-mobile: ?0' \
    --header 'sec-ch-ua-platform: "macOS"')

  echo "$response" | jq -r '.data.values[] | "\(.moneycontrolCompanyId) | \(.companyName)"' >> "$OUTPUT_FILE"
done

echo "✅ Done. Extracted company IDs saved to $OUTPUT_FILE"

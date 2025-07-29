#!/bin/bash

INPUT_FILE="/Users/ritesh.kumar/Documents/learnlwc/force-app/main/default/bashscripts/moneycontrol_ids.txt"
OUTPUT_FILE="stock_prices.txt"

# Clear previous output
> "$OUTPUT_FILE"

while IFS= read -r line || [[ -n "$line" ]]; do
    ID=$(echo "$line" | cut -d'|' -f1 | xargs)
    STOCK_NAME=$(echo "$line" | cut -d'|' -f2- | xargs)
    PRICE=""
    EXCHANGE_TRIED=""

    for EX in nse bse; do
        RESPONSE=$(curl -s --location "https://api-en.cnbctv18.com/nodeapi/v1/markets/equityCash?id=$ID&exchange=$EX" \
            --header 'Accept: */*' \
            --header 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8' \
            --header 'Connection: keep-alive' \
            --header 'DNT: 1' \
            --header 'Origin: https://www.cnbctv18.com' \
            --header 'Referer: https://www.cnbctv18.com/' \
            --header 'Sec-Fetch-Dest: empty' \
            --header 'Sec-Fetch-Mode: cors' \
            --header 'Sec-Fetch-Site: same-site' \
            --header 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36' \
            --header 'sec-ch-ua: "Not)A;Brand";v="8", "Chromium";v="138", "Google Chrome";v="138"' \
            --header 'sec-ch-ua-mobile: ?0' \
            --header 'sec-ch-ua-platform: "macOS"')

        PRICE=$(echo "$RESPONSE" | jq -r '.data.pricecurrent // empty')
        if [[ -n "$PRICE" ]]; then
            echo "$STOCK_NAME | $PRICE | $EX" >> "$OUTPUT_FILE"
            echo "✅ $STOCK_NAME | $PRICE | $EX"
            break
        fi
    done

    if [[ -z "$PRICE" ]]; then
        echo "❌ $STOCK_NAME | Failed to fetch from NSE and BSE"
    fi

done < "$INPUT_FILE"

echo -e "\n✅ Done. Results stored in: $OUTPUT_FILE"

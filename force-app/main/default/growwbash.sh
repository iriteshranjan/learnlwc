#!/bin/bash

# API endpoint
API_URL="https://groww.in/v1/api/search/v1/derived/scheme?size=2000"

# Output files
JSON_FILE="groww_data.json"
OUTPUT_FILE="segregated_data.txt"

# Fetch the JSON from API
curl -s "$API_URL" -o $JSON_FILE

# Clear the output file
> $OUTPUT_FILE

# Process each fund in the JSON using jq
jq -c '.content[]' $JSON_FILE | while read fund; do
    echo "====================================" >> $OUTPUT_FILE
    echo "Plan Type: $(echo $fund | jq -r '.plan_type')" >> $OUTPUT_FILE
    echo "Sub Category: $(echo $fund | jq -r '.sub_category')" >> $OUTPUT_FILE
    echo "SIP Allowed: $(echo $fund | jq -r '.sip_allowed')" >> $OUTPUT_FILE
    echo "Lumpsum Allowed: $(echo $fund | jq -r '.lumpsum_allowed')" >> $OUTPUT_FILE
    echo "Risk Rating: $(echo $fund | jq -r '.risk_rating') ($(echo $fund | jq -r '.risk'))" >> $OUTPUT_FILE
    echo "Scheme Code: $(echo $fund | jq -r '.scheme_code')" >> $OUTPUT_FILE
    echo "Fund House: $(echo $fund | jq -r '.fund_house')" >> $OUTPUT_FILE
    echo "Index Fund: $(echo $fund | jq -r '.index')" >> $OUTPUT_FILE
    echo "1-Year Return: $(echo $fund | jq -r '.return1y')" >> $OUTPUT_FILE
    echo "3-Year Return: $(echo $fund | jq -r '.return3y')" >> $OUTPUT_FILE
    echo "5-Year Return: $(echo $fund | jq -r '.return5y // "N/A"')" >> $OUTPUT_FILE
    echo "Minimum Investment Amount: $(echo $fund | jq -r '.min_investment_amount')" >> $OUTPUT_FILE
    echo "Minimum SIP Investment: $(echo $fund | jq -r '.min_sip_investment')" >> $OUTPUT_FILE
    echo "AUM: $(echo $fund | jq -r '.aum') (Assets Under Management)" >> $OUTPUT_FILE
    echo "Groww Rating: $(echo $fund | jq -r '.groww_rating')" >> $OUTPUT_FILE
    echo "Groww Verdict Score: $(echo $fund | jq -r '.groww_verdict_score')" >> $OUTPUT_FILE
    echo "Scheme Name: $(echo $fund | jq -r '.scheme_name')" >> $OUTPUT_FILE
    echo "Fund Manager: $(echo $fund | jq -r '.fund_manager')" >> $OUTPUT_FILE
    echo "Launch Date: $(echo $fund | jq -r '.launch_date')" >> $OUTPUT_FILE
    echo "====================================" >> $OUTPUT_FILE
    echo "" >> $OUTPUT_FILE
done

echo "Segregated data saved in '$OUTPUT_FILE'"

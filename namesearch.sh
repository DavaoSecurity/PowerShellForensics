#!/bin/bash

# APIs for Shodan, Hunter, Whoisxml, SecurityTrails and ISQualityScore. Do not use Maltego. Also has error handling ability.
# Replace YOUR_SHODAN_API_KEY, YOUR_HUNTER_API_KEY, YOUR_WHOISXML_API_KEY, YOUR_SECURITYTRAILS_API_KEY, 
# and YOUR_ISQUALITYSCORE_API_KEY with your actual API keys.
# Save the script to a file, for example, social_media_search.sh.
# Make the script executable: chmod +x social_media_search.sh.
# Run the script with the required arguments: `./social_media_search.sh "John Doe" "Hong Kong

# Check if the required arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <name> <location> <output_file>"
    exit 1
fi

NAME=$1
LOCATION=$2
OUTPUT_FILE=$3

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Create or clear the output file
> "$OUTPUT_FILE"

# Function to search using Shodan
search_shodan() {
    local query="$1"
    local api_key="YOUR_SHODAN_API_KEY"
    local response=$(curl -s "https://api.shodan.io/shodan/host/search?key=$api_key&query=$query")

    if [ $? -ne 0 ]; then
        handle_error "Failed to query Shodan"
    fi

    echo "Shodan Results:" >> "$OUTPUT_FILE"
    echo "$response" >> "$OUTPUT_FILE"
}

# Function to search using Hunter
search_hunter() {
    local domain="$1"
    local api_key="YOUR_HUNTER_API_KEY"
    local response=$(curl -s "https://api.hunter.io/v2/domain-search?domain=$domain&api_key=$api_key")

    if [ $? -ne 0 ]; then
        handle_error "Failed to query Hunter"
    fi

    echo "Hunter Results:" >> "$OUTPUT_FILE"
    echo "$response" >> "$OUTPUT_FILE"
}

# Function to search using Whoisxml
search_whoisxml() {
    local domain="$1"
    local api_key="YOUR_WHOISXML_API_KEY"
    local response=$(curl -s "https://www.whoisxmlapi.com/whoisserver/WhoisService?apiKey=$api_key&domainName=$domain&outputFormat=JSON")

    if [ $? -ne 0 ]; then
        handle_error "Failed to query Whoisxml"
    fi

    echo "Whoisxml Results:" >> "$OUTPUT_FILE"
    echo "$response" >> "$OUTPUT_FILE"
}

# Function to search using SecurityTrails
search_securitytrails() {
    local domain="$1"
    local api_key="YOUR_SECURITYTRAILS_API_KEY"
    local response=$(curl -s "https://api.securitytrails.com/v1/domain/$domain/subdomains?apikey=$api_key")

    if [ $? -ne 0 ]; then
        handle_error "Failed to query SecurityTrails"
    fi

    echo "SecurityTrails Results:" >> "$OUTPUT_FILE"
    echo "$response" >> "$OUTPUT_FILE"
}

# Function to search using ISQualityScore
search_isqualityscore() {
    local domain="$1"
    local api_key="YOUR_ISQUALITYSCORE_API_KEY"
    local response=$(curl -s "https://api.isqualityscore.com/v1/score?domain=$domain&api_key=$api_key")

    if [ $? -ne 0 ]; then
        handle_error "Failed to query ISQualityScore"
    fi

    echo "ISQualityScore Results:" >> "$OUTPUT_FILE"
    echo "$response" >> "$OUTPUT_FILE"
}

# Main execution
echo "Social Media Search Tool Results for $NAME in $LOCATION" >> "$OUTPUT_FILE"
echo "========================================" >> "$OUTPUT_FILE"

# Example domain extraction (you may need to adjust this based on your needs)
DOMAIN=$(echo "$NAME" | tr ' ' '.' | tr '[:upper:]' '[:lower:]').com

# Perform searches
search_shodan "$NAME $LOCATION"
search_hunter "$DOMAIN"
search_whoisxml "$DOMAIN"
search_securitytrails "$DOMAIN"
search_isqualityscore "$DOMAIN"

echo "Search completed. Results saved to $OUTPUT_FILE."

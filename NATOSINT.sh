#!/bin/bash
# chmod +x osint_tool.sh and ./osint_tool.sh
# Ensure that you have the necessary tools installed (like dig, whois, theharvester, and curl).
# Modify the DOMAIN, USERNAME, and IP variables in the script, target specific entities you want to investigate.

# Define output file
OUTPUT_FILE="osint_report.txt"

# Function to gather basic information
gather_basic_info() {
    echo "Gathering basic information..." >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
    echo "Date: $(date)" >> $OUTPUT_FILE
    echo "Hostname: $(hostname)" >> $OUTPUT_FILE
    echo "IP Address: $(hostname -I)" >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
}

# Function to perform DNS lookup
dns_lookup() {
    DOMAIN=$1
    echo "Performing DNS lookup for $DOMAIN..." >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
    dig $DOMAIN >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
}

# Function to perform WHOIS lookup
whois_lookup() {
    DOMAIN=$1
    echo "Performing WHOIS lookup for $DOMAIN..." >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
    whois $DOMAIN >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
}

# Function to gather email addresses
email_lookup() {
    DOMAIN=$1
    echo "Gathering email addresses for $DOMAIN..." >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
    theharvester -d $DOMAIN -b google -l 500 >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
}

# Function to gather usernames
username_lookup() {
    USERNAME=$1
    echo "Gathering information for username: $USERNAME..." >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
    theharvester -d $USERNAME -b all >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
}

# Function to gather phone numbers
phone_lookup() {
    DOMAIN=$1
    echo "Searching for phone numbers associated with $DOMAIN..." >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
    # Using a hypothetical tool or API for phone number lookup
    # Replace with actual command or API call if available
    echo "No phone number lookup tool available in this script." >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
}

# Function to gather addresses
address_lookup() {
    DOMAIN=$1
    echo "Searching for addresses associated with $DOMAIN..." >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
    # Using a hypothetical tool or API for address lookup
    # Replace with actual command or API call if available
    echo "No address lookup tool available in this script." >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
}

# Function to gather social media information
social_media_info() {
    USERNAME=$1
    echo "Gathering social media information for $USERNAME..." >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
    # Example: Using theharvester for social media
    theharvester -d $USERNAME -b all >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
}

# Function to gather IP information
ip_info() {
    IP=$1
    echo "Gathering information for IP: $IP..." >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
    curl ipinfo.io/$IP >> $OUTPUT_FILE
    echo "==============================" >> $OUTPUT_FILE
}

# Main script execution
echo "Starting OSINT Tool..." > $OUTPUT_FILE
echo "==============================" >> $OUTPUT_FILE

# Gather basic information
gather_basic_info

# Example domain and username for lookups
DOMAIN="example.com"
USERNAME="example_user"
IP="8.8.8.8"

# Perform lookups
dns_lookup $DOMAIN
whois_lookup $DOMAIN
email_lookup $DOMAIN
username_lookup $USERNAME
phone_lookup $DOMAIN
address_lookup $DOMAIN
social_media_info $USERNAME
ip_info $IP

echo "OSINT report generated in $OUTPUT_FILE"

#
# email outputfile to ????@davaoscurity.com
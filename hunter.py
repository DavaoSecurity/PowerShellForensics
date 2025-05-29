# pip install requestsAPI Key: Replace 'YOUR_HUNTER_API_KEY' with your actual Hunter API key.
# Output File: The results will be appended to a file named email_search_results.txt in the same directory as the script. If the file does
not exist, it will be created.
# Rate Limits: Be aware of the rate limits imposed by the Hunter API. Check their documentation for details on usage limits.
# Privacy and Ethics: Ensure that you have permission to search for someone's email address and that you comply with relevant privacy laws
# and ethical guidelines.


import requests

def find_email_by_name(api_key, first_name, last_name, domain):
    # Define the endpoint for the Hunter API
    url = "https://api.hunter.io/v2/email-finder"
    
    # Set up the parameters for the request
    params = {
        'first_name': first_name,
        'last_name': last_name,
        'domain': domain,
        'api_key': api_key
    }
    
    # Make the request to the Hunter API
    response = requests.get(url, params=params)
    
    # Check if the request was successful
    if response.status_code == 200:
        data = response.json()
        if data['data']:
            return data['data']['email'], data['data']['score']
        else:
            return None, None
    else:
        print(f"Error: {response.status_code} - {response.text}")
        return None, None

def save_to_file(first_name, last_name, domain, email, score):
    # Create a formatted string for the output
    output = f"Name: {first_name} {last_name}\nDomain: {domain}\nEmail: {email}\nScore: {score}\n"
    
    # Write the output to a text file
    with open('email_search_results.txt', 'a') as file:
        file.write(output)
        file.write('-' * 40 + '\n')  # Separator for multiple entries

# Example usage
if __name__ == "__main__":
    api_key = 'YOUR_HUNTER_API_KEY'  # Replace with your actual Hunter API key
    first_name = input("Enter the first name: ")
    last_name = input("Enter the last name: ")
    domain = input("Enter the company domain (e.g., example.com): ")
    
    email, score = find_email_by_name(api_key, first_name, last_name, domain)
    
    if email:
        print(f"Found Email Address: {email} (Score: {score})")
        save_to_file(first_name, last_name, domain, email, score)
        print("Results saved to email_search_results.txt")
    else:
        print("No email address found.")

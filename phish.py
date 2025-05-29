# pip install faker
# Faker Library: This library is used to generate fake names and email addresses, making the phishing emails appear more realistic.
# Phishing Tactics: A list of common phishing tactics is defined to simulate various types of phishing emails.
# Email Generation: The generate_phishing_email function creates a phishing email with a random sender, recipient, subject, and body.
# Main Function: The main function generates a specified number of phishing emails and prints them out.

import random
from faker import Faker

fake = Faker()

# List of common phishing tactics
phishing_tactics = [
    "Your account has been compromised. Please verify your identity.",
    "You've won a prize! Click here to claim it.",
    "Your invoice is attached. Please review it immediately.",
    "Urgent: Update your payment information to avoid service interruption.",
    "Your password will expire soon. Click here to reset it."
]

# List of common email domains
email_domains = [
    "example.com",
    "secure-service.com",
    "banking-service.com",
    "online-store.com",
    "social-media.com"
]

def generate_phishing_email():
    # Generate a fake sender name and email
    sender_name = fake.name()
    sender_email = f"{fake.user_name()}@{random.choice(email_domains)}"
    
    # Generate a fake recipient name and email
    recipient_name = fake.name()
    recipient_email = f"{fake.user_name()}@{random.choice(email_domains)}"
    
    # Select a random phishing tactic
    subject = random.choice(phishing_tactics)
    
    # Create a phishing email body
    body = f"""
    Dear {recipient_name},

    {subject}

    Please click the link below to take action:
    [Click Here](http://fake-link.com)

    Thank you,
    {sender_name}
    {sender_email}
    """

    return {
        "sender": f"{sender_name} <{sender_email}>",
        "recipient": f"{recipient_name} <{recipient_email}>",
        "subject": subject,
        "body": body
    }

def main():
    # Generate a number of phishing emails for training
    num_emails = 5
    for _ in range(num_emails):
        email = generate_phishing_email()
        print("From:", email["sender"])
        print("To:", email["recipient"])
        print("Subject:", email["subject"])
        print("Body:", email["body"])
        print("-" * 50)

if __name__ == "__main__":
    main()


import argparse
import base64
import logging
from email.message import EmailMessage

# import google.auth
from googleapiclient.discovery import build
from google.oauth2.credentials import Credentials
from googleapiclient.errors import HttpError

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

class GmailApi:
    def __init__(self, cred_file: str="token.json") -> None:
        self.scopes = [
            "https://www.googleapis.com/auth/gmail.readonly",
            "https://www.googleapis.com/auth/gmail.send",
        ]
        self.creds = Credentials.from_authorized_user_file(cred_file, self.scopes)
        self.service = build("gmail", "v1", credentials=self.creds)

    def send_message(self, message: EmailMessage) -> None:
        logging.debug(f"message to send: {message}")
        try:
            # encoded message
            encoded_message = base64.urlsafe_b64encode(message.as_bytes()).decode()
            create_message = {"raw": encoded_message}
            # pylint: disable=E1101
            send_message = (
                self.service.users()
                .messages()
                .send(userId="me", body=create_message)
                .execute()
            )
            logging.info(f'Message Id: {send_message["id"]}')
        except Exception as e:
            logging.error(f"Error when sending messages: {e}")
            send_message = None
            exit(1)
        return send_message

    @staticmethod
    def get_mesg_obj(to: str, subject: str, message: str) -> EmailMessage:
        email_msg= EmailMessage()
        email_msg.set_content(message)
        email_msg["From"] = "city4noreply@gmail.com"
        email_msg["To"] = to
        email_msg["Subject"] = subject
        return email_msg


def parse_args():
    parser = argparse.ArgumentParser(description="Send a message using the Gmail API")
    parser.add_argument("--to", type=str, required=False, 
                        default="bboyleonp@gmail.com",
                        help="The recipient's email address")
    parser.add_argument("--subject", type=str, required=False, 
                        default="Message from city4noreply",
                        help="The message subject")
    parser.add_argument("--message", type=str, required=True, 
                        help="The message content")
    return parser.parse_args()


def main():
    args = parse_args()
    gmail_api = GmailApi()
    message = GmailApi.get_mesg_obj(args.to, args.subject, args.message)
    gmail_api.send_message(message)


if __name__ == "__main__":
    main()

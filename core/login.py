# core/login.py
import os
from core.session import fetch

def do_login():
    base_url = os.getenv("WEB_URL", "http://localhost:5000")
    LOGIN_URL = f"{base_url}/login.php"
    payload = {
        "email": "admin@test.com",
        "password": "admin123",
    }
    r, _ = fetch(LOGIN_URL, method="POST", data=payload, debug=True)
    return r and r.status_code == 200

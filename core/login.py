# core/login.py
from core.session import fetch

def do_login():
    LOGIN_URL = "http://localhost:5000/login.php"
    payload = {
        "email": "admin@test.com",
        "password": "admin123",
    }
    r, _ = fetch(LOGIN_URL, method="POST", data=payload, debug=True)
    return r and r.status_code == 200

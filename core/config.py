import os

# core/config.py
DIR_WORDLIST = "wordlists/directories.txt"
SQLI_ERROR_FILE = "payloads/sqli_error.txt"
SQLI_UNION_FILE = "payloads/sqli_union.txt"
SQLI_TIME_FILE = "payloads/sqli_time.txt"
XSS_PAYLOADS = "payloads/xss.txt"

DB_CONFIG = {
    "host": os.getenv("MYSQL_HOST", "127.0.0.1"),  # 기본값은 로컬 개발용
    "port": int(os.getenv("MYSQL_PORT", "3306")),
    "user": os.getenv("MYSQL_USER", "root"),
    "password": os.getenv("MYSQL_PASSWORD", "rootpassword"),
    "db": os.getenv("MYSQL_DATABASE", "mydb"),
    "charset": "utf8",
    "autocommit": True
}

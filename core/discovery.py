# core/discovery.py
from urllib.parse import urljoin
from core.payload_loader import load_list
from core.parser import extract_links
from core.session import fetch

VALID_CODES = {200, 201, 202, 204, 301, 302, 403}

def discover_endpoints(base_url, depth, debug=False):
    discovered = set([base_url.rstrip("/")])
    queue = [base_url.rstrip("/")]

    print(f"[+] Crawling depth {depth}")

    for d in range(depth):
        next_queue = []
        for current in queue:
            wordlist = load_list("wordlists/directories.txt")
            print("\n────────────────────────────────────────")
            print(f"[DIR BRUTE-FORCE] Target: {current}")
            print("────────────────────────────────────────")

            for i, w in enumerate(wordlist, start=1):
                url = urljoin(current + "/", w)
                print(f"[DIR-BF {i}/{len(wordlist)}] → {w}", end="\r")

                r, _ = fetch(url, debug=False)
                if r and r.status_code in VALID_CODES:
                    print(f"\n  ✔ Found: {url} (status={r.status_code})")
                    if url not in discovered:
                        discovered.add(url)
                        next_queue.append(url)

            print("\n────────────────────────────────────────")
            print("[HTML PARSING] Extracting links...")
            print("────────────────────────────────────────")

            r, _ = fetch(current, debug=False)
            if r and r.status_code == 200:
                links = extract_links(current, r.text)
                for link in links:
                    print(f"  → Discovered link: {link}")
                    if link not in discovered:
                        discovered.add(link)
                        next_queue.append(link)

        queue = next_queue

    print(f"\n[+] Total discovered endpoints: {len(discovered)}")
    for lists in list(discovered):
        print(" -", lists)
    return list(discovered)

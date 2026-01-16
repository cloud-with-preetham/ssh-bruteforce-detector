```md
# 🚨 SSH Brute Force Detector (UFW)

A **Blue Team** Bash project that detects **failed SSH login attempts** from Linux logs and automatically blocks suspicious IPs using **UFW**.

This project helps you practice:
- Linux log analysis (`/var/log/auth.log`)
- Basic threat detection (brute force patterns)
- Automated response using firewall rules (UFW)

---

## ✅ Features

- Detects **failed SSH password attempts**
- Shows **Top attacker IPs**
- Blocks IPs that cross a defined threshold
- Prevents duplicate blocking
- Saves blocked IPs to a local file (`blocked_ips.txt`)

---

## 🛠️ Requirements

- Linux system with:
  - `openssh-server`
  - `ufw`
  - SSH logs available in `/var/log/auth.log`

> ⚠️ Some systems store logs in `/var/log/secure` (CentOS/RHEL).

---

## 📂 Project Structure

```

ssh-bruteforce-detector/
│── ssh_bruteforce_detector.sh
│── blocked_ips.txt
│── README.md

````

---

## 🚀 Setup & Run

### 1️⃣ Make script executable
```bash
chmod +x ssh_bruteforce_detector.sh
````

### 2️⃣ Run with sudo

```bash
sudo ./ssh_bruteforce_detector.sh
```

---

## ⚙️ Configuration

Inside the script you can change:

```bash
THRESHOLD=5
```

Meaning: any IP with **more than 5 failed attempts** will be blocked.

---

## 📌 Example Output

```
📌 Top IPs with failed SSH attempts:
12  192.168.1.50
7   45.33.12.10
3   10.0.0.2

⚠️ Suspicious IPs (above threshold):
45.33.12.10

🧱 Blocking IPs using UFW...
[BLOCKED] 45.33.12.10 blocked successfully.

📌 Blocked IPs saved in: blocked_ips.txt
```

---

## 🔓 How to Unblock an IP (UFW)

### View firewall rules:

```bash
sudo ufw status numbered
```

### Delete a rule:

```bash
sudo ufw delete <rule_number>
```

---

## ⚠️ Warning (Important)

Do **NOT** run auto-blocking on a remote server unless you are sure you won't block:

* Your own IP
* Your company VPN IP
* Your admin jumpbox IP

Best practice: whitelist your own IP before enabling auto-block rules.

---

## 📌 Future Improvements (Ideas)

* Export report to a timestamped file
* Support both `/var/log/auth.log` and `/var/log/secure`
* Detect invalid users (`Invalid user`)
* Auto-block using `fail2ban` integration
* Send alerts via Telegram/Email

---

## 👨‍💻 Author

**Preetham Pereira**
Cybersecurity & Cloud Security Learner

```
```

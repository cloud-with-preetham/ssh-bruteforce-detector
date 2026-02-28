# 🚨 SSH Brute Force Detector

Automated threat detection tool that monitors SSH login attempts and blocks malicious IPs using UFW firewall.

## 📋 Overview

A Blue Team security tool that analyzes Linux authentication logs to detect SSH brute force attacks and automatically blocks suspicious IPs exceeding a configurable threshold.

## ✅ Features

- Detects failed SSH password attempts from `/var/log/auth.log`
- Identifies top attacker IPs with attempt counts
- Automatically blocks IPs exceeding threshold using UFW
- Prevents duplicate blocking with persistent tracking
- Logs all blocked IPs to `blocked_ips.txt`

## 🛠️ Requirements

- Linux system (Ubuntu/Debian/RHEL/CentOS)
- `openssh-server` installed
- `ufw` firewall installed and enabled
- Root/sudo access
- SSH logs in `/var/log/auth.log` (or `/var/log/secure` on RHEL)

## 📂 Project Structure

```
ssh-bruteforce-detector/
├── ssh-bruteforce-detector.sh
├── blocked_ips.txt
└── README.md
```

## 🚀 Usage

### Run the Detector

```bash
chmod +x ssh-bruteforce-detector.sh
sudo ./ssh-bruteforce-detector.sh
```

### Configure Threshold

Edit the script to adjust sensitivity:

```bash
THRESHOLD=5  # Block IPs with more than 5 failed attempts
```

### Sample Output

```
=========================================
   🚨 SSH Brute Force Detector
=========================================
[INFO] Reading SSH logs from: /var/log/auth.log
[INFO] Threshold for blocking: more than 5 failed attempts

📌 Top IPs with failed SSH attempts:
-----------------------------------
     12 192.168.1.50
      7 45.33.12.10
      3 10.0.0.2

⚠️ Suspicious IPs (above threshold):
-----------------------------------
45.33.12.10

🧱 Blocking IPs using UFW...
-----------------------------------
[BLOCKED] 45.33.12.10 blocked successfully.

✅ Blocking complete.
📌 Blocked IPs saved in: blocked_ips.txt
=========================================
```

## 🔓 Unblock an IP

### View current firewall rules

```bash
sudo ufw status numbered
```

### Delete a specific rule

```bash
sudo ufw delete <rule_number>
```

### Remove from tracking file

```bash
sed -i '/IP_ADDRESS/d' blocked_ips.txt
```

## ⚠️ Important Warning

**Do NOT run on production servers without whitelisting your own IP first!**

```bash
# Whitelist your IP before running
sudo ufw allow from YOUR_IP to any
```

Risk: You may accidentally block yourself or legitimate admin IPs.

## 🎯 Use Cases

- Real-time SSH attack detection
- Automated incident response
- Security monitoring and logging
- Blue Team training exercises
- DevSecOps automation pipelines

## 🔮 Future Enhancements

- Support for both `/var/log/auth.log` and `/var/log/secure`
- Detect invalid user attempts
- Integration with fail2ban
- Email/Telegram alerts for blocked IPs
- Timestamped reports and analytics
- Whitelist management

## 📝 License

MIT

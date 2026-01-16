#!/bin/bash
# ---------------------------------------------------
# SSH Brute Force Detector (UFW)
# - Finds IPs with failed SSH logins
# - Blocks IPs crossing threshold using UFW
# - Logs blocked IPs to blocked_ips.txt
# ---------------------------------------------------

LOG_FILE="/var/log/auth.log"
THRESHOLD=5
BLOCK_LOG="blocked_ips.txt"

echo "=========================================="
echo "   🚨 SSH Brute Force Detector            "
echo "=========================================="

# 1) Check if log file exists
if [ ! -f "$LOG_FILE" ]; then
  echo "[WARN] Log file not found: $LOG_FILE"
  echo "[INFO] On some systems, logs may be in: /var/log/secure"
  exit 1
fi

# 2) Check if UFW exists
if ! command -v ufw >/dev/null 2>&1; then
  echo "[WARN] UFW is not installed."
  echo "[INFO] Install it using: sudo apt install ufw -y"
  exit 1
fi

echo "[INFO] Reading SSH logs from: $LOG_FILE"
echo "[INFO] Threshold for blocking: more than $THRESHOLD failed attempts"
echo

# 3) Extract failed SSH attempts per IP
FAILED_IPS=$(grep "Failed password" "$LOG_FILE" | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr)

if [ -z "$FAILED_IPS" ]; then
  echo "[OK] No failed SSH password attempts found 🎉"
  exit 0
fi

echo "📌 Top IPs with failed SSH attempts:"
echo "-----------------------------------"
echo "$FAILED_IPS"
echo

# 4) Find IPs above threshold
SUSPICIOUS_IPS=$(grep "Failed password" "$LOG_FILE" \
  | awk '{print $(NF-3)}' \
  | sort | uniq -c | sort -nr \
  | awk -v t="$THRESHOLD" '$1 > t {print $2}')

if [ -z "$SUSPICIOUS_IPS" ]; then
  echo "[OK] No IP crossed the threshold. Nothing to block."
  exit 0
fi

echo "⚠️ Suspicious IPs (above threshold):"
echo "-----------------------------------"
echo "$SUSPICIOUS_IPS"
echo

# 5) Ensure block log exists
touch "$BLOCK_LOG"

# 6) Block suspicious IPs (only if not already blocked)
echo "🧱 Blocking IPs using UFW..."
echo "-----------------------------------"

for ip in $SUSPICIOUS_IPS; do

  # If already blocked earlier (in our file), skip
  if grep -q "^$ip$" "$BLOCK_LOG"; then
    echo "[INFO] $ip already blocked earlier (skipping)."
    continue
  fi

  # Block using UFW
  sudo ufw deny from "$ip" to any >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    echo "[BLOCKED] $ip blocked successfully."
    echo "$ip" >> "$BLOCK_LOG"
  else
    echo "[WARN] Failed to block $ip (check permissions/UFW)."
  fi

done

echo
echo "✅ Blocking complete."
echo "📌 Blocked IPs saved in: $BLOCK_LOG"
echo "=========================================="

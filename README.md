# mygpg

A lightweight bash function that encrypts and decrypts **strings** using `gpg` with **symmetric encryption**, producing **compact, single-line armored output** (without PGP headers/footers).

Perfect for scripts, config secrets, or one-liner sharing.

✅ No temporary files  
✅ No base64 double-encoding  
✅ Pure stdin/stdout — pipeline-friendly  
✅ Single-line output — safe for JSON, `.env`, CLI args  
🔐 **No hardcoded passwords** — passphrase entered securely via `read -s` or `MYGPGPAS`

---

## 🚀 Quick Start (Online)

```bash
source <(curl -fsSL https://raw.githubusercontent.com/OlegVladimirov/mygpg/main/mygpg.sh)
```

Or paste the function directly into your shell, `~/.bashrc`, etc.

### Usage

```bash
$ mygpg -e "hello world"
jA0ECQMKAuXZz7...

$ mygpg -d "jA0ECQMKAuXZz7..."
hello world

$ echo "top secret" | MYGPGPAS=111 mygpg -e | MYGPGPAS=111 mygpg -d
top secret
```

>Password is requested interactively (`mygpg pass: `) unless `MYGPGPAS` is set.  
>Input is masked and never appears in logs or `ps`.

---

## 🛡️ Offline / Air-Gapped Use (e.g. Cold Wallets)

No internet? No problem — transfer `mygpg` via QR code.

### 🔧 How the QR was generated (you can reproduce it)

On a trusted, connected machine:

```bash
# 1. Export function as single-line base64
declare -f mygpg | base64 -w 0

# 2. Optional: verify integrity
declare -f mygpg | base64 -w 0 | sha256sum
# → e2639d561799e413da8b99925c4e91c2eda99f8f02e6ea5823f5a10486debb29  -

# 3. Generate QR (requires `qrencode`)
declare -f mygpg | base64 -w 0 | qrencode -o mygpg-qr.png
```

> ✅ You’ll see `mygpg-qr.png` below — pre-generated for convenience.  
> ![qr](mygpg-qr.png)

### 📲 On the isolated machine

1. Scan the QR (e.g. with phone → copy text)  
2. Paste and run (**choose one**):

   **Linux / Termux / WSL:**
   ```bash
   source <(echo 'bXlncGcoKSB7...' | base64 -d)
   ```

   **macOS:**
   ```bash
   source <(echo 'bXlncGcoKSB7...' | base64 -D)
   ```

3. Verify (optional but recommended):
   ```bash
   echo 'bXlncGcoKSB7...' | base64 -d | shasum -a 256
   # Should match: e2639d561799e413da8b99925c4e91c2eda99f8f02e6ea5823f5a10486debb29
   ```

4. Test:
   ```bash
   MYGPGPAS=111 mygpg -e "ok" | MYGPGPAS=111 mygpg -d
   # → "ok"
   ```

💡 Works in Termux, Tails, LiveUSB, Qubes, macOS Recovery Terminal — anywhere with `bash`, `base64`, `gpg`.

---

## 🔒 How It Works

- Uses `gpg --symmetric --armor` (AES256 by default)  
- Strips PGP headers (`-----BEGIN...`) and keeps only the base64 body  
- Encodes real newlines as `\n` for single-line output  
- On decrypt: reconstructs full PGP message and feeds to `gpg --decrypt`  
- Password is read via `read -rsp … </dev/tty` → works even in pipelines  
- Optional: `MYGPGPAS` for automation (CI, scripts)

---

## 🧰 Requirements

- `gpg` (GNU Privacy Guard) — preinstalled on most Linux/macOS  
- `bash` (v4+)  
- `grep`, `tr` (standard in POSIX)

Tested on: Ubuntu 22.04+, macOS Sonoma, Termux, Armbian 25.8.1 noble.

---

## 🧪 Manual Test (after sourcing)

```bash
source mygpg.sh
MYGPGPAS=111 echo "ok" | mygpg -e | MYGPGPAS=111 mygpg -d
# → "ok"
```

Or use the included `test.sh`:
```bash
source mygpg.sh && ./test.sh
```

---

## 📜 License

MIT — see [LICENSE](LICENSE)

---

Made with ❤️  
Idea & implementation: **Oleg Vladimirov** and Qwen AI
mygpg() {
  local i="$2" p
  [[ "$1" == "-d" && -z "$i" ]] && i=$(cat)
  [[ -v MYGPGPAS ]] && p="$MYGPGPAS" || { read -rsp "mygpg pass: " p </dev/tty; echo >&2; [[ -n "$p" ]] || { echo >&2 "WRONG"; return 1; }; }
  [[ "$1" == "-e" && -n "$i" ]] && { echo -n "$i" | gpg --symmetric --armor --batch --yes --passphrase "$p" | grep -Ev '^-----|^$' | tr -d '\n'; echo; }
  [[ "$1" == "-d" && -n "$i" ]] && { echo -e "-----BEGIN PGP MESSAGE-----\n\n$i\n-----END PGP MESSAGE-----" | gpg --decrypt --batch --yes --passphrase "$p" --quiet; echo; }
}
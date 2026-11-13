#!/system/bin/sh
# Runs ON THE PHONE (pushed by optimize.bat). Restricts background running for
# user-installed apps except the keep list. Records the original state ONCE in
# /data/local/tmp/bg-restore.sh so restore.bat can undo it exactly.
# Usage: sh bg-restrict.sh /data/local/tmp/bg-keep.txt
KEEP=/data/local/tmp/bg-keep.clean
tr -d '\r' < "$1" | sed 's/#.*//; s/[[:space:]]//g' | grep -v '^$' > "$KEEP"
R=/data/local/tmp/bg-restore.sh
NEW=0
if [ ! -f "$R" ]; then NEW=1; echo "# original background state, recorded $(date)" > "$R"; fi
n=0; k=0; f=0
for p in $(pm list packages -3 --user 0 | cut -d: -f2); do
  if grep -qx "$p" "$KEEP"; then k=$((k+1)); continue; fi
  if [ $NEW = 1 ]; then
    m=$(cmd appops get "$p" RUN_ANY_IN_BACKGROUND 2>/dev/null | head -1)
    case "$m" in *ignore*) o=ignore;; *deny*) o=deny;; *allow*) o=allow;; *) o=default;; esac
    b=$(am get-standby-bucket "$p" 2>/dev/null)
    echo "cmd appops set $p RUN_ANY_IN_BACKGROUND $o" >> "$R"
    [ -n "$b" ] && echo "am set-standby-bucket $p $b" >> "$R"
  fi
  if cmd appops set "$p" RUN_ANY_IN_BACKGROUND ignore && am set-standby-bucket "$p" restricted; then
    am force-stop "$p"
    n=$((n+1))
  else
    echo "FAIL $p"; f=$((f+1))
  fi
done
echo "RESULT restricted=$n kept=$k failed=$f restore_recorded_now=$NEW"

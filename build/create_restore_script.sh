#!/bin/sh

base="$(cd "$(dirname "$0")" && pwd)"

restore="$base/restore.sh"
config="${1:-config/config.js}"
css="${MM_CUSTOMCSS_FILE:-"css/custom.css"}"
modules="${MM_MODULES_DIR:-"modules"}"

_info() {
  echo "[create restore script $(date +%T.%3N)] $1"
}

# Tests
[ -f "$base/$config" ] || (_info "config.js does not exists" && exit 1)
[ -f "$base/$css" ] || (_info "custom.css does not exists" && exit 1)
[ -d "$base/$modules" ] || (_info "modules directory does not exists" && exit 1)


echo "#!/bin/sh" > $restore
echo "" >> $restore
echo "base=\"\$(cd \"\$(dirname \"\$0\")\" && pwd)\"" >> $restore

echo "" >> $restore

echo "mkdir -p \$base/config" >> $restore
echo "mkdir -p \$base/css" >> $restore
echo "mkdir -p \$base/modules" >> $restore

echo "" >> $restore

echo "cat > \$base/$config <<\"EOF\"" >> $restore
cat <$base/$config >> $restore
echo "EOF" >> $restore
echo "" >> $restore

echo "cat > \$base/$css <<\"EOF\"" >> $restore
cat <$base/$css >> $restore
echo "EOF" >> $restore
echo "" >> $restore

for dir in $(find "$modules" -maxdepth 1 -mindepth 1 -type d)
do
  [ -f "$dir/.git/config" ] && mods="$mods $(cat $dir/.git/config | grep 'url = ' | sed 's|.*url = ||g')"
done

for repo in $mods
do
  echo "cd \$base/$modules && git clone $repo" >> $restore
done

echo "" >> $restore

for repo in $mods
do
  moddir="$modules/$(echo $repo | sed -r 's|.*\/(.*)|\1|g;s|.git||g')"
  [ -f "$base/$moddir/package.json" ] && echo "cd \$base/$moddir && npm install" >> $restore
done

_info "Created restore script $restore" 

chmod +x $restore



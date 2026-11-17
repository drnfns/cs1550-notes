#!/bin/sh
# md -> html mini site. needs pandoc
# usage: ./build.sh [outdir]
set -eu

course=cs1550
desc='intro to operating systems'
out=${1:-site}
d=$(dirname "$0")
t=$d/tmpl
idx=$(mktemp)
trap 'rm -f "$idx"' EXIT
mkdir -p "$out"

# first h1 outside code fences
h1() { awk '/^(```|~~~)/{f=!f} !f&&/^# /{sub(/^# +/,"");gsub(/`/,"");print;exit}' "$1"; }

for f in "$d"/notes/*.md; do
	[ -e "$f" ] || continue
	n=$(basename "$f" .md)
	ttl=$(h1 "$f")
	# no h1 -> title from filename, template prints it
	nh=
	[ -n "$ttl" ] || { ttl=$(echo "$n" | sed "s/^[0-9]*-//;s/-/ /g"); nh=1; }
	# only headings/blank lines -> stub
	e=1
	grep -qv '^[[:space:]]*\(#.*\)\?$' "$f" && e=
	num=$(echo "${n%%-*}" | sed -n 's/^0*\([0-9][0-9]*\)$/\1/p')
	# -M not -V: metadata gets html-escaped, so "a < b & c" titles are safe
	pandoc "$f" -s --toc --toc-depth=3 --template="$t/page.html" --lua-filter="$t/tbl.lua" \
		-M pagetitle="$ttl" -M ttl="$ttl" -V nh="$nh" -V empty="$e" \
		-V course="$course" -o "$out/$n.html"
	pandoc "$f" -s --toc --toc-depth=1 --shift-heading-level-by=-1 \
		--template="$t/entry.html" -V href="$n.html" -M ttl="$ttl" -V num="$num" -V empty="$e" |
		sed "s|href=\"#|href=\"$n.html#|g" >>"$idx"
done

pandoc /dev/null -f markdown -s --template="$t/index.html" -M pagetitle=index \
	-V course="$course" -V desc="$desc" -V entries="$(cat "$idx")" -o "$out/index.html"
cp "$t/style.css" "$out/"
cp -r "$t/fonts" "$out/"

echo "built $(find "$out" -name '*.html' | wc -l) pages -> $out/"

#!/bin/sh
# Draws one of the badges shown in the README.
#
# GitLab publishes badges for pipeline status, coverage and the latest release,
# but nothing for figures like the number of tests or how large the image came
# out. Those are drawn here and kept as job artifacts the README points at.
#
#   badge.sh <label> <value> <colour> <output file>
set -e

label=$1
value=$2
colour=$3
out=$4

# 6.5px per character is the usual approximation for the 11px sans stack these
# badges are drawn with; the padding keeps the text clear of the edges.
label_width=$(( ${#label} * 65 / 10 + 10 ))
value_width=$(( ${#value} * 65 / 10 + 10 ))
total_width=$(( label_width + value_width ))

cat > "$out" <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="${total_width}" height="20" role="img" aria-label="${label}: ${value}">
  <title>${label}: ${value}</title>
  <rect width="${label_width}" height="20" fill="#555"/>
  <rect x="${label_width}" width="${value_width}" height="20" fill="${colour}"/>
  <g fill="#fff" text-anchor="middle" font-family="Verdana,Geneva,DejaVu Sans,sans-serif" font-size="11">
    <text x="$(( label_width / 2 ))" y="14">${label}</text>
    <text x="$(( label_width + value_width / 2 ))" y="14">${value}</text>
  </g>
</svg>
EOF

echo "$out: $label $value"

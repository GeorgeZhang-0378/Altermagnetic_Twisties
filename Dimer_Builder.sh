#!/usr/bin/env bash
# Usage: ./Dimer_Builder <a_Ang> <d_Ang> [element] [outfile_without_cell]
# Example: ./Dimer_Builder 12.0 1.5 Al dimer
# Output: Al_d_dimer.cell

set -euo pipefail

a="${1:?need a (Å)}"
d="${2:?need d (Å)}"
elem="${3:-Al}"
out="${4:-dimer}"

# Final output name
seed="${elem}_${d}_${out}.cell"

# compute 0.5*a and 0.5*a ± 0.5*d
x=$(awk -v A="$a" 'BEGIN{printf("%.10f", 0.5*A)}')
y="$x"
z1=$(awk -v A="$a" -v D="$d" 'BEGIN{printf("%.10f", 0.5*A - 0.5*D)}')
z2=$(awk -v A="$a" -v D="$d" 'BEGIN{printf("%.10f", 0.5*A + 0.5*D)}')

cat > "$seed" <<EOF
# Simple dimer ${elem}-${elem}, a=${a} Å, d=${d} Å

#SYMMETRY_GENERATE : FALSE

KPOINT_MP_GRID 1 1 1

%BLOCK SPECIES_POT
${elem} ${elem}_NCP19_PBE_OTF.usp
%ENDBLOCK SPECIES_POT

%BLOCK LATTICE_CART
${a} 0 0
0 ${a} 0
0 0 ${a}
%ENDBLOCK LATTICE_CART

%BLOCK POSITIONS_ABS
${elem}  ${x}  ${y}  ${z1}
${elem}  ${x}  ${y}  ${z2}
%ENDBLOCK POSITIONS_ABS
EOF

echo "[ok] wrote $seed"

# 4-bit Array Multiplier — RTL to GDSII

Team: Kavya Veer(2024112002), Dhanika Kothari(2024102011)

## Setup Commands Log

### Day 0 — Environment Setup

docker --version
docker run hello-world
cd ~
git clone --depth=1 https://github.com/iic-jku/iic-osic-tools.git
cd iic-osic-tools
./start_vnc.sh

Inside container (via http://localhost, password abc123):

iverilog -V | head -1
yosys -V
sta -version
echo $PDK_ROOT $PDK
sak-pdk sky130A

Auto-fix applied so PDK persists across sessions:

echo "sak-pdk sky130A" >> ~/eda/designs/.designinit

### Day 1 — Repo Setup

git clone https://github.com/heyitscass/mult4_2024102011_2024112002.git
cd mult4_2024102011_2024112002
mkdir -p rtl tb synth sta pnr report
touch README.md rtl/full_adder.v rtl/mult_array.v tb/tb_mult.v synth/synth.tcl sta/sta.tcl pnr/config.json

### Part B — Synthesis (Oct 21)
cd /foss/designs/mult4_2024102011_2024112002
yosys -c synth/synth.tcl
# Output: 76 cells, total area 814.531 um2, 16 flip-flops (400.384 um2, 49.16%)
# GLS simulation: PASS 256 vectors checked, 0 errors

### Part C — Static Timing Analysis (Oct 21)
# First run at T=10ns
sta sta/sta.tcl
# worst slack = 7.40ns → T_min = 10 - 7.40 = 2.60ns, F_max = 384.62 MHz

# Rerun at T=2.61ns to confirm MET
sta sta/sta.tcl
# worst slack MET, critical path: _124_ → _118_, 10 cells total

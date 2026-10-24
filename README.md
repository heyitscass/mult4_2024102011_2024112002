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

### Oct 22 — Part D: Physical Design (LibreLane)

CLOCK_PERIOD = 1.2 x T_min (2.60) = 3.12, rounded up to 3.5 ns.

    cd pnr
    librelane config.json

Attempt 1, 3.5 ns: DRC/LVS clean, but setup fails at the ss_100C_1v60 corner
(worst slack -2.154 ns). Part C only checks the typical corner, LibreLane
checks all of them, so this was expected.

Attempt 2, 6.0 ns: slack -0.107 ns, still failing, close.
Attempt 3, 6.5 ns: slack -0.136 ns, barely moved (actually worse).
Attempt 4, 8.0 ns: 0 DRC, 0 LVS, 0 setup violations, slack +1.364 ns. Used this.

    cp runs/RUN_2026-10-22_00-44-49/final/metrics.json pnr/metrics.json
    cp runs/RUN_2026-10-22_00-44-49/final/gds/mult_array.gds pnr/mult_array.gds

### Part D results summary

| Metric | Value |
|---|---|
| CLOCK_PERIOD used | 8.0 ns |
| Number of runs needed | 4 |
| Core area | 17759.5 um^2 |
| Cells after synthesis (Part B) | 76 |
| Cells after place and route | 1895 |
| Kinds of cells added | clock buffers (clkbuf), timing-repair buffers (buf), fill cells, tap cells, decap cells |
| Wirelength | 2362 um |
| Setup slack | 1.364 ns |
| Post-route F_max = 1000/(8.0 - 1.364) | 150.70 MHz |
| F_max from Part C | 384.62 MHz |
| DRC errors | 0 |
| LVS errors | 0 |


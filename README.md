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

# GN-hdl_common_test

Verilog Test RTL for simulation.

- Simulator: Questa Prime Lite
- Language: Verilog
- License: MIT

## Overview
This repository contains a simple RTL design and its dedicated simulation
environment for verification and testbench development.

The RTL is intended as a verification DUT and example design, not as a
production-ready IP.

## Features
- AXI4-Stream based RTL design
- One-cycle latency data path
- Self-contained simulation environment
- SystemVerilog test scenarios and assertions (SVA)

## Directory Structure
```
.
├─ src/
│   └─ gn_common_test.v        # RTL (DUT)
│
├─ sim/
│   ├─ dut.manifest            # DUT description / metadata
│   ├─ srclist.txt             # RTL source file list
│   ├─ mdllist.txt             # Model list for simulation
│   ├─ testlist.txt            # Default test scenarios
│   ├─ testlist_all.txt        # Extended test scenarios
│   │
│   ├─ board/
│   │   └─ board_top.sv        # Top-level simulation wrapper
│   │
│   ├─ scenario/
│   │   ├─ sample_test.sv      # Sample test scenario
│   │   └─ tb_ref.svh          # Common references and tasks
│   │
│   └─ sva/
│       ├─ ast_axi4s.sv        # AXI4-Stream assertions
│       ├─ ast_axi4s.svh       # Assertion properties
│       └─ ast_util.svh        # Assertion utilities
│
├─ LICENSE
└─ README.md
```

The `sim` directory contains all files required to run simulations,
including test scenarios, board-level wrappers, and assertions.

## Simulation
Simulation is performed using a Questa / ModelSim based environment.
This repository assumes an external simulation launcher script that
reads the file lists under `sim/`.

Typical flow:
1. Select test scenarios from `testlist.txt`
2. Compile RTL, models, and testbench
3. Run simulation via `board_top`

## Notes
- This RTL is written mainly in Verilog for compatibility.
- Testbench components are written in SystemVerilog.
- Assertions are instantiated explicitly, not bound, for tool compatibility.

## License
This project is licensed under the MIT License.

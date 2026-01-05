# GN-hdl_common_test

Verilog Test RTL for simulation.

- Simulator: Questa Prime Lite
- Language: Verilog (DUT), SystemVerilog (testbench)
- License: MIT

## Overview
This repository contains a simple RTL design and its dedicated simulation
environment for verification and testbench development.

The RTL is intended as a verification DUT and example design, not as a
production-ready IP.

This repository is primarily used to validate:
- AXI4-Stream protocol behavior
- Testbench components (models, tasks, assertions)
- Scoreboard and log-based result checking

## Features
- AXI4-Stream based RTL (DUT)
- One-cycle latency data path
- Input width to output width conversion
- Scoreboard-based data checking
- SystemVerilog test scenarios
- AXI4-Stream protocol assertions (SVA)
- Self-contained simulation environment

## DUT Behavior
The DUT implements a minimal AXI4-Stream data path with the following behavior:

- Input data width: parameterized (`P_S_AXIS_DWIDTH`)
- Output data width: parameterized (`P_M_AXIS_DWIDTH`)
- Output data is the **lower bits of the input data**
- Minimum latency: **one clock cycle**
- Proper handling of `tvalid` / `tready` backpressure

The design is intentionally simple to focus on **verification correctness**.

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
│   ├─ scoreboard/
│   │   └─ one_cycle_delay_scoreboard.sv   # Scoreboard for RTL (DUT)
│   │
│   ├─ scenario/
│   │   ├─ sample_test.sv      # Sample test scenario
│   │   ├─ send_random_test.sv # Randam data test scenario
│   │   ├─ send_file_test.sv   # File data test scenario
│   │   ├─ 32bit_32words.txt   # sample file data
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
including test scenarios, board-level wrappers, scoreboards, and assertions.

## Simulation
Simulation is performed using a **Questa / ModelSim based environment**.

This repository assumes an external launcher script that:
1. Reads file lists under `sim/`
2. Compiles RTL, models, and testbench
3. Runs simulation with `board_top` as the top module

Test scenarios are selected via `testlist.txt` or `testlist_all.txt`.

## Pass / Fail Criteria
A simulation is considered **FAILED** if any of the following occurs:

- AXI4-Stream assertion (SVA) violation
- Scoreboard reports data mismatch
- Simulator reports runtime errors

If none of the above occur, the test is considered **PASSED**.

## Notes
- The DUT is written in **Verilog-HDL** for compatibility.
- Testbench components are written in **SystemVerilog**.
- Assertions are instantiated explicitly (not bound) for tool compatibility.


## License
This project is licensed under the MIT License.

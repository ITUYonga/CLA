# Yonga-CLA: 8-Stage Pipelined Control Law Accelerator (CLA) on FPGA

<img width="1750" height="625" alt="1" src="https://github.com/user-attachments/assets/93f102ed-405d-4b44-9fd4-d87b397b8690" />


**Authors:** Mustafa Taha Aydemir, Safa Oğuzhan Dişbudak, Arda Yalçınöz, Ahmet Kargı &nbsp;|&nbsp; **Date:** October 2026 &nbsp;|&nbsp; **Platform:** AMD/Xilinx Kria KV260 / Vivado / SystemVerilog

Real-time control loops—the mathematics keeping a quadrotor stable in a 6 m/s crosswind or driving a synchronous motor at tens of kilohertz—executed not in an interrupt-bound CPU thread, but directly in a deterministic, 8-stage pipelined floating-point co-processor built from the ground up in SystemVerilog.

**yonga-cla** is a complete hardware-software implementation of a Texas Instruments TMS320F2803x Type-0 **Control Law Accelerator (CLA)** (SPRUI10A Chapter 10) running on an AMD/Xilinx Kria KV260 (Zynq UltraScale+ MPSoC). Alongside the 40-file synthesizable RTL core, this repository includes a cycle-accurate Python Golden Model, custom assembler and static pipeline linter (`core.py`), a 431-instruction multi-rate cascaded quadrotor flight controller with a disturbance observer (`drone.casm`), a 6-DOF C physics engine (`libsim`), and a real-time browser telemetry dashboard (`cla_gui.py`).

Key highlights:

- **8-Stage Deterministic Pipeline (`F1 → F2 → D1 → D2 → R1 → R2 → E → W`):** Custom Harvard architecture with dedicated instruction fetch, combinational decode, effective address & branch resolution, memory read, execute, and writeback stages.
- **Full 78-Encoding 32-Bit CLA ISA:** Implements IEEE-754 single-precision floating-point (`MADDF32`, `MSUBF32`, `MMPYF32`), **Parallel Dual-Issue** instructions (`MMACF32 || MMOV32`, `MMPYF32 || MADDF32`, `MMPYF32 || MSUBF32`), single-cycle LUT-based $1/x$ (`MEINVF32`) and $1/\sqrt{x}$ (`MEISQRTF32`) seed estimators, type conversions (`MI16TOF32`, `MF32TOI16R`), and delayed conditional branches (`MBCNDD`, `MCCNDD`, `MRCNDD`).
- **Event-Driven 8-Task Hardware Arbiter (`Task 1–8`):** No `while(1)` polling loop or OS scheduler overhead. Hardware triggers (`hw_task_trig`) or software forces (`MIFRC`) launch prioritized tasks directly from independent vector registers (`MVECT1–8`).
- **2-Stage Pipelined FP32 Arithmetic (`K1 / K2`) & Zero-Cycle Flag Forwarding:** Splits 32-bit floating-point addition and multiplication across `Execute` (`K1`) and `Write` (`K2`) while forwarding in-flight `LVF/LUF` flags (`gorunen_5`, `gorunen_32`) back to `Decode2` and `Execute` with zero stall penalty.
- **4-Write-Port Result Register File (`MR0–MR3`):** Sustains simultaneous writebacks from dual-issue E-stage operations and completing W-stage `K2` adder/multiplier pipelines in a single clock cycle under strict hardware priority (`E1 > E2 > adder K2 > multiplier K2`).
- **Bit-True Golden Model & KV260 Hardware-in-the-Loop Verification:** Every control step executed on the physical KV260 FPGA fabric is verified bit-for-bit against the cycle-accurate Python Golden Model (`pc/core.py`) and C reference implementation across all 64 words of the `C2M` Message RAM.

## Why It Matters

High-frequency closed-loop control (such as 1–100 kHz current, velocity, and attitude loops in motor drives and autonomous aerial vehicles) has a strict contract with physics: **a mathematically correct control command that arrives late is a wrong command.**

When control loops run on a general-purpose CPU, they compete with communication stacks, telemetry logging, sensor drivers, and operating system interrupts. Cache misses, interrupt entry/exit latency, and context switches introduce timing **jitter**—variable delay between sensor sampling and actuator update—which erodes phase margin and destabilizes fast control loops.

On **yonga-cla**, the control loop is completely offloaded from the main processor (Zynq PS / CPU) into an independent, deterministic co-processor with its own program memory (`L3`), local data scratchpads (`L1`, `L2`), and dedicated bridge memories (`M2C` and `C2M` Message RAMs).

| Metric | General-Purpose CPU | Hardwired Fixed-Function RTL | **yonga-cla (Programmable Co-Processor)** |
| :--- | :--- | :--- | :--- |
| **Execution model** | Sequential instructions + OS/ISR overhead | Fixed datapath state machine | **8-stage pipeline + Dual-Issue (`Math \|\| Load/Store`)** |
| **Loop latency jitter** | High (cache misses, interrupt latency) | Zero | **Zero (cycle-exact, interrupt-free task execution)** |
| **CPU load during loop** | 100% of core occupied | 0% | **0% (CPU only writes `M2C` and reads `C2M` on IRQ)** |
| **Algorithm flexibility** | High (recompile C code) | Low (requires full FPGA resynthesis) | **High (reassemble `.casm` into `L3` hex in <1 second)** |
| **Data representation** | IEEE-754 FP32 | Often fixed-point to save LUTs | **Full 32-bit IEEE-754 FP32 + 32-bit Integer** |

## What is a Control Law Accelerator (CLA)?

A **Control Law Accelerator** is a specialized, event-driven floating-point microprocessor designed specifically to execute time-critical control algorithms alongside a host CPU. Originally introduced in Texas Instruments' C2000 real-time microcontrollers (TMS320F2803x Type-0 CLA), it bridges the gap between inflexible hardwired RTL blocks and jitter-prone general-purpose CPUs.

### The Core Idea

Instead of running an infinite `main()` loop, the CLA sleeps in an idle state (`BOSTA`) consuming no memory bandwidth until a control sample arrives:

1. **Trigger (`MPERINT` / `MIFRC`):** When an ADC conversion completes or the host CPU writes to the force register (`MIFRC`), the corresponding bit in the Interrupt Flag Register (`MIFR`) latches high.
2. **Hardware Arbitration (`cla_gorev_denetci`):** A fixed-priority hardware arbiter (`Task 1` highest priority, `Task 8` lowest) selects the highest-priority enabled task (`MIFR & MIER`), sets its running bit in `MIRUN`, and loads its starting program counter directly from `MVECT[k]` into `Fetch1`.
3. **Zero-Copy Shared Memory (`M2C` & `C2M`):** The task reads sensor states and gains from the **CPU-to-CLA (`M2C`)** Message RAM (`0x1500`), uses local **L1/L2 Data RAMs** (`0x8800`, `0x8C00`) for intermediate scratchpad variables, and writes updated actuator commands and filter states into the **CLA-to-CPU (`C2M`)** Message RAM (`0x1480`).
4. **Completion (`MSTOP`):** The task ends with an `MSTOP` instruction, which flushes the front-end pipeline, clears `MIRUN`, and fires a task-specific completion interrupt (`pie_kesme` / AXI `irq`) to notify the host processor.

```text
Host CPU / Zynq PS (AXI4-Lite)                       yonga-cla Co-Processor (FPGA PL)
┌────────────────────────────┐                       ┌──────────────────────────────────────────────────┐
│ 1. Write sensors to M2C    │ ─── M2C (0x1500) ───► │                                                  │
│ 2. Trigger task via MIFRC  │ ─── MVECT1..8 ──────► │ F1 ──► F2 ──► D1 ──► D2 ──► R1 ──► R2 ──► E ──► W│
│ 3. Free to run comms/UI    │                       │                      │                    │      │
│ 4. Read actuators from C2M │ ◄── C2M (0x1480) ──── │              MSTOP (Task Done)      MR0-MR3 / RAM│
│    on level-high IRQ       │ ◄── irq (0x040) ───── │                      │                           │
└────────────────────────────┘                       └──────────────────────┴───────────────────────────┘
```

## Mathematical Background & Drone Control Law

To prove the hardware on a realistic, non-trivial multi-variable control problem, **yonga-cla** runs a **431-instruction multi-rate cascaded 6-DOF quadrotor flight controller with a velocity-based disturbance observer** (`gui/drone_uret.py` $\to$ `gui/drone.casm`).

### Multi-Rate Cascaded Control Architecture

A quadrotor is an underactuated 6-DOF system with fast rotational dynamics and slower translational dynamics. Our CLA firmware partitions the controller into five prioritized hardware tasks triggered at different rates relative to the 1 kHz base physics tick:

| Task | Entry (`MVECT`) | Execution Rate | Control Loop Function |
| :--- | :--- | :--- | :--- |
| **Task 1** | `0x000` | **1 kHz** (Every step) | **Angular Rate Loop (PI + Derivative-on-Measurement) & 4-Motor Mixer** |
| **Task 2** | `0x0CE` | **500 Hz** (Every 2 steps) | **Attitude Loop (Roll, Pitch, Yaw Proportional Control)** |
| **Task 3** | `0x118` | **100 Hz** (Every 10 steps) | **Position (P) $\to$ Velocity (PI + Feedforward) $\to$ Tilt & Thrust Reference** |
| **Task 4** | `0x24E` | **100 Hz** (Every 10 steps) | **Velocity-Based Disturbance Observer (Wind & Impulse Estimator)** |
| **Task 8** | `0x318` | On Reset (`SK_SIFIRLA`) | **State Initialization (Clears all 33 persistent state words in `C2M`)** |

### 1. Task 1: Angular Rate Loop (PI-D) and Motor Mixer (1 kHz)

For each body angular rate axis $\omega \in \{r, p, q\}$ with reference $\omega_{\text{ref}}$, error $e_\omega[k] = \omega_{\text{ref}}[k] - \omega[k]$, and anti-windup integral state $I_\omega[k]$, the derivative term is computed on the **measured angular rate** $(\omega[k] - \omega[k-1])$ rather than on the error to prevent derivative kick on reference step changes:

$$I_\omega[k] = \text{clip}\!\Bigl(I_\omega[k-1] + K_{i,r}\,e_\omega[k],\ -I_{\max,r},\ +I_{\max,r}\Bigr)$$

$$\delta_\omega[k] = \text{clip}\!\Bigl(K_{p,r}\,e_\omega[k] + I_\omega[k] - K_{d,r}\bigl(\omega[k] - \omega[k-1]\bigr),\ -d_{\max},\ +d_{\max}\Bigr)$$

The resulting roll ($\delta_x$), pitch ($\delta_y$), and yaw ($\delta_z$) torque commands are combined with the collective thrust command $T$ in the quadrotor X-configuration mixer and clamped to $[0, 1]$ using `MMINF32` and `MMAXF32`:

$$u_1 = \text{clip}_{[0,1]}(T - \delta_y + \delta_z), \quad u_2 = \text{clip}_{[0,1]}(T + \delta_x - \delta_z), \quad u_3 = \text{clip}_{[0,1]}(T + \delta_y + \delta_z), \quad u_4 = \text{clip}_{[0,1]}(T - \delta_x - \delta_z)$$

### 2. Task 2: Attitude Loop (500 Hz)

Converts roll ($\phi$), pitch ($\theta$), and yaw ($\psi$) angle errors into body angular rate references:

$$\omega_{\text{ref},i} = \text{clip}\!\Bigl(K_{a,i}\bigl(\theta_{\text{ref},i} - \theta_i\bigr),\ -\omega_{\max,i},\ +\omega_{\max,i}\Bigr), \qquad i \in \{x, y, z\}$$

### 3. Task 3: Position & Velocity Loop with Observer Bumpless Transfer (100 Hz)

For each translational axis $i \in \{x, y, z\}$, position error drives a clamped velocity reference $v_{\text{ref},i}$, which in turn drives a PI velocity controller compensated by the disturbance observer estimate $\hat{e}_{d,i}$:

$$v_{\text{ref},i} = \text{clip}\!\Bigl(K_{p,p}\bigl(p_{\text{ref},i} - p_i\bigr),\ -v_{\max},\ +v_{\max}\Bigr), \qquad e_{v,i} = v_{\text{ref},i} - v_i$$

$$I_{v,i}[k] = \text{clip}\!\Bigl(I_{v,i}[k-1] + (\gamma_{\text{ff}}[k] - \gamma_{\text{ff}}[k-1])\hat{e}_{d,i} + K_{i,v}\,e_{v,i},\ -I_{\max,v},\ +I_{\max,v}\Bigr)$$

$$a_{\text{cmd},i} = K_{p,v}\,e_{v,i} + I_{v,i}[k] - \gamma_{\text{ff}}[k]\,\hat{e}_{d,i}$$

Notice the term $(\gamma_{\text{ff}}[k] - \gamma_{\text{ff}}[k-1])\hat{e}_{d,i}$: when the disturbance observer feedforward flag $\gamma_{\text{ff}} \in \{0, 1\}$ is toggled on or off in flight, shifting the velocity integrator by $\Delta\gamma_{\text{ff}}\,\hat{e}_{d,i}$ guarantees **bumpless transfer** with zero acceleration jump. Desired horizontal accelerations $(a_{\text{cmd},x}, a_{\text{cmd},y})$ are then rotated by yaw $\psi$ and converted into pitch/roll references and tilt-compensated thrust $T$:

$$\theta_{\text{ref}} = \text{clip}\!\left(\frac{\cos\psi\,a_{\text{cmd},x} + \sin\psi\,a_{\text{cmd},y}}{g},\ -\theta_{\max},\ +\theta_{\max}\right), \qquad \phi_{\text{ref}} = \text{clip}\!\left(\frac{\sin\psi\,a_{\text{cmd},x} - \cos\psi\,a_{\text{cmd},y}}{g},\ -\theta_{\max},\ +\theta_{\max}\right)$$

$$T = \text{clip}_{[T_{\min}, T_{\max}]}\!\left(c_T (g + a_{\text{cmd},z})\Bigl(1 + \frac{\phi^2 + \theta^2}{2}\Bigr)\right)$$

### 4. Task 4: Velocity-Based Disturbance Observer (100 Hz)

Using the nominal thrust acceleration $A = T / c_T$ and measured Euler angles, Task 4 computes the nominal model accelerations $(a_{m,x}, a_{m,y}, a_{m,z})$ and updates a Luenberger-style velocity and disturbance acceleration observer $(\hat{v}_i, \hat{e}_{d,i})$ to reject wind gusts, external impulses, rotor efficiency loss, and payload changes:

$$a_{m,x} = A(\cos\psi\,\theta + \sin\psi\,\phi), \qquad a_{m,y} = A(\sin\psi\,\theta - \cos\psi\,\phi), \qquad a_{m,z} = A\Bigl(1 - \frac{\phi^2 + \theta^2}{2}\Bigr) - g$$

$$e_{\text{obs},i} = v_i - \hat{v}_i, \qquad \hat{v}_i[k+1] = \hat{v}_i[k] + T_{s,\text{obs}}\bigl(a_{m,i} + \hat{e}_{d,i}[k]\bigr) + l_1\,e_{\text{obs},i}, \qquad \hat{e}_{d,i}[k+1] = \text{clip}\!\bigl(\hat{e}_{d,i}[k] + l_2\,e_{\text{obs},i},\ -e_{\max},\ +e_{\max}\bigr)$$

## Architecture

### What We Actually Built

**yonga-cla** is an 8-stage pipelined processor (`CLA_Top.sv`) wrapped in an AXI4-Lite slave peripheral (`CLA_AXI_Lite.sv` and `cla_wrapper.v`). Every clock cycle, up to 8 instructions are simultaneously in flight across the pipeline stages:

```text
[F1: Fetch1] ──► [F2: Fetch2] ──► [D1: Decode1] ──► [D2: Decode2] ──► [R1: Read1] ──► [R2: Read2] ──► [E: Execute (K1)] ──► [W: Write (K2)]
     │                │                │                 │                │               │                   │                   │
  getir_pc      L3 Program RAM    cla_decoder      Eff. Address &    L1/L2 & C2M/M2C   Latch RAM Data   ALU, Estimator,     FP32 K2 Result,
  MVECT / Br.    (2K x 32-bit)   (Combinational)   Branch / MSTOP    Port Mux & Stall  (okunan_tut)     Conv., FP32 K1      MR0-3 & RAM Write
```

- **Stage 1 — `Fetch1` (`F1`):** Maintains the 12-bit instruction fetch counter (`getir_pc`). Selects between task launch address (`mvect_pc`), taken branch target from `D2` (`dal_hedef`), or sequential `getir_pc + 2` (each 32-bit instruction spans two 16-bit word addresses). Drives the 11-bit row address `l3_adr = getir_pc[11:1]` to `L3` program memory. When no task is active (`getir_izin = 0`), injects bubbles (`f1f2_gecerli = 0`).
- **Stage 2 — `Fetch2` (`F2`):** Houses the `4096 × 16-bit` (`2048 × 32-bit`) **L3 Program BRAM** initialized via `$readmemh(PROGRAM_HEX, l3)`. Concatenates the high and low 16-bit words `{l3[{l3_adr, 1'b1}], l3[{l3_adr, 1'b0}]}` into a 32-bit instruction `{MSW, LSW}` and latches `F2/D1`.
- **Stage 3 — `Decode1` (`D1`):** Runs the purely combinational `cla_decoder` over `f2d1_kelime` using a parallel `unique casez` table across all 78 TI Type-0 CLA instruction patterns, latching the operation enum (`d1d2_op`), normalized operand bundle (`d1d2_alan`), and reserved addressing mode flag (`d1d2_kip_gecersiz`) into `D1/D2`.
- **Stage 4 — `Decode2` (`D2`):** Generates the static control packet (`kontrol_t`) via `cla_ctrl_gen`. Computes the 16-bit effective address (`ea = m` for direct mode `0000`, `ea = mar0` for `*MAR0[#imm]++`, or `ea = mar1` for `*MAR1[#imm]++`) and schedules the post-increment `MARx <= ea + m`. Evaluates conditional branches (`MBCNDD`, `MCCNDD`, `MRCNDD`) against the forwarded status flags (`gorunen_5`), saves `RPC <= pc + 8` on taken calls (`MCCNDD`), updates architectural `MPC`, and signals `MSTOP` or illegal opcodes to `cla_gorev_denetci`.
- **Stage 5 — `Read1` (`R1`):** Decodes `d2r1_ea` into one of four memory blocks (`L1`, `L2`, `C2M`, `M2C`) and arbitrates each single-port RAM bank between `R1` reads and `W` writes. If `W` is writing to `L1`, `L2`, or `C2M` while `R1` needs to read from the same bank, `Read1` gives priority to the `W` write, asserts `dur_r1 = 1` to freeze `F1..D2/R1` for 1 cycle, and injects a bubble into `R1/R2`.
- **Stage 6 — `Read2` (`R2`):** Multiplexes the returning 32-bit read data (`l1_dout`, `l2_dout`, `c2m_dout`, `m2c_dout`) and preserves it in a shadow hold register (`okunan_tut`) whenever `Execute` stalls (`dur_exe`), latching the operand into `R2/E`.
- **Stage 7 — `Execute` (`E`):** Reads `MR0–MR3`, expands immediate constants (`#16FHi`, `MMOVIZ`, `MMOVXI`, `#SHIFT`), evaluates conditional execution predicates (`kosul_tuttu`), and drives the `ALU`. Completes single-cycle operations (32-bit integer ALU, FP32 compare/min/max/abs/neg, int/float conversions, `MFRACF32`, and LUT-based `MEINVF32`/`MEISQRTF32` estimates) and launches Stage 1 (`K1`) of the 2-cycle pipelined FP32 adder (`fpu_toplama`) and multiplier (`fpu_carpma`).
- **Stage 8 — `Write` (`W`):** Houses the architectural `MR0–MR3` register file (4 write ports) and `MSTF` status register. Completes Stage 2 (`K2`) of the FP32 adder and multiplier, arbitrates up to 4 simultaneous register writes (`e_yaz1`, `e_yaz2`, `valid_topla`, `valid_carp`), drives memory store requests back to `Read1`, detects `E/W` K2 read-after-write hazards (`dur_exe`), and forwards live `MSTF` flags (`gorunen_5`, `gorunen_32`).

### CLA Memory Map (16-Bit Word Addressed)

<img width="576" height="494" alt="0" src="https://github.com/user-attachments/assets/4e7628fa-633b-4b79-811a-2e14991532ae" />

| Memory Region | Address Range (16-Bit Word) | Capacity | Access Rules & Role |
| :--- | :--- | :--- | :--- |
| **C2M Message RAM** | `0x1480 – 0x14FF` | `128 × 16-bit` (`64 × 32-bit`) | CLA Read/Write, CPU Read-Only (`0x200–0x2FC` on AXI). Holds actuator outputs (`u1..u4`) and persistent controller states. |
| **M2C Message RAM** | `0x1500 – 0x157F` | `128 × 16-bit` (`64 × 32-bit`) | CPU Read/Write (`0x100–0x1FC` on AXI), CLA Read-Only. Holds sensor measurements, target setpoints, and controller gains. |
| **L1 Data RAM** | `0x8800 – 0x8BFF` | `1024 × 16-bit` (`2 KB`) | CLA local Read/Write scratchpad BRAM bank 1 (`cla_data_ram`). |
| **L2 Data RAM** | `0x8C00 – 0x8FFF` | `1024 × 16-bit` (`2 KB`) | CLA local Read/Write scratchpad BRAM bank 2 (`cla_data_ram`). |
| **L3 Program RAM** | `0x0000 – 0x0FFF` (`MPC`) | `4096 × 16-bit` (`2048 × 32-bit`) | 12-bit word-addressed instruction BRAM inside `Fetch2` (`drone_l3.hex`). |

### AXI4-Lite Register Map (`CLA_AXI_Lite.sv`)

Mapped into a 4 KB aperture on the Zynq UltraScale+ `HPM0` bus (recommended base address `0xA001_0000`):

| Byte Offset | Register Name | Access | Description |
| :--- | :--- | :--- | :--- |
| `0x000` | `MIFR` | R | Interrupt Flag Register (bit $i$: Task $i+1$ pending) |
| `0x004` | `MIOVF` | R | Interrupt Overflow Flag Register (bit $i$: trigger arrived while `MIFR[i]` was already 1) |
| `0x008` | `MICLR` | W | Interrupt Clear Register (writing 1 clears the corresponding `MIFR` bit) |
| `0x00C` | `MICLROVF` | W | Interrupt Overflow Clear Register (writing 1 clears the corresponding `MIOVF` bit) |
| `0x010` | `MIFRC` | W | Interrupt Force Register (writing 1 triggers Task $i+1$ in software) |
| `0x014` | `MIER` | RW | Interrupt Enable Register (bit $i$: enables Task $i+1$ for arbitration) |
| `0x018` | `MIRUN` | R | Interrupt Run Register (bit $i$: Task $i+1$ is currently executing in the pipeline) |
| `0x01C` | `MCTL` | W | Control Register (`bit 0`: `HARDRESET`, `bit 1`: `SOFTRESET`, `bit 2`: `IACKE`) |
| `0x020 – 0x03C` | `MVECT1 – MVECT8` | RW | 16-bit starting program counter (`MPC`) word addresses for Tasks 1–8 |
| `0x040` | `IRQ_DURUM` | R / W1C | Latches rising edges of `pie_kesme[7:0]`; write 1 to clear |
| `0x044` | `IRQ_MASKE` | RW | Interrupt mask register (`irq = \|(IRQ_DURUM & IRQ_MASKE)`) |
| `0x048` | `KONTROL` | RW | `bit 0` (`CLA_SIFIRLA`): holds `CLA_Top` in reset while keeping AXI and Message RAMs active |
| `0x04C` | `KIMLIK` | R | Hardware ID constant `0x434C_4101` (`"CLA"` + version `01`) for bitstream verification |
| `0x100 – 0x1FC` | `M2C[0..63]` | RW | 64 × 32-bit CPU-to-CLA Message RAM window |
| `0x200 – 0x2FC` | `C2M[0..63]` | R | 64 × 32-bit CLA-to-CPU Message RAM window |

## Engineering & Algorithm Explanations

This section walks through the specific hardware design decisions across the RTL modules: why the datapath is structured the way it is, how hazards are resolved without corrupting state, and how multi-cycle floating-point operations coexist with single-cycle instructions.

### 1. Parallel Dual-Issue Execution & The 4-Write-Port Register File

```systemverilog
// Write.sv — 4-port MR writeback priority network (E1 > E2 > Adder K2 > Multiplier K2)
always_comb begin
    e1_maske = e_yaz1 ? (4'b0001 << e_hedef1) : 4'b0000;
    e2_maske = e_yaz2 ? (4'b0001 << e_hedef2) : 4'b0000;
    t_maske  = (valid_topla & ~dondur) ? (4'b0001 << hedef_mr_out_topla) : 4'b0000;
    c_maske  = (valid_carp  & ~dondur) ? (4'b0001 << hedef_mr_out_carp)  : 4'b0000;

    mr_en = e1_maske | e2_maske | t_maske | c_maske;

    for (int x = 0; x < 4; x++) begin
        if (e1_maske[x])      mr_veri[x] = e_veri1;
        else if (e2_maske[x]) mr_veri[x] = e_veri_2;
        else if (t_maske[x])  mr_veri[x] = result_topla;
        else                  mr_veri[x] = result_carp;
    end
end
```

In tight control loops (such as FIR/IIR filters and PID controllers), a naive processor wastes half its cycles moving data between memory and registers before it can multiply or accumulate. The TI Type-0 CLA ISA solves this with **Dual-Issue** instructions that pack two independent operations into a single 32-bit instruction word:

- **Math + Memory Load/Store:** `MMACF32 MR3, MR2, MRd, MRe, MRf || MMOV32 MRa, mem32` simultaneously performs `MR3 = MR3 + MR2` (adder), `MRd = MRe * MRf` (multiplier), and loads `MRa` from memory (`mem32`).
- **Math + Math:** `MMPYF32 MRa, MRb, MRc || MADDF32 MRd, MRe, MRf` launches an FP32 multiply and an FP32 add in the same clock cycle.

Because E-stage single-cycle instructions (like `MMOV32 MRa, mem32` or `MSWAPF` which writes two registers at once) complete at the end of `E` while 2-cycle FP32 additions and multiplications launched one cycle earlier complete at the end of `W` (`K2`), **up to four distinct register writes can retire on the same rising clock edge**. Rather than stalling the pipeline on write-port structural hazards, `Write.sv` provides four concurrent write ports into `MR0–MR3` with deterministic priority (`E1 > E2 > adder K2 > multiplier K2`), so a younger single-cycle write in `E` cleanly supersedes an older `K2` write targeting the same register.

### 2. Splitting FP32 Add & Multiply Across `E` (`K1`) and `W` (`K2`)

```systemverilog
// fpu_toplama.sv — 70-bit K1->K2 internal pipeline register
always_ff @(posedge clk or negedge rst) begin
    if (!rst)
        k_yazmaci <= 70'b0;
    else
        k_yazmaci <= {valid, hedef_mr, rnd, out_sign, out_exp,
                      out_mantissa_a, out_mantissa_b, cik, out_kod};
end
```

A single-cycle 32-bit IEEE-754 floating-point adder requires exponent comparison, a 24-bit right barrel shifter, a 27-bit adder/subtractor, a leading-zero counter (LZC), a left normalization barrel shifter, and round-to-nearest-even logic—creating a deep combinational path that limits FPGA clock frequency.

We split both `fpu_toplama` and `fpu_carpma` across the `Execute` (`K1`) and `Write` (`K2`) stages:
- **In `fpu_toplama`:** `topla_k1.sv` (`E` stage) compares magnitudes, shifts the smaller 24-bit mantissa right by up to 26 bits while forming Guard, Round, and Sticky bits, and latches the two aligned 27-bit significands into the 70-bit `k_yazmaci`. In the next cycle (`W` stage), `topla_k2.sv` performs the 27-bit addition/subtraction, counts leading zeros from bit 26 down to 0, normalizes the result, and passes it to `pack.sv` for IEEE-754 rounding (`RZ` or `RNE`) and `LVF/LUF` flag generation.
- **In `fpu_carpma`:** `carp_k1.sv` (`E` stage) computes the `24 × 24-bit` significand product (`48 bits`) and unbiased exponent sum (`exp_a + exp_b - 127`), latching them into the 65-bit `k_yazmaci`. In the `W` stage, `carp_k2.sv` inspects bit 47 to normalize the product and extracts `G, R, S` bits for `pack.sv`.
- **RAW Hazard Interlock (`dur_exe`):** Because `K2` writes its target register at the end of `W`, if the immediately following instruction in `E` reads that same `MRx` (`|(okunan_mr & k2_maske)`), `Write.sv` asserts `dur_exe = 1` for exactly 1 cycle, holding `F1..R2/E` while letting `W` finish and write the register.

### 3. Zero-Cycle Flag Forwarding: `"Görünen MSTF"`

```systemverilog
// Write.sv — Forwarding in-flight K2 LVF/LUF and D2 RPC updates into gorunen_5 & gorunen_32
assign gorunen_lvf = lvf_q | lvf_topla | lvf_carp;
assign gorunen_luf = luf_q | luf_topla | luf_carp;
assign gorunen_rpc = rpc_en ? rpc_deger : rpc_q;

assign gorunen_5  = {tf_q, zf_q, nf_q, gorunen_luf, gorunen_lvf};
assign gorunen_32 = {8'h00, gorunen_rpc, meallow_q, 1'b0, rnd32_q,
                     2'b00, tf_q, 2'b00, zf_q, nf_q, gorunen_luf, gorunen_lvf};
```

When a conditional branch (`MBCNDD`, `MCCNDD`, `MRCNDD`) in `Decode2` or a conditional instruction (`MNEGF32`, `MMOV32`, `MTESTTF`) in `Execute` tests the status flags (`TF, ZF, NF, LUF, LVF`), an FP32 add or multiply in the `Write` (`K2`) stage may be asserting `lvf` or `luf` on that exact clock cycle. Similarly, a call instruction (`MCCNDD`) in `D2` updates `RPC` while an instruction in `E` may be storing `MSTF` to memory (`MMOV32 mem32, MSTF`).

By combinationally OR-ing the live K2 `lvf_topla / lvf_carp` and `luf_topla / luf_carp` signals with the registered `lvf_q / luf_q` flags and multiplexing `rpc_deger` when `rpc_en` is active, `Write.sv` exports the **"visible MSTF"** (`gorunen_5` and `gorunen_32`), eliminating flag-forwarding stalls.

### 4. Single-Port BRAM Bank Conflict Stall (`dur_r1`) & Shadow Read Latch (`okunan_tut`)

```systemverilog
// Read1.sv — Single-port RAM bank conflict detection (W write has priority over R1 read)
dur_r1 = d2r1_gecerli & (d2r1_k.bellek_oku != ERISIM_YOK) & r1_blok_var & (r1_blok != 2'b11) &
         (w_wr_en != 2'b00) & (w_blok == r1_blok);

// Read2.sv — Shadow hold register preserving RAM read data across dur_exe stalls
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        taze       <= 1'b0;
        okunan_tut <= 32'h0000_0000;
    end else begin
        taze <= en;
        if (taze) okunan_tut <= okunan_canli;
    end
end
assign okunan = taze ? okunan_canli : okunan_tut;
```

Each local data memory (`L1`, `L2`) and the CLA side of `C2M` is a single-port synchronous BRAM (`1024 × 16-bit` or `128 × 16-bit`) capable of one 16/32-bit access per cycle. Two subtle pipeline interactions arise:
1. **`R1` vs. `W` Bank Collision (`dur_r1`):** If an older store instruction in `Write` (`W`) writes to the same RAM bank (`L1`, `L2`, or `C2M`) that a younger load instruction in `Read1` (`R1`) wants to read, `Read1.sv` routes the `W` write address and data to the RAM port, asserts `dur_r1 = 1` to hold `F1..D2/R1`, and injects a 1-cycle bubble into `R1/R2`. (Reads from `M2C` never stall because the CLA cannot write to `M2C`.)
2. **Preserving `R2` Data During `dur_exe` (`okunan_tut`):** When `Read1` does not read a RAM bank (or during a stall), `cla_data_ram` drives `dout <= 0` on the next clock edge. If `Read2` is stalled by `dur_exe`, the live RAM output `okunan_canli` is only valid on the first cycle after `R1/R2` advances (`taze == 1`). `Read2.sv` latches `okunan_canli` into `okunan_tut` when `taze` is high and seamlessly switches `okunan` to `okunan_tut` if the stall persists.

### 5. Shared 1024×8-Bit LUT for `1/x` and `1/√x` (`kestirme.sv`)

```systemverilog
// kestirme.sv — Single 1024x8 ROM serving both MEINVF32 (1/x) and MEISQRTF32 (1/sqrt(x))
if (op_type == 1'b0) begin
    // MEINVF32 (1/x): upper 256 entries (0x200..0x2FF)
    address  = {2'b10, mantissa[22:15]};
    estimate = mem[address];
    result   = {sign, 8'(253 - exp), estimate, 15'b0};
end else begin
    // MEISQRTF32 (1/sqrt(x)): lower 512 entries (0x000..0x1FF), split by exponent parity exp[0]
    address  = {1'b0, exp[0], mantissa[22:15]};
    estimate = mem[address];
    result   = {1'b0, 8'((380 - exp) >> 1), estimate, 15'b0};
end
```

Division and vector normalization ($1/\sqrt{x^2 + y^2 + z^2}$) are ubiquitous in motor and flight control, yet iterative hardware dividers stall pipelines for puluhan cycles. Following the TI Type-0 CLA specification, `kestirme.sv` provides single-cycle 8-bit mantissa seed estimates (`MEINVF32` and `MEISQRTF32`) from a single `1024 × 8-bit` table (`estimate_lut.hex`):
- **`MEISQRTF32` ($1/\sqrt{x}$):** Uses addresses `0x000–0x1FF` (`{1'b0, exp[0], mantissa[22:15]}`), selecting between even-exponent and odd-exponent tables via `exp[0]` and computing the biased output exponent as `(380 - exp) >> 1`.
- **`MEINVF32` ($1/x$):** Uses addresses `0x200–0x2FF` (`{2'b10, mantissa[22:15]}`) and computes the biased output exponent as `253 - exp`. One or two subsequent Newton-Raphson `MMPYF32` / `MSUBF32` iterations refine this seed to full 23-bit IEEE-754 precision.

## Directory Structure

| Path | Description |
| :--- | :--- |
| `rtl/cla/cla_wrapper.v` | Verilog-2001 top-level wrapper with Vivado BD `X_INTERFACE_INFO` attributes. |
| `rtl/cla/CLA_AXI_Lite.sv` | 4 KB AXI4-Lite slave interface integrating `CLA_Top` and `M2C`/`C2M` Message RAMs. |
| `rtl/cla/cla_mesaj_ram.sv` | Dual-interface 16/32-bit Message RAM (`M2C` at `0x1500`, `C2M` at `0x1480`). |
| `rtl/cla/top/` | `CLA_Top.sv`, the 8 pipeline stage modules (`Fetch1.sv` .. `Write.sv`), and `Gorev_Yazmaclari.sv`. |
| `rtl/cla/kontrol/` | `cla_pkg.sv` (ISA & control types), `cla_decoder.sv`, `cla_ctrl_gen.sv`, and `cla_gorev_denetci.sv`. |
| `rtl/cla/yazmac_bellek/` | `cla_data_ram.sv` (`L1`/`L2`), `cla_mr_regs.sv`, `cla_mar_regs.sv`, `cla_mstf_reg.sv`, `cla_mvect_regs.sv`, `cla_ctrl_regs.sv`. |
| `rtl/cla/alu/` | `ALU.sv`, `tamsayi_islem.sv`, `fpu_kestirme.sv` (`kestirme.sv`), `fpu_karsilastirma.sv` (`karsilastirma.sv`), `fpu_donusum.sv` (`donusum.sv`), and `kayan_nokta birimi/` (`clasify.sv`, `pack.sv`, `fpu_carpma.sv`, `fpu_toplama.sv`). |
| `pc/core.py` | Single-file TI Type-0 CLA Golden Model, 8-stage pipeline simulator, assembler, disassembler, and static linter. |
| `pc/cla_golden.py` | `GoldenCla` wrapper running step-by-step `(mask, M2C, C2M_in) -> (C2M_out, cycles)` verification. |
| `pc/sim_baglanti.py` | Python `ctypes` bindings to the 6-DOF quadrotor physics & C reference library (`libsim.dll` / `libsim.so`). |
| `pc/kv260_link.py` | Binary TCP client (`port 5001`, `MAGIC = 0x5244`) communicating with `radar_server` on the Kria KV260. |
| `pc/kart_test.py` | Automated 4-stage Hardware-in-the-Loop (HIL) test suite comparing KV260 FPGA silicon against `core.py`. |
| `pc/cla_gui.py` & `.html` | Real-time browser telemetry & disturbance injection dashboard (`http://localhost:8081`). |
| `gui/drone_uret.py` | Code generator producing the 431-instruction multi-rate flight controller (`drone.casm`). |
| `gui/derle.py` | Assembles and lints `drone.casm`, outputting `drone_l3.hex` and `sw/drone_cla.h`. |
| `gui/cla_dongu.py` | Headless closed-loop simulation runner (verifies Golden Model against C reference over 10,000 steps). |
| `mem/` | Memory initialization images (`drone_l3.hex` and `estimate_lut.hex`). |
| `sw/drone_cla.h` | Auto-generated C header with `DRONE_CLA_KOMUT` (`431`), `DRONE_CLA_CRC` (`0x276C7CCB`), and `MVECT1..8`. |
| `sistem_test.bat` | One-click Windows batch script to regenerate `drone.casm`, assemble `drone_l3.hex`, and run `kart_test.py`. |

## Modules

### `CLA_AXI_Lite.sv` & `cla_wrapper.v`

Bridges the 32-bit Zynq UltraScale+ AXI4-Lite bus to the 16-bit word-addressed `CLA_Top` core and instantiates the `M2C` and `C2M` `cla_mesaj_ram` blocks.

**Key Ports (`cla_wrapper.v`):**

| Port | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `s_axi_aclk` | Input | 1 bit | Shared AXI4-Lite and CLA core clock (`pl_clk0`) |
| `s_axi_aresetn` | Input | 1 bit | Active-low synchronous/asynchronous reset |
| `s_axi_awaddr` / `araddr` | Input | 12 bits | 4 KB byte address (`0x000–0x2FC` active) |
| `s_axi_wdata` / `rdata` | In / Out | 32 bits | 32-bit AXI4-Lite write and read data buses |
| `s_axi_wstrb` | Input | 4 bits | Byte lane write strobes (`[1:0]` low halfword, `[3:2]` high halfword) |
| `irq` | Output | 1 bit | Level-high interrupt output (`\|(IRQ_DURUM & IRQ_MASKE)`) to Zynq PS |

### `CLA_Top.sv`

Top-level processor core connecting `Gorev_Yazmaclari`, `cla_mvect_regs`, `cla_gorev_denetci`, the 8 pipeline stages (`Fetch1`..`Write`), and the two `1024 × 16-bit` local data RAMs (`L1` and `L2`).

**Ports:**

| Port | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `clk`, `rst_n` | Input | 1 bit | System clock and active-low reset |
| `cpu_wr_en`, `cpu_reg_addr`, `cpu_wr_data` | Input | 1, 3, 16 bits | CPU write interface for task registers `0..7` |
| `cpu_rd_data` | Output | 16 bits | CPU readback value from selected task register |
| `mvect_wr_en`, `mvect_gorev`, `mvect_veri` | Input | 1, 3, 16 bits | CPU write interface for `MVECT1–8` |
| `mvect_oku` | Output | 16 bits | CPU readback value from `MVECT1–8` |
| `hw_task_trig` | Input | 8 bits | Rising-edge hardware triggers for Tasks 1–8 |
| `pie_kesme` | Output | 8 bits | Single-cycle task completion pulse bus |
| `mirun` | Output | 16 bits | Active task running bitmask (`MIRUN`) |
| `bosta` | Output | 1 bit | High when no task is active and the pipeline has fully drained |
| `m2c_addr`, `m2c_rd_en`, `m2c_dout` | Out / In | 7, 2, 32 bits | Read interface to external `M2C` Message RAM |
| `c2m_addr`, `c2m_wr_en`, `c2m_rd_en`, `c2m_din`, `c2m_dout` | Out / In | 7, 2, 2, 32, 32 bits | Read/Write interface to external `C2M` Message RAM |

### `ALU.sv` and Submodules (`rtl/cla/alu/`)

<img width="1280" height="863" alt="2aa4da1c-78cc-4dc2-ab34-930584cdd5b6" src="https://github.com/user-attachments/assets/906400e9-d2a4-43c6-bd02-37753d5ff0cc" />

Central execution engine driven by `Execute.sv`. Routes four 32-bit operands (`a, b, c, d`) through ten 2-bit input multiplexers (`mux_1..mux_10`) into six specialized units:

| Submodule | Latency | Supported Instructions |
| :--- | :--- | :--- |
| `fpu_toplama.sv` (`topla_k1`, `topla_k2`, `pack`) | 2 cycles (`E → W`) | `MADDF32`, `MSUBF32` (including `#16FHi`, parallel `\|\| MMOV32`, `\|\| MMPYF32`, and `MMACF32`) |
| `fpu_carpma.sv` (`carp_k1`, `carp_k2`, `pack`) | 2 cycles (`E → W`) | `MMPYF32` (including `#16FHi`, parallel `\|\| MMOV32`, `\|\| MADDF32/MSUBF32`, and `MMACF32`) |
| `tamsayi_islem.sv` | 1 cycle (`E`) | `MADD32`, `MSUB32`, `MAND32`, `MOR32`, `MXOR32`, `MLSL32`, `MLSR32`, `MASR32`, `MCMP32` |
| `fpu_kestirme.sv` (`clasify`, `kestirme`) | 1 cycle (`E`) | `MEINVF32` ($1/x$), `MEISQRTF32` ($1/\sqrt{x}$) via `1024 × 8-bit` ROM (`estimate_lut.hex`) |
| `fpu_karsilastirma.sv` (`clasify`, `karsilastirma`) | 1 cycle (`E`) | `MCMPF32`, `MMAXF32`, `MMINF32`, `MABSF32`, conditional `MNEGF32` |
| `fpu_donusum.sv` (`clasify`, `donusum`) | 1 cycle (`E`) | `MF32TOI16`, `MF32TOI16R`, `MF32TOI32`, `MF32TOUI16`, `MF32TOUI16R`, `MF32TOUI32`, `MI16TOF32`, `MI32TOF32`, `MUI16TOF32`, `MUI32TOF32`, `MFRACF32` |

## Simulation & Hardware-in-the-Loop Verification

### 1. Generating and Assembling the Flight Controller (`drone.casm`)

`gui/drone_uret.py` generates the symbolic CLA assembly source `drone.casm`, and `gui/derle.py` runs the static pipeline hazard linter (`core.denetle`), assembles the 431 instructions into `drone_l3.hex`, and writes the task vectors and CRC32 signature into `sw/drone_cla.h`:

```bash
cd gui
python3 drone_uret.py
python3 derle.py
```

Expected output:

```text
drone_l3.hex: 431 komut (862 / 4096 word) , crc32 0x276C7CCB
MVECT: 1=0x000 2=0x0CE 3=0x118 4=0x24E 8=0x318
```

### 2. Closed-Loop Golden Model vs. C Reference Simulation (Boardless)

`gui/cla_dongu.py` runs the 6-DOF quadrotor physics engine in closed loop with the cycle-accurate Python Golden Model (`GoldenCla`) and optionally cross-checks every single step bit-for-bit against the C reference implementation (`--c-ref`) across a 10-second disturbance scenario:

```bash
cd gui
python3 cla_dongu.py 10000 --c-ref
```

**Disturbance Scenario Timeline (`OLAYLAR` in `cla_dongu.py`):**

| Step ($1\text{ ms/step}$) | Event Injected | Physical Effect |
| :--- | :--- | :--- |
| `0` | `SK_HEDEF (0, 0, 2)` | Takeoff from ground $(0,0,0)$ to hover at $z = 2.0\text{ m}$ |
| `1500` ($1.5\text{ s}$) | `SK_HEDEF (2, 1, 2)` | Step waypoint command to $(x=2\text{ m},\ y=1\text{ m},\ z=2\text{ m})$ |
| `3000` ($3.0\text{ s}$) | `SK_RUZGAR (6, 0, 0)` | $6\text{ m/s}$ sustained lateral wind gust along $+x$ |
| `4500` ($4.5\text{ s}$) | `SK_DARBE (0, 8, 0), 0.3s` | $8\text{ N}$ external lateral force impulse along $+y$ for $0.3\text{ s}$ |
| `6000` ($6.0\text{ s}$) | `SK_MOTOR (1, 0.7)` | Motor 2 loses $30\%$ thrust efficiency ($\eta_2 = 0.70$) |
| `7000` ($7.0\text{ s}$) | `SK_YUK (+0.3 kg)` | Sudden $+0.3\text{ kg}$ payload mass addition in flight |
| `8000 – 9500` | `SK_GOZLEMCI` off $\to$ on | Disturbance observer disabled under $-6\text{ m/s}$ wind, then re-enabled |

### 3. Real-Time Browser Telemetry & Control GUI (`cla_gui.py`)

Launch the interactive web interface at `http://localhost:8081` either in standalone PC simulation mode (`--model`) or connected live to the Kria KV260 board (`--board`):

```bash
cd pc
# Standalone PC simulation mode (6-DOF physics + reference model):
python3 cla_gui.py --model

# Live Kria KV260 hardware mode (connects to radar_server on port 5001):
python3 cla_gui.py --board 192.168.137.92:5001
```

While flying in `--board` mode, a background thread continuously pulls input/output state records (`M2C`, `C2M_before`, `C2M_after`) from the KV260, replays the exact same step on `core.py` on the PC, and verifies live in the browser that the FPGA hardware and Golden Model agree to the last bit.

### 4. End-to-End Kria KV260 Hardware Verification (`kart_test.py`)

With the bitstream loaded on the Kria KV260 and `radar_server` running, execute the 4-stage hardware verification suite (or run `sistem_test.bat` on Windows):

```bash
cd pc
python3 kart_test.py --kart 192.168.137.92
```

1. **Connectivity & Hardware ID (`0x434C4101`):** Pings `radar_server` and reads AXI offset `0x04C` (`KIMLIK`) to confirm the CLA bitstream is active.
2. **Program CRC Verification (`0x276C7CCB`):** Ensures the `drone_cla.h` compiled into `radar_server` matches the local `drone.casm` instruction image.
3. **Step-by-Step Hardware-in-the-Loop vs. Golden Model:** Runs 6-DOF physics on the PC while dispatching every control step over TCP/AXI to the physical KV260 CLA core, asserting zero bit discrepancies across all 33 `C2M` state words as the drone climbs to $2\text{ m}$.
4. **On-Board 1 kHz Real-Time Flight Simulation:** Runs a 12-second flight scenario (takeoff, waypoint step, wind gust, impulse) at 1 kHz directly on the KV260 PS+PL and replays captured hardware traces against the Golden Model.

## Real-World Applications

| Industry | Application | What the CLA Accelerates |
| :--- | :--- | :--- |
| **UAVs & Aerospace** | Multi-rate autopilot & attitude control | Cascaded PID loops, quaternion/Euler rotations, and disturbance observers (`drone.casm`) |
| **Electric Drives (PMSM / BLDC)** | Field-Oriented Control (FOC) & predictive current control | Clarke/Park transforms, $1/\sqrt{x}$ vector normalization, and 20–100 kHz PI current regulators |
| **Digital Power Electronics** | Switched-mode power supplies & solar inverters | High-bandwidth 2p2z / 3p3z compensation filters and phase-locked loops (PLL) |
| **Robotics & Actuators** | Multi-axis joint torque and impedance control | Parallel low-latency feedback loops isolated from high-level motion planning |
| **Automotive EV Systems** | Traction inverter & active suspension control | Deterministic microsecond-level control laws with zero OS interrupt jitter |

## What's Next

- **Direct ADC & PWM Hardware Triggers:** Expose `hw_task_trig[7:0]` in `cla_wrapper.v` directly to PL ADC-done and PWM-sync pulses so the 1 kHz–100 kHz control loop runs without even a single AXI `MIFRC` write from the Zynq PS.
- **True Dual-Port Data BRAMs (`L1` / `L2`):** Upgrade `cla_data_ram.sv` to use both ports of the FPGA block RAM primitive (Port A for `R1` reads, Port B for `W` writes), completely eliminating the 1-cycle `dur_r1` bank conflict stall.
- **CLA Type-1 / Type-2 Background Task Support:** Add hardware context switching for a continuous background task that yields single-cycle priority to foreground control interrupts.
- **AXI-Stream Telemetry DMA:** Stream `C2M` state snapshots directly to DDR via AXI-DMA for high-rate flight blackbox logging.

## References

- Texas Instruments, *TMS320F2803x Piccolo Technical Reference Manual (SPRUI10A)*, Chapter 10: Control Law Accelerator (CLA), pp. 565–720.
- IEEE Std 754-2008, *IEEE Standard for Floating-Point Arithmetic*.
- AMD/Xilinx, *Zynq UltraScale+ Device Technical Reference Manual (UG1085)* & *Kria KV260 Vision AI Starter Kit*.

## License

This project was developed by the **İTÜ YONGA** team (**Mustafa Taha Aydemir**, **Safa Oğuzhan Dişbudak**, **Arda Yalçınöz**, **Ahmet Kargı**).

*İTÜ YONGA*

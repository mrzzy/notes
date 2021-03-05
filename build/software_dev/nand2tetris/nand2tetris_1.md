# From Nand to Tetris Part I
Part 1 of Build a Modern Computer from First Principles: From Nand to Tetris.
Rights and Credits belong to Noam &amp; Shimon, Course Creators

> `Reading:` sections refer to chapters of the Course's textbook:
> [The Elements of Computing Systems](https://mitpress.mit.edu/books/elements-computing-systems-second-edition)

## Week 1

### Introduction
![Nand2Tetris Overview](./assets/nand2tetris_overview.png)

Nand2Tetris Overview: Build complete general purpose computer from the ground up:
- Nand2Tetris Part 1 focuses on **hardware platform** of the computer: Nand gate -> HACK computer.
- Nand2Tetris Part 2 focuses on **software hierarchy** that runs on the hardware platform: HACK computer -> Tetris.

### Abstraction
```
class Main {
    function void main() {
        do Output.printString("Hello World");
        do Output.println(); // New line.
        return;
    }
}
```

Motivating Example: Hello World program taught in introductory programming courses.
- Typically discuss what each line of the code is supposed to do but does not go further.
- To the computer code looks like individual characters that by itself does not mean anything.
- How does the computer figure which pixels to set on display based on characters?
    - Told about compiler, standard library, operating systems (OS) but there
      is no need to understand how they work

Abstraction: Don't worry about the "how", only about the "what":
- what: what is piece of code supposed to do?
- how: how a piece of code is implemented. Could be implemented by someone else or by us earlier/later.
- ie using OS like Windows does not require the user to understand how it works.
- reduces mental load: saves us from having to worrying about everything all at once.

> The Nand2Tetris course applys abstraction:
> - every week targets only a single level of abstraction.
> - take the lower level as given &amp; implement the target level.
> - test that the target level works, we can forget about the target level once it work.
> - rinse repeat until highest level.

### From Nand to HACK
Building the HACK hardware platform:
- Start from Nand Logical Gate
- Use combinational logic to build basic gates from elementary logic gates
- Use combinational/sequential logic to build CPU/RAM/Chipset.
- Combine chips to from HACK computer architecture.
- Write assembler to compile assembly into machine code that runs on the HACK platform.

### Building Hardware
Building a Hardware Platform without physical electronics:
- hardware engineers design chips with hardware simulator programs
- hardware simulator programs allows users to build/test chips virtually.

Building hardware process:
1. Start from chip abstraction/interface defining what the chip has to do.
![XOR Chip Interface](./assets/xor_interface.png)

2. Design Chip using Chip diagram using lower level logic gates already built.
![XOR Chip Diagram](./assets/xor_chip_diagram.png)

3. Code Chip using Hardware Description Language (HDL) based on design in diagram
    to produce HDL program virtualizing the hardware chip.

```
chip Xor {
    IN a, b;
    OUT out;
    PARTS:
        Not(in=a, out=nota);
        Not(in=b, out=notb);
        And(a=a, b=notb, out=w1);
        And(a=nota, b=b, out=w2);
        Or(a=w1, b=w2, out=out);
}
```

4. Use hardware simulator and test scripts to test that chip works as expected.

### From HACK to Tetris
Building Software Hierarchy that runs on the HACK platform:
- Start from HACK hardware platform and its assembler
- Build Higher Level Programming language that compiles into assembly.
- Build OS and standard library.
- Write Tetris using OS/Standard Library/High Level programming language.

### Boolean Logic
Boolean Values:
- only 2 values - 1/0. Simplest possible to maintain.

#### Basic Operations: AND/OR/NOT
AND operation:
| x | y | AND |
| --- | --- | --- |
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

OR operation:
| x | y | OR |
| --- | --- | --- |
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 1 |

NOT operation:
| x | NOT |
| --- | --- |
| 0 | 1 |
| 1 | 0 |


#### Evaluting Boolean Expressions
Evalutate <img src="./assets/42951b31caffadee8db01cc0a0f7d7d7.svg?sanitize=true&invert_in_darkmode" align=middle width=171.233205pt height=24.65759999999998pt/>:

<p align="center"><img src="./assets/82f3662dbcf43ea4e2449e1e5ab6db4b.svg?sanitize=true&invert_in_darkmode" align=middle width=403.42499999999995pt height=16.438356pt/></p>

#### Boolean Functions
Boolean functions encapsulate boolean expression **formulas**:
<p align="center"><img src="./assets/71c33574625bb4c325fffbf9702a48c1.svg?sanitize=true&invert_in_darkmode" align=middle width=331.27875pt height=16.438356pt/></p>

Boolean functions like <img src="./assets/190083ef7a1625fbc75f243cffb9c96d.svg?sanitize=true&invert_in_darkmode" align=middle width=9.817500000000004pt height=22.831379999999992pt/> can be represented as **truth table**:

![Boolean Function f Truth Table](./assets/boolean_function_truth_table.png)

> Both formulas and truth tables are equavilent ways to specify boolean functions

#### Boolean Identities
Boolean Identities:
- Communicative Law:
<p align="center"><img src="./assets/ddb13e924f7976702ca18a7fac7439b7.svg?sanitize=true&invert_in_darkmode" align=middle width=336.07365pt height=16.438356pt/></p>

- Associative Law: Ordering does not matter
<p align="center"><img src="./assets/3a400516a8588e666ab36e573d8d7190.svg?sanitize=true&invert_in_darkmode" align=middle width=584.4762pt height=16.438356pt/></p>

- Distributive Law: Unpack expressions
<p align="center"><img src="./assets/8e6b9ec97701c41cf959c93bd54a16e9.svg?sanitize=true&invert_in_darkmode" align=middle width=692.23935pt height=16.438356pt/></p>

- De Morgan Law:
<p align="center"><img src="./assets/a381ca89575304c704264db3bbba129e.svg?sanitize=true&invert_in_darkmode" align=middle width=605.4807pt height=16.438356pt/></p>

### Boolean Function Synthesis
Boolean Function Synthesis: Given a truth table, derive the equavilent boolean expression:

![Truth Table](./assets/boolean_function_truth_table.png)

1. For each row of the truth table where the boolean function evaluates to 1:
    - make a boolean expression that evaluates 1 **only** on that row, but 0 in all other rows.

![Boolean Expressions synthesised from Truth Table rows](./assets/truth_table_bool_expr_row.png)

2. <img src="./assets/296cd8148089ff59db6a0cd58be6a341.svg?sanitize=true&invert_in_darkmode" align=middle width=24.885960000000004pt height=22.46574pt/> the boolean expressions together to form the equavilent boolean expression.

<p align="center"><img src="./assets/ba23665c03db7d55a6a9d54d59710784.svg?sanitize=true&invert_in_darkmode" align=middle width=848.86065pt height=16.438356pt/></p>

3. Use boolean identities to simplify boolean expression.


### NAND
Therom: Any boolean function can be represented using an expression containing AND/OR/NOT:
- OR can be represented with AND/OR via De Morgan Law:
<p align="center"><img src="./assets/e05e06a3bde5a956b1e8702d62744b37.svg?sanitize=true&invert_in_darkmode" align=middle width=302.74035pt height=16.438356pt/></p>
- Updated Therom: Any boolean function can be represented using an expression containing AND/NOT:
<p align="center"><img src="./assets/438154b78e3518a509e1d3993f5c249c.svg?sanitize=true&invert_in_darkmode" align=middle width=216.89579999999998pt height=16.438356pt/></p>
- Updated Therom: Any boolean function can be represented using an expression containing NAND.
- Proof:
<p align="center"><img src="./assets/3fcd6da509eeb7c5b09a6b1b3e736941.svg?sanitize=true&invert_in_darkmode" align=middle width=407.99219999999997pt height=16.438356pt/></p>

### Logic Gates
Gate Logic: technique for implementing boolean function using logic gates

![Elementary Logic Gate Diagrams](./assets/elementary_logic_gate_diagrams.png)

**<p align="center">Logic Gate Diagrams</p>**
- Logic Gates: standalone chip that delivers a well defined functionality.
    - Elementary: NAND, AND, OR, NOT, ...
    - Composite: MUX, ADDR, ...

#### Elementary Logic Gates

| Logic Gate | Logic Gate Diagram | Functional Specification | Truth Table |
| --- | --- | --- | --- |
| NAND | ![NAND Gate](./assets/nand_gate_diagram.png) | `if (a == 1 and b == 1) then out=0 else out=1` | ![NAND Truth Table](./assets/nand_truth_table.png) |
| AND | ![AND Gate](./assets/and_gate_diagram.png) | `if (a == 1 and b == 1) then out=1 else out=0` | ![AND Truth Table](./assets/and_truth_table.png) |
| OR | ![OR Gate](./assets/or_gate_diagram.png) | `if (a == 1 or b == 1) then out=1 else out=0` | ![OR Truth Table](./assets/or_truth_table.png) |
| NOT | ![NOT Gate](./assets/not_gate_diagram.png) | `if (a == 1) then out=1 else out=0` | ![NOT Truth Table](./assets/not_truth_table.png) |

#### Composite Logic Gates
Composite Logic Gates: Composed from elementary logic gates.
Example: The composite 3-input AND gate:

![3-Input AND](./assets/three_input_and_gate_diagram.png)

- can be composed of two elementary AND gates:

![Composite 3-Input AND from elementary AND gates](./assets/composite_three_input_and_as_elementary_ands.png)

### Interface vs Impelementation
Interface - defines what the logic gate/code/software system is supposed to do
Impelementation - how the logic/gate/code/software system is implemented
- There might be many possible implementations for a given interface.
- Impelementation vary in performance, speed, parts/time/space requirements.

### Hardware Description Language
From Abstraction to HDL/Hardware implementation of chips:
1. Obtain Abstractions/Interface specifying the requirements of chip: Truth Table/Gate Diagram.
![XOR Truth Table/Gate Diagram](./assets/xor_interface.png)


2. Define the interface of the Chip:
```
/** Xor gate: out = (a And (Not b)) OR ((Not A) And B) */

CHIP Xor {
    // Xor interface
    IN a, b;
    OUT out;
}
```

3. Synthesize the boolean function equavilent for the Chip using [Boolean Function Synthesis](#boolean-function-synthesis)
4. Write a Implementation Gate Diagram with the implementation of the Chip:
![XOR Implementation Gate Diagram](./assets/xor_implement_gate_diagram.png)
    - Fan out: signals can be distributed to unlimited no. of chips (ie input `a` to `And` &amp; input `a` to `And`)
    - Red connections: Named connections that connect component logic gates together.
5. Implement the Chip using HDL, referencing the Implementation Gate Diagram
```
/** Xor gate: out = (a And (Not b)) OR ((Not A) And B) */

CHIP Xor {
    // Xor interface
    IN a, b;
    OUT out;
    // Xor implementation
    PARTS:
    Not(in=a, out=nota);
    Not(in=a, out=notb);
    And(a=a, b=nota, out=aAndNotb);
    And(a=nota, b=b, out=notaAndb);
    Or(a=aAndNotb, b=notaAndb, out=out);
}
```
> HDL is code and thus maintainable development practices apply.
> Pay attention to indentation/comments/documentation/naming. 
> HDL conventions:
> - Describe the components of the Implementation Gate Implementation in
>   the `PARTS:` section from left to right
> - Use `a, b, ...` as Chip input/argument names, and `out` as chip output name.

HDL in the real world: VHDL, Verilog.

### Hardware Simulation/Testing
Hardware Simulation: Run/Test HDL chips
- Interactive Simulation: Run HDL code on Hardware Simulator to simulate the Hardware Chip.
- Script Based Simulation: Write Test Scripts to unit test the simulated Hardware Chip from HDL.

#### Interactive Simulation/Testing
Interactive Simulation:
- Load the HDL file into the hardware simulator to construct Simulated Hardware Chip
- Set values on the Chip's input pins.
- Evalutate/Simulate the Simulate Hardware Chip.
- Inspect the output/internal pins for expected values to check if the Virtualized Chip is working

#### Script Based Simulation/Testing
Script Based Simulation:
- Automate/Replicate testing by scripting testing steps:
```
load Xor.hdl;

set a 0, set b 0, eval;
set a 0, set b 1, eval;
set a 1, set b 0, eval;
set a 1, set b 1, eval;
```

- Test script can be configured to dump output to file with `output-file`.
  - `output-list` specifies the pins/symbols that will be dumped into the output file.
  - `compare-to` automatically compares output dump to another expected output file, errors if lines do not match.
  - `output` instructs simulator to dump output as configured by `output-file`, `output-list`.
> Behaviour Simulation: Allows high level planning in terms of expected output files before any HDL is written

```
load Xor.hdl,
output-file Xor.out,
compare-to Xor.cmp,
output-list a b out;

set a 0, set b 0, eval, output;
set a 0, set b 1, eval, output;
set a 1, set b 0, eval, output,;
set a 1, set b 1, eval, output;
```

> Test Script Docs can be found in Appendix B of the Textbook (Test Scripting Language)

### Multibit Buses
Buses: Array of bits
- convienient to think of group of bits as single entity, 'bus'.
- HDLs typically provide a convienient notation for dealing with buses

Example: 16-bit buses in 16-bit integer adder:
![16-bit integer adder](./assets/16bit_adder_gate_diagram.png).

#### Buses Syntax
In Nand2Tetris HDL buses are represented using array syntax:
- In `IN` &amp; `OUT` sections, `a[16]`  defines a bus `a` of size 16-bits.
- In `PARTS:` section, `a[2]` 0-base indexes the 3rd bit of the `a` bus.
- Input Buses can be assigned to in seperate slices.
    - ie `a[0..7]=lsb` assigns lsb bus to the first 8-bits of the `a` 16-bit bus.
    - ie `a[8..15]=lsb` assigns msb bus to the last 8-bits of the `a` 16-bit bus.
- `false`, `true` are synonymous for buses of 0, 1 of any length.

> NOTE: Multi bit buses are indexed from right to left.

- 16-bit Adder
```
/* Adds two 16-bit values */
CHIP Add16 {
    IN a[16], b[16];
    OUT out[16];

    PARTS:
    // implementation excluded
}
```

- 3 way 16-bit Adder
```
/* Adds three 16-bit value */
CHIP Add3Way16 {
    IN a[16], b[16], c[16];
    OUT out[16];

    PARTS:
        Add16(a=a, b=b, out=aPlusb);
        Add16(a=aPlusb, b=c, out=out);
}
```

- 4 way 4-bit AND
```
/* Performs ANDs between the 4 bits of input */
CHIP Add4Way {
    IN a[4];
    OUT out;
    
    PARTS:
        AND(a=a[0], b=a[1], out=and01);
        AND(a=and01, b=a[2], out=and012);
        AND(a=and012, b=a[3], out=out);
}
```

- 4-bit Bitwise AND
```
/* Performs 4bit Bitwise AND between inputs */
CHIP And4 {
    IN a[4], b[4];
    OUT out[4];
    
    PARTS:
        AND(a=a[0], b=a[0], out=out[0]);
        AND(a=a[1], b=a[1], out=out[1]);
        AND(a=a[2], b=a[2], out=out[2]);
        AND(a=a[3], b=a[3], out=out[3]);
}
```

### Mux/Demux
![Multiplexor Gate Diagram](./assets/mux_gate_diagram.png)

Multiplexor(Mux): If statement in hardware form:
- `sel == 0` output `a`
- `sel == 1` output `b`
- used to make programmable gates like `AndMuxOr` which does `And` or `Or` on its inputs depending on `sel`:
  ![AndMuxOr Gate Diagram](./assets/andmuxor_gate_diagram.png)

---

![Demultiplexor Gate Diagram](./assets/demux_gate_diagram.png)

Demultiplexor(Demux): Inverse of Multiplexor, distributes input into multiple destinations.
- `sel == 0` output `in` on `a`output
- `sel == 1` output `in` on `b`output

Application Mux/Demux: Send multiple inputs over single communication line:
- `sel` is connected to an oscillator that alternates between 0/1
- weaves input lines Mux side into single line, unweaves into output line on Demux side.

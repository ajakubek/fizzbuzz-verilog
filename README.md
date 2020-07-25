# Fizz Buzz in Verilog

Hardware solver for Fizz Buzz.

Uses fast divisibility test described in
[D. Lemire, O. Kaser, and N. Kurz, Faster Remainder by Direct Computation,2018](https://arxiv.org/pdf/1902.01961.pdf).

## Ports
 ```verilog
 input  logic [7:0] number
 output logic       fizz
 output logic       buzz
 ```

## Requirements
 - [IceStorm](http://www.clifford.at/icestorm)
 - [nextpnr-ice40](https://github.com/YosysHQ/nextpnr)
 - [SymbiYosys](https://github.com/YosysHQ/SymbiYosys) (required for formal verification)
 - [Icarus Verilog](http://iverilog.icarus.com) (required for simulation)

## Build instructions
 Synthesize for IceBreaker board\
 ```$ make```

 Run formal verification (requires SymbiYosys)\
 ```$ make formal```

 Run simulation (requires Icarus Verilog)\
 ```$ make test```
 
 Generate parameters for fast divisibility test:\
 ```$ python scripts/generate_div_params.py```

## Supported hardware
 - [IceBreaker board](https://1bitsquared.com/products/icebreaker)

# Logic Design with Verilog

## Repository Structure


The repository has the following file structure:

```bash
| README.md (This File)
├── lab1
│   │   assignment.pdf # Details of Lab Assignment
│   │   README.md # Instructions for running the lab
│   ├── provided_modules
│   │   └── *.sv # pre-written SystemVerilog files
│   ├── part1
│   │   ├── <Module Name 1>
│   │   │   ├── <Module Name>.sv # SystemVerilog Skeleton File
│   │   │   ├── testbench.sv # Testbench for module
│   │   │   └── Makefile # Makefile for running tests
│   │   ├── <Module Name 2>
│   │   │   └── ... # Same files as above
│   │   ├── ...
│   │   └── <Module Name N>
│   ├── part2
│   │   └──  ... # Same structure as part 1
│   ├── ...
│   └── part<X>
├── lab2
│   │   assignment.pdf # Details of Lab Assignment
│   │   README.md # Instructions for running the lab
│   ├── part1
│   ├──...
│   └── part<Y>
├── ...
└── lab<Z>
```


## Tooling
- *Icarus Verilog*: https://bleyer.org/icarus/ (v10.0)
- *Verilator*: https://verilator.org/guide/latest/index.html (v5.0)
- *GTKWave*: https://gtkwave.sourceforge.net/ (v3.0)

If you use the provided VirtualBox image, these tools will already be
installed. You can install VirtualBox using the instructions here:
https://www.virtualbox.org/wiki/Downloads

You will also need the Oracle VM VirtualBox Extension Pack:
https://www.oracle.com/virtualization/technologies/vm/downloads/virtualbox-downloads.html#extpack

Otherwise you can install these tools using the instructions below.


### Typical Installation - All Operating Systems

Follow these instructions to install the OSS-CAD-Suite, which contains
all the tools: https://github.com/YosysHQ/oss-cad-suite-build#installation

If you are running on Ubuntu, create `/etc/udev/rules.d/50-lattice-ftdi.rules` (you will need to use sudo), and paste the contents: 

    `ACTION=="add", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010", MODE:="666"`
    
Otherwise you will get the eqivalent of a 'device not found' error when running `iceprog`.


### Advanced Installation - Linux
	
If you like doing things the hard way, you can use these
instructions. Please ensure that you have the correct versions (listed
above).

- On Ubuntu/Debian-like distributions, run: `sudo apt install iverilog verilator gtkwave yosys nextpnr-ice40 fpga-icestorm`

- Then, create `/etc/udev/rules.d/50-lattice-ftdi.rules` (you will need to use sudo), and paste the contents: 

    `ACTION=="add", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010", MODE:="666"`
    
- Double check your installed tool versions against the ones above.


### Advanced Installation - MacOS

(NB: I use my M2 to write and test the lab assignments. I recommend
the oss-cad-suite above, but this setup works too.)

- Install Homebrew: https://brew.sh/
- Run: `brew install icarus-verilog verilator gtkwave`
- Run: `brew tap ktemkin/oss-fpga`
- Run: `brew install --HEAD icestorm yosys nextpnr-ice40`


### Advanced Installation - Windows

If you are running windows we HIGHLY recommend using the provided
VirtualBox image. 

We will update with WSL instructions when they are available.


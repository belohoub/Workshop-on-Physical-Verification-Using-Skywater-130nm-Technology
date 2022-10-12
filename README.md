# Workshop on Physical Verification Using Skywater 130nm Technology

## Day 1

```tcl
% magic -d XR
% netlist_to_layout inverter.spice sky130A

% extract do local
% extract all
Extracting sky130_fd_pr__nfet_01v8_385SSZ into sky130_fd_pr__nfet_01v8_385SSZ.ext:
Extracting sky130_fd_pr__pfet_01v8_72SH2U into sky130_fd_pr__pfet_01v8_72SH2U.ext:
Extracting inverter into inverter.ext:
% ext2spice lvs
% ext2spice hierarchy off
% ext2spice
```

```bash
$ cd netgen
$ netgen -batch lvs "../magic/inverter.spice inverter" "../xschem/simulations/inverter.spice inverter"
```

## Day 2

### Extraction

```tcl
% extraction do local
% extract all
% ext2spice lvs % set sane options
% ext2spice
% 
% 
% extract style ngspice()
% extract style ngspice(si) % use SI units
%
% ext2spice cthresh value % 0/infinite ...
% ext2spice rthresh value % 0/infinite ...
% ext2spice scale off % ngspice scale
% ext2spice merge on|off % merge parallel devices
%
% extresists tolerance value
% extresist all % annotation sto the orig. netlist -> speedup
% ext2spice extresist on
%
% ext2spice -d % distribute areas equally among all devices
%
```


### GDS read

```tcl
% gds read file
% gds readonly true|false % do not modify cells while reading
%
% gds flatglob cellname % content of the child cell flatten into parent cell cellname
%
% gds flatten true % make magic files smaller -> flatten subcells to represent them in the magic way (planes)
%
% gds noduplicates true % ignore cell defiitions in gds what is already inthe memory
```

  * Hands on:
```tcl
% gds read /usr/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds % read cells
% lef read /usr/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef % read metzadata for gds data, do not owewrite existing cellsm by abstract views
% readspice /usr/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice % anotate cells by spice netlists (reorder pins)
```
    
#### CIF input style (CIF/GDS)

```tcl
% cif istyle sky130() % for reading gds written by magic
% cif istyle sky130(vendor) % for reading gds provided by skywater PDK
%
% cif style rdlimport % read redistribution layer metal defined by vendor
```

### GDS write

```tcl
% gds library true % ignore cell layout hierarchy
% gds addendum true % ignore readonly cells
% gds merge true % smaller output, rectangles merged
%
%
```


#### CIF output style (CIF/GDS)

```tcl
% cif style gdsii
% cif style drc  % for drc checks only
% cif style density  % for scripts: sky130/custom/scripts/check_density.py
% cif style wafflefill  % include fill patterns: sky130/custom/scripts/generate_fill.py
```

### DRC

```tcl
% drc on
%
% drc style full % full check
% drc style fast % typical
% drc style routing % metals only
% 
% drc check
% 
```
  
  * abstract views - by using abstract views, checks of internals are mostly disabled (faster ...)
  * hierarchy - inside (might be violation), will disappear when connection to top-level layers

  
### Layout Versus Schematic
  * permuitable inputs
  * parallel and serial connection of devices
  * setup commands fore netgen (/usr/share/pdks/sky130A/libs.tech)/netgen/sky130A_setup.tcl):
    * property
    * ignore
    * permute 
    * equate
  * schematic and layout hierarchy should be "close" - flattening
  * Layout Versus Verilog
  * Black-Boxing -> logic gates are black-boxed
  * XOR verification - checks of small layout changes or mask revisions (in the magic lyaout tool):
  
```tcl
% load and2_2
% flatten xor_test
% load and2_2_alt
% xor xor_test
```

### Hands on

#### Challenge: create cell locally and compare it with theat one provided by vendor

```tcl
% cif istyle sky130(vendor)
% gds read /usr/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds
% lef read /usr/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef 
% readspice /usr/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
% load sky130_fd_sc_hd__and2_1
% property
{LEFsite unithd} {LEFclass CORE} {FIXED_BBOX 0 0 460 544} {LEFsymmetry X Y R90} {path 0.000 13.600 11.500 13.600 }
% writeall
%
% port first
1
% port 1 name
A
% port 2 name
B
% port 3 name
VGND
% port 4 name
VNB
% port 5 name
VPB
% port 6 name
VPWR
% port 7 name
X
% port 1 use
signal
% port 1 class
input
% 
% extract do local
% extract all
% ext2spice lvs
% ext2spice
exttospice finished.
% gds write sky130_fd_sc_hd__and2_1
   Generating output for cell sky130_fd_sc_hd__and2_1
% quit
```

```bash
$ ls
sky130_fd_sc_hd__and2_1.ext  sky130_fd_sc_hd__and2_1.gds  sky130_fd_sc_hd__and2_1.spice  test.gds  test.mag
$ less sky130_fd_sc_hd__and2_1.spice 
$ mkdir ../netgen
$ cd ../netgen/
$ netgen -batch lvs "../magic/sky130_fd_sc_hd__and2_1.spice sky130_fd_sc_hd__and2_1" "/usr/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice sky130_fd_sc_hd__and2_1"
...
Final result: 
Top level cell failed pin matching.

Logging to file "comp.out" disabled
LVS Done.
$ less comp.out 

...

Subcircuit pins:
Circuit 1: sky130_fd_sc_hd__and2_1         |Circuit 2: sky130_fd_sc_hd__and2_1         
-------------------------------------------|-------------------------------------------
A                                          |B **Mismatch**                             
VGND                                       |A **Mismatch**                             
X                                          |X                                          
B                                          |VGND **Mismatch**                          
VNB                                        |VPB **Mismatch**                           
VPB                                        |VPWR **Mismatch**                          
VPWR                                       |VNB **Mismatch**                           
---------------------------------------------------------------------------------------
Cell pin lists for sky130_fd_sc_hd__and2_1 and sky130_fd_sc_hd__and2_1 altered to match.
Device classes sky130_fd_sc_hd__and2_1 and sky130_fd_sc_hd__and2_1 are equivalent.

...

$ cat ../magic/sky130_fd_sc_hd__and2_1.spice | grep "^.subckt sky130_fd_sc_hd__and2_1"
.subckt sky130_fd_sc_hd__and2_1 A B VGND VPWR X VNB VPB
$ cat /usr/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice | grep "^.subckt sky130_fd_sc_hd__and2_1"
.subckt sky130_fd_sc_hd__and2_1 A B VGND VNB VPB VPWR X


```
  

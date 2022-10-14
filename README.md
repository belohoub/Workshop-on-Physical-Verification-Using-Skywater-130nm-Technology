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
% ext2spice lvs # set sane options
% ext2spice
% 
% 
% extract style ngspice()
% extract style ngspice(si) # use SI units
%
% ext2spice cthresh value # 0/infinite ...
% ext2spice rthresh value # 0/infinite ...
% ext2spice scale off # ngspice scale
% ext2spice merge on|off # merge parallel devices
%
% ext2sim labels on
% ext2sim # used to extract resistances ...
%
% extresists tolerance value
% extresist all # annotation to the orig. netlist -> speedup
% ext2spice extresist on
%
% ext2spice -d # distribute areas equally among all devices
%
```


### GDS read

```tcl
% gds read file
% gds readonly true|false # do not modify cells while reading
%
% gds flatglob cellname # content of the child cell flatten into parent cell cellname
%
% gds flatten true # make magic files smaller -> flatten subcells to represent them in the magic way (planes)
%
% gds noduplicates true # ignore cell defiitions in gds what is already inthe memory
```

  * Hands on:
```tcl
% gds read /usr/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds # read cells
% lef read /usr/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef # read metzadata for gds data, do not owewrite existing cellsm by abstract views
% readspice /usr/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice # anotate cells by spice netlists (reorder pins)
```
    
#### CIF input style (CIF/GDS)

```tcl
% cif istyle sky130() # for reading gds written by magic
% cif istyle sky130(vendor) # for reading gds provided by skywater PDK
%
% cif style rdlimport # read redistribution layer metal defined by vendor
```

### GDS write

```tcl
% gds library true # ignore cell layout hierarchy
% gds addendum true # ignore readonly cells
% gds merge true # smaller output, rectangles merged
%
%
```


#### CIF output style (CIF/GDS)

```tcl
% cif style gdsii
% cif style drc  # for drc checks only
% cif style density  # for scripts: sky130/custom/scripts/check_density.py
% cif style wafflefill  # include fill patterns: sky130/custom/scripts/generate_fill.py
```

### DRC

```tcl
% drc on
%
% drc style full # full check
% drc style fast # typical
% drc style routing # metals only
% 
% drc check
% 
```
  
  * abstract views - by using abstract views, checks of internals are mostly disabled (faster ...)
  * hierarchy - inside (might be violation), will disappear when connection to top-level layers

```bash
$ /usr/share/pdk/sky130A/libs.tech/magic/run_standard_drc.py /usr/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/mag/sky130_fd_sc_hd__and2_1.mag 
```
  
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

#### Hands on

```tcl
% load test3
% flatten -nolabels xor_test
% # Move one cell
% xor -nolabels xor_test
% load xor_test
% # see the result
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
$
$ # Missing netgen config ...
$ cp /usr/share/pdk/sky130A/libs.tech/netgen/sky130A_setup.tcl setup.tcl
$ netgen -batch lvs "../magic/sky130_fd_sc_hd__and2_1.spice sky130_fd_sc_hd__and2_1" "/usr/share/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice sky130_fd_sc_hd__and2_1"

...
Circuits match uniquely.
.
Logging to file "comp.out" disabled
LVS Done.
$ 

```

## Day 3

### Manipulations

```tcl
% # Copy cell to .
% cellname filepath sky130_fd_sc_hd__dfrtp_2 .
```

### Electrical check 

```tcl
% extract do local
% extract all
% antennacheck
Reading extract file.
Building flattened netlist.
Running antenna checks.
antennacheck finished.
% feedback why
Antenna error at plane metal2
% antennacheck debug
% antennacheck
Reading extract file.
Building flattened netlist.
Running antenna checks.
Cell: sky130_fd_sc_hd__inv_1_0
Antenna violation detected at plane metal2
Effective antenna ratio 888.825 > limit 400
Gate rect (-14 -842) to (16 -712)
Antenna rect (238 -8119) to (361 -8072)
antennacheck finished.
%
```

### Checking Density

```tcl
% cif cover MET1
% cif cover MET2
```

```bash
$ /usr/share/pdk/sky130A/libs.tech/magic/check_density.py exercise_11.gds
$ # Insert fillers
$ /usr/share/pdk/sky130A/libs.tech/magic/generate_fill.py exercise_11.mag
```

```tcl
% cif cover MET1
Cell Area = 490000000000 CIF units^2
Layer Bounding Area = 490000000000 CIF units^2
Layer Total Area = 27599406000 CIF units^2
Coverage in cell = 5.6%
% 
% cif ostyle density
CIF output style is now "density"
% cif cover MET1
CIF name "MET1" doesn't exist in style "density".
The valid CIF layer names are: fom_all, poly_all, li_all, m1_all, m2_all, m3_all, m4_all, m5_all.
% cif cover m1_all
Cell Area = 19600000000 CIF units^2
Layer Bounding Area = 19600000000 CIF units^2
Layer Total Area = 11388231920 CIF units^2
Coverage in cell = 58.1%
% cif cover m2_all
Cell Area = 19600000000 CIF units^2
Layer Bounding Area = 19327817400 CIF units^2
Layer Total Area = 18069907840 CIF units^2
Coverage in cell = 92.2%
% 
```

## Day 4

  * OpenLane is mostly covered by [Advanced-Physical-Design-using-OpenLANE](https://github.com/belohoub/Advanced-Physical-Design-using-OpenLANE) workshop, additional notes below
  
```bash
OpenLANE$ write_powered_verilog # to write netlist of routed design
OpenLANE$ set_netlist $::env(lvs_result_file_tag).powered.v # set variable pointing to extracted netlist for LVS
OpenLANE$ # gen GDSses
OpenLANE$ run_magic
OpenLANE$ run_klayout
OpenLANE$ run_klayout_gds_xor # XOR GDSes by klayout and magic
OpenLANE$ run_magic_spice_export # SPICE netlist extraction
OpenLANE$ run_lvs
OpenLANE$ run_magic_drc
OpenLANE$ run_antenna_check
OpenLANE$ run_lef_cvdc # circuit validity check
OpenLANE$ generate_final_summary_report
OpenLANE$ 
OpenLANE$ 
```

  * exclude cells - known problematic cells in OpenLane:
  
```bash
$ find /usr/share/pdk/sky130A/libs.tech/openlane/ | grep exclude
/usr/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_ls/drc_exclude.cells
/usr/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hd/drc_exclude.cells
/usr/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hdll/drc_exclude.cells
/usr/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_hs/drc_exclude.cells
/usr/share/pdk/sky130A/libs.tech/openlane/sky130_fd_sc_ms/drc_exclude.cells

  * change config.tcl parameters to help the automated flow to complete without errors
  * CTRL+Z -> zoom to bounding box
```

## Day 5

  * only presentations completed up to now, labs are TBD.

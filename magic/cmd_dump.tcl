loading history file ... 48 events added
Use openwrapper to create a new GUI-based layout window
Use closewrapper to remove a new GUI-based layout window

Magic 8.3 revision 329 - Compiled on Po 10. října 2022, 19:17:03 CEST.
Starting magic under Tcl interpreter
Using Tk console window
Processing system .magicrc file
Sourcing design .magicrc for technology sky130A ...
2 Magic internal units = 1 Lambda
Input style sky130(): scaleFactor=2, multiplier=2
The following types are not handled by extraction and will be treated as non-electrical types:
    nnmos obsactive mvobsactive obsli1 obsm1 obsm2 obsm3 obsm4 obsm5 obsmrdl ubm fillblock comment obscomment res0p35 res0p69 res1p41 res2p85 res5p73 
Scaled tech values by 2 / 1 to match internal grid scaling
Loading sky130A Device Generator Menu ...
New windows will not have a title caption.
New windows will not have scroll bars.
New windows will not have a border.
handling file entry inverter.mag extension .mag
Using technology "sky130A", version 1.0.121-9-g12f58a2
Root cell box:
           width x height  (   llx,  lly  ), (   urx,  ury  )  area (units^2)

microns:   0.010 x 0.010   ( 0.000,  0.000), ( 0.010,  0.010)  0.000     
lambda:     1.00 x 1.00    (  0.00,  0.00 ), (  1.00,  1.00 )  1.00      
internal:      2 x 2       (     0,  0    ), (     2,  2    )  4         
Main console display active (Tcl8.6.11 / Tk8.6.11)
% extract do lvs
Usage: extract do option
   or  extract no option
where option is one of:
  adjust			compensate R and C hierarchically
  all			all options
  capacitance		extract substrate capacitance
  coupling		extract coupling capacitance
  length			compute driver-receiver pathlengths
  local			put all generated files in the current directory
  resistance		estimate resistance
  labelcheck		check for connections through sticky labels
  aliases		output all net name aliases
%
% netlist_to_layout inverter.spice sky130
% 
% extract do local
% extract all
Extracting sky130_fd_pr__nfet_01v8_385SSZ into sky130_fd_pr__nfet_01v8_385SSZ.ext:
Extracting sky130_fd_pr__pfet_01v8_72SH2U into sky130_fd_pr__pfet_01v8_72SH2U.ext:
Extracting inverter into inverter.ext:
% ext2spice lvs
% ext2spice
exttospice finished.
% 
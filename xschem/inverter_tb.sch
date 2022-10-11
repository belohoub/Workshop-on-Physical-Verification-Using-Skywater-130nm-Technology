v {xschem version=3.1.0 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -170 -80 -170 -30 {
lab=#net1}
N -170 -80 230 -80 {
lab=#net1}
N 230 -80 230 -30 {
lab=#net1}
N 220 -30 230 -30 {
lab=#net1}
N -120 -30 -80 -30 {
lab=in}
N -170 30 230 30 {
lab=GND}
N 230 10 230 30 {
lab=GND}
N 220 10 230 10 {
lab=GND}
N -120 -120 -120 -30 {
lab=in}
N 220 -10 260 -10 {
lab=out}
C {inverter.sym} 70 -10 0 0 {name=x1}
C {devices/vsource.sym} -120 0 0 0 {name=V1 value="PWL(0ns 0v 20n 0 500ns 1.8v)"}
C {devices/vsource.sym} -170 0 0 0 {name=V2 value=1.8}
C {devices/gnd.sym} 10 30 0 0 {name=l1 lab=GND}
C {devices/opin.sym} 260 -10 0 0 {name=p1 lab=out}
C {devices/opin.sym} -120 -120 0 0 {name=p1 lab=in}
C {devices/code_shown.sym} -20 -150 0 0 {name=s1 only_toplevel=false value=".lib /usr/share/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt"}
C {devices/code_shown.sym} 70 140 0 0 {name=s2 only_toplevel=false value=".save v(in) v(out)
.control 
tran 1n 1u
run
plot V(in) V(out)
.endc"}

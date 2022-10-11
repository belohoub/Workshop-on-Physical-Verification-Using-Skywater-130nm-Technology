v {xschem version=3.1.0 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 0 -120 0 -80 {
lab=vdd}
N 0 -120 20 -120 {
lab=vdd}
N 0 -20 0 10 {
lab=out}
N 0 80 0 120 {
lab=vss}
N -60 0 -60 40 {
lab=in}
N -60 -50 -40 -50 {
lab=in}
N -60 -50 -60 0 {
lab=in}
N -0 -0 130 0 {
lab=out}
N 0 50 20 50 {
lab=vss}
N 20 50 20 120 {
lab=vss}
N 20 120 30 120 {
lab=vss}
N 0 120 20 120 {
lab=vss}
N 20 -120 30 -120 {
lab=vdd}
N -0 -50 10 -50 {
lab=vdd}
N 10 -120 10 -50 {
lab=vdd}
N -60 50 -40 50 {
lab=in}
N -60 40 -60 50 {
lab=in}
N -0 10 0 20 {
lab=out}
N -120 0 -60 0 {
lab=in}
C {devices/iopin.sym} 30 -120 0 0 {name=p1 lab=vdd}
C {devices/iopin.sym} 30 120 0 0 {name=p1 lab=vss}
C {/usr/share/pdks/sky130A/libs.tech/xschem/sky130_fd_pr/nfet_01v8_lvt.sym} -20 50 0 0 {name=M1
L=0.18
W=3
nf=3 
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {/usr/share/pdks/sky130A/libs.tech/xschem/sky130_fd_pr/pfet_01v8_lvt.sym} -20 -50 0 0 {name=M2
L=0.18
W=3
body=VDD
nf=3
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {devices/ipin.sym} -120 0 0 0 {name=p1 lab=in}
C {devices/opin.sym} 130 0 0 0 {name=p1 lab=out}

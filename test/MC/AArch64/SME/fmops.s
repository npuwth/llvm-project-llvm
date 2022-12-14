// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sme < %s \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
// RUN: not llvm-mc -triple=aarch64 -show-encoding < %s 2>&1 \
// RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sme < %s \
// RUN:        | llvm-objdump -d --mattr=+sme - | FileCheck %s --check-prefix=CHECK-INST
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+sme < %s \
// RUN:   | llvm-objdump -d --mattr=-sme - | FileCheck %s --check-prefix=CHECK-UNKNOWN
// Disassemble encoding and check the re-encoding (-show-encoding) matches.
// RUN: llvm-mc -triple=aarch64 -show-encoding -mattr=+sme < %s \
// RUN:        | sed '/.text/d' | sed 's/.*encoding: //g' \
// RUN:        | llvm-mc -triple=aarch64 -mattr=+sme -disassemble -show-encoding \
// RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST

// --------------------------------------------------------------------------//
// Widening

fmops   za0.s, p0/m, p0/m, z0.h, z0.h
// CHECK-INST: fmops   za0.s, p0/m, p0/m, z0.h, z0.h
// CHECK-ENCODING: [0x10,0x00,0xa0,0x81]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 81a00010 <unknown>

fmops   za1.s, p5/m, p2/m, z10.h, z21.h
// CHECK-INST: fmops   za1.s, p5/m, p2/m, z10.h, z21.h
// CHECK-ENCODING: [0x51,0x55,0xb5,0x81]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 81b55551 <unknown>

fmops   za3.s, p3/m, p7/m, z13.h, z8.h
// CHECK-INST: fmops   za3.s, p3/m, p7/m, z13.h, z8.h
// CHECK-ENCODING: [0xb3,0xed,0xa8,0x81]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 81a8edb3 <unknown>

fmops   za3.s, p7/m, p7/m, z31.h, z31.h
// CHECK-INST: fmops   za3.s, p7/m, p7/m, z31.h, z31.h
// CHECK-ENCODING: [0xf3,0xff,0xbf,0x81]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 81bffff3 <unknown>

fmops   za1.s, p3/m, p0/m, z17.h, z16.h
// CHECK-INST: fmops   za1.s, p3/m, p0/m, z17.h, z16.h
// CHECK-ENCODING: [0x31,0x0e,0xb0,0x81]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 81b00e31 <unknown>

fmops   za1.s, p1/m, p4/m, z1.h, z30.h
// CHECK-INST: fmops   za1.s, p1/m, p4/m, z1.h, z30.h
// CHECK-ENCODING: [0x31,0x84,0xbe,0x81]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 81be8431 <unknown>

fmops   za0.s, p5/m, p2/m, z19.h, z20.h
// CHECK-INST: fmops   za0.s, p5/m, p2/m, z19.h, z20.h
// CHECK-ENCODING: [0x70,0x56,0xb4,0x81]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 81b45670 <unknown>

fmops   za0.s, p6/m, p0/m, z12.h, z2.h
// CHECK-INST: fmops   za0.s, p6/m, p0/m, z12.h, z2.h
// CHECK-ENCODING: [0x90,0x19,0xa2,0x81]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 81a21990 <unknown>

fmops   za1.s, p2/m, p6/m, z1.h, z26.h
// CHECK-INST: fmops   za1.s, p2/m, p6/m, z1.h, z26.h
// CHECK-ENCODING: [0x31,0xc8,0xba,0x81]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 81bac831 <unknown>

fmops   za1.s, p2/m, p0/m, z22.h, z30.h
// CHECK-INST: fmops   za1.s, p2/m, p0/m, z22.h, z30.h
// CHECK-ENCODING: [0xd1,0x0a,0xbe,0x81]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 81be0ad1 <unknown>

fmops   za2.s, p5/m, p7/m, z9.h, z1.h
// CHECK-INST: fmops   za2.s, p5/m, p7/m, z9.h, z1.h
// CHECK-ENCODING: [0x32,0xf5,0xa1,0x81]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 81a1f532 <unknown>

fmops   za3.s, p2/m, p5/m, z12.h, z11.h
// CHECK-INST: fmops   za3.s, p2/m, p5/m, z12.h, z11.h
// CHECK-ENCODING: [0x93,0xa9,0xab,0x81]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 81aba993 <unknown>

// --------------------------------------------------------------------------//
// Non-widening (single-precision)

fmops   za0.s, p0/m, p0/m, z0.s, z0.s
// CHECK-INST: fmops   za0.s, p0/m, p0/m, z0.s, z0.s
// CHECK-ENCODING: [0x10,0x00,0x80,0x80]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 80800010 <unknown>

fmops   za1.s, p5/m, p2/m, z10.s, z21.s
// CHECK-INST: fmops   za1.s, p5/m, p2/m, z10.s, z21.s
// CHECK-ENCODING: [0x51,0x55,0x95,0x80]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 80955551 <unknown>

fmops   za3.s, p3/m, p7/m, z13.s, z8.s
// CHECK-INST: fmops   za3.s, p3/m, p7/m, z13.s, z8.s
// CHECK-ENCODING: [0xb3,0xed,0x88,0x80]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 8088edb3 <unknown>

fmops   za3.s, p7/m, p7/m, z31.s, z31.s
// CHECK-INST: fmops   za3.s, p7/m, p7/m, z31.s, z31.s
// CHECK-ENCODING: [0xf3,0xff,0x9f,0x80]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 809ffff3 <unknown>

fmops   za1.s, p3/m, p0/m, z17.s, z16.s
// CHECK-INST: fmops   za1.s, p3/m, p0/m, z17.s, z16.s
// CHECK-ENCODING: [0x31,0x0e,0x90,0x80]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 80900e31 <unknown>

fmops   za1.s, p1/m, p4/m, z1.s, z30.s
// CHECK-INST: fmops   za1.s, p1/m, p4/m, z1.s, z30.s
// CHECK-ENCODING: [0x31,0x84,0x9e,0x80]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 809e8431 <unknown>

fmops   za0.s, p5/m, p2/m, z19.s, z20.s
// CHECK-INST: fmops   za0.s, p5/m, p2/m, z19.s, z20.s
// CHECK-ENCODING: [0x70,0x56,0x94,0x80]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 80945670 <unknown>

fmops   za0.s, p6/m, p0/m, z12.s, z2.s
// CHECK-INST: fmops   za0.s, p6/m, p0/m, z12.s, z2.s
// CHECK-ENCODING: [0x90,0x19,0x82,0x80]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 80821990 <unknown>

fmops   za1.s, p2/m, p6/m, z1.s, z26.s
// CHECK-INST: fmops   za1.s, p2/m, p6/m, z1.s, z26.s
// CHECK-ENCODING: [0x31,0xc8,0x9a,0x80]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 809ac831 <unknown>

fmops   za1.s, p2/m, p0/m, z22.s, z30.s
// CHECK-INST: fmops   za1.s, p2/m, p0/m, z22.s, z30.s
// CHECK-ENCODING: [0xd1,0x0a,0x9e,0x80]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 809e0ad1 <unknown>

fmops   za2.s, p5/m, p7/m, z9.s, z1.s
// CHECK-INST: fmops   za2.s, p5/m, p7/m, z9.s, z1.s
// CHECK-ENCODING: [0x32,0xf5,0x81,0x80]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 8081f532 <unknown>

fmops   za3.s, p2/m, p5/m, z12.s, z11.s
// CHECK-INST: fmops   za3.s, p2/m, p5/m, z12.s, z11.s
// CHECK-ENCODING: [0x93,0xa9,0x8b,0x80]
// CHECK-ERROR: instruction requires: sme
// CHECK-UNKNOWN: 808ba993 <unknown>

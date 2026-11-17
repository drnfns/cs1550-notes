# io management

## io hardware

### accessing device registers

the os controls devices by reading and writing their registers. there are two ways to access them:

#### port mapped io (PMIO)

they exist in a separate io address space, and we use special instructions to access them:

```asm
IN  $0x60, %al # read byte from port 0x80
OUT %al, 0x80  # write byte to port 0x80
```

#### memory mapped io (MMIO)

the registers are mapped into the process memory address space. it shares the same address space as the system ram and rom. we can read and write to it using standard memory instructions.

basically all modern io uses MMIO.

### accessing devices

in linux, we can access them in `/dev` and `/sys`.

`/dev` exposes `devfs`, which contains entry points we can read or write.

`/sys` exposes `sysfs`, which contains the metadata and turnables for every device. for example:

- `/sys/block/ada/queue/scheduler` picks the io scheduler
- `/sys/class/net/eth0/statistics/ex_packets` contains the live statistics

## cpu device communication

## kernel io stack

# io management

## io hardware

### accessing device registers

the os controls devices by **reading and writing their registers**. there are *two*
ways to access them:

#### port mapped io (PMIO)

they exist in a **separate io address space**, and we use **special instructions** to
access them:

```asm
IN  $0x60, %al # read byte from port 0x60
OUT %al, 0x80  # write byte to port 0x80
```

#### memory mapped io (MMIO)

the registers are **mapped into the process memory address space**. it *shares the
same address space* as the system ram and rom. we can read and write to it using
**standard memory instructions**.

basically *all* modern io uses MMIO.

### accessing devices

in linux, we can access them in `/dev` and `/sys`.

`/dev` exposes `devfs`, which contains **entry points** we can read or write.

`/sys` exposes `sysfs`, which contains the **metadata and tunables** for every
device. for example:

- `/sys/block/sda/queue/scheduler` picks the io scheduler
- `/sys/class/net/eth0/statistics/rx_packets` contains the live statistics

## cpu device communication

there are three ways to communicate with devices; **polling**, **interrupts**, and **DMA**.

in polling, the cpu **busy-waits**. it is used in *very fast* or *real-time* devices,
because it provides **low latency** on those devices.

interrupts we have learned before, where the cpu **runs other work** while waiting
for an interrupt signal. it is used on *slow or medium* devices.

with *large data transfers*, we use DMA, which requires a **separate DMA controller**.

### polling

see code:

```c
while (device->status & BUSY);  // (1) wait for idle
device->command = WRITE_SECTOR; // (2) issue command
device->data_out = buf[0];
while (device->status & BUSY);  // (3) wait for completion
```

**pros:** it is loop based, which means *no hardware setup*. it also have *low latency*.

**cons:** it *burns cpu cycles* and *starves other work*.

### interrupts

like learned before, the device interrupts the cpu when it is done.

steps:

1. cpu issue command, and puts the process to *sleep*
2. cpu runs other work picked by the scheduler
3. when device finishes, it sends a signal over the **interrupt request line**
   (IRQ), or sends a **message signaled interrupt** (MSI).
4. cpu saves current state of process, jumps to the kernel's **interrupt handler**
   (ISR).
5. ISR acknowledge the interrupt, reads results, and wakes up the process
   earlier
6. execution resumes

interrupt is used pretty commonly, but there is a problem; a network card can generate *millions of interrupts* on each receiving packet, which is not good.

to fix this, we can use **interrupt coalescing**. there are several ways to achieve this:

- **count based**: interrupt after N events
- **time based**: interrupt after T us
- **combined**: interrupt when either is hit

linux uses another method: **NAPI**; where on the first packet interrupt, switch to polling until the queue is drained,
then turn interrupts back on.

### direct memory access (DMA)

## kernel io stack

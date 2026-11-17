# disk scheduling

we can calculate:

$$
T_{I/O} = T_{seek} + T_{rotation} + T_{}
$$

## classical scheduling

some classical disk scheduling algorithms:

- **FCFS**: first come first served
- **SSTF**: shortest seek time first
- **SCAN** (elevator): sweep back and forth
- **C-SCAN**: sweep one direction only, wrap around
- **LOOK** / **C-LOOK**: SCAN variants
- **SATF**: shortest access time first

### FCFS

we move the head based arrival order. for example:

```
queue  = 98, 183, 37, 122, 14, 124, 65, 67
head   = 53
seq    = 98, 183, 37, 122, 14, 124, 65, 67
travel = 640
```

for this sequence, the total seek distance would be 640 cylinders.

fair algorithm and no process starves, but it is slow.

### SSTF

we scan and prioritize the request closest to the current head position.

```
queue  = 98, 183, 37, 122, 14, 124, 65, 67
head   = 53
seq    = 53, 65, 67, 37, 14, 98, 122, 124, 183
travel = 236
```

### SCAN (elevator)

we move the head between start and end in an alternating pattern, and service
requests along the way.

```
queue  = 98, 183, 37, 122, 14, 124, 65, 67
head   = 53
seq    = 53, 37, 14, 0, 65, 67, 98, 122, 124, 183
travel = 236
```

there is no starvation, and good throughput.

### C-SCAN

instead of an alternating pattern, after reaching the end, we move the head to
the start (without serving requests).

```
queue  = 98, 183, 37, 122, 14, 124, 65, 67
head   = 53
seq    = 53, 65, 67, 98, 122, 124, 183, 199, 0, 14, 37
travel = 382
```

more uniform wait time compared to the previous. in normal SCAN, requests have
to wait for a full alternate.

### LOOK / C-LOOK

### SATF

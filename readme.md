# countdown

bybit has a countdown timer that can lapse 10 minutes
in just some little 15 minutes which lowkey fucking sucks

i would like to check how much of a fucking insane approach to
solving the "countdown timer" problem should i take in order to
achieve similar results

the most insane possible one: count each second on a backend's event loop
and send as responses. the simplest of non-sucking update polling methods
has been chosen: http long polling.

i would like to write similar shit in go, but for a starter
i wrote it in perl to check how would single-threaded event-loop-driven
server do

# suite

```sh
./test.sh $nclients
cat test/*|while read a b; do echo $((abs(a-b)));done|dtk uc
```

# 100 clients

```text
18      2
82      1
```

# bad 10k clients

forgor `--clients` argument, so the max number of concurrent connections
have been limited to 1k. idk how it "doesn't accept the connection" so that
all my curls have got the responses and not failed, but the whole test
took 00:36:52

results of 10000/1000 test are as follows:
```text
6       16
81      15
95      14
128     13
205     12
335     1
572     11
843     9
878     10
911     7
931     8
957     5
963     6
1053    4
1054    3
1088    2
```


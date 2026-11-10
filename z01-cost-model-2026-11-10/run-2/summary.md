Plan `full`, renderer `NVIDIA GeForce GTX 1650/PCIe/SSE2`, ziarno 3981597853228476150, przebieg wstępny L = 512.

Odcinki: 432; zakwalifikowane dla GPU 343, dla GPU i CPU 213 (powody: {'probe_cpu_after': 138, 'probe_cpu_before': 69, 'probe_gpu_before': 89, 'probe_gpu_after': 19, 'graphics_clock_below_session_max': 7}); odcinki z sw_power_cap: 138; próbki telemetrii: 13874; maks. zegar sesji: 1935.0 MHz; czekanie na schłodzenie: 2840 s w 77 odcinkach.

Odrzucone próbki primed (zlecenie trwało dłużej niż przebieg wstępny): 0.

### Koszt jednego przebiegu (µs, nachylenie a + b·M po M)

| Przebieg | GPU cold | GPU primed | ścienny cold | ścienny finish_each | CPU zlecenie |
| --- | --- | --- | --- | --- | --- |
| pusty + bariera | 1,5 | 1,4 | 1,5 | 24,0 | 0,01 |
| indirect, 0 grup | 1,5 | 1,1 | 1,4 | 23,0 | 0,01 |
| łańcuch T=256 L=16 | 9,4 | 9,6 | 10,3 | 36,9 | 0,01 |
| łańcuch T=256 L=256 | 118,4 | 119,1 | 118,5 | 144,3 | 0,01 |
| łańcuch T=4096 L=16 | 54,6 | 54,1 | 55,1 | 81,7 | 0,01 |
| łańcuch T=32768 L=16 | 415,0 | 415,7 | 416,8 | 450,4 | 0,01 |

### Łańcuch: koszt przebiegu wobec L i T·L (GPU primed)

| T | L | T·L | µs/przebieg | µs na odczyt łańcucha (L) | ns na odczyt (T·L) |
| --- | --- | --- | --- | --- | --- |
| 256 | 16 | 4096 | 9,6 | 0,599 | 2,340 |
| 256 | 256 | 65536 | 119,1 | 0,465 | 1,818 |
| 4096 | 16 | 65536 | 54,1 | 3,380 | 0,825 |
| 4096 | 256 | 1048576 | 819,1 | 3,200 | 0,781 |
| 32768 | 16 | 524288 | 415,7 | 25,983 | 0,793 |
| 32768 | 256 | 8388608 | 6538,6 | 25,542 | 0,779 |

### Ta sama praca: M przebiegów wobec jednego (GPU ms)

| T | L | M | M przebiegów | 1 przebieg, L·M na wątek | 1 przebieg, T·M wątków |
| --- | --- | --- | --- | --- | --- |
| 256 | 16 | 64 | 0,602 | 0,467 | 0,209 |
| 4096 | 16 | 64 | 3,456 | 3,242 | 3,284 |
| 32768 | 16 | 64 | 26,460 | 26,035 | 26,449 |
| 256 | 256 | 64 | 7,661 | 7,493 | 3,251 |
| 4096 | 256 | 64 | 52,308 | 51,857 | 52,309 |
| 32768 | 256 | 64 | 420,225 | 414,400 | 418,837 |

### Sweep: ms na tick (mediana bloków)

| N | ziarna GPU | ziarna ścienny | ziarna dispatche | woda GPU | woda ścienny | woda dispatche |
| --- | --- | --- | --- | --- | --- | --- |
| 1000 | 0,561 | 0,620 | 41 | 1,553 | 1,637 | 51 |
| 2000 | 0,654 | 0,713 | 41 | 1,641 | 1,735 | 51 |
| 4000 | 0,714 | – | 41 | 1,782 | – | 51 |
| 8000 | 1,024 | 1,103 | 41 | 2,485 | 2,572 | 51 |
| 16000 | 1,937 | 2,037 | 41 | 4,991 | – | 51 |
| 32000 | 4,136 | – | 41 | 9,630 | – | 51 |

### Dopasowanie a + b·N i ekstrapolacja (64k i 128k to ekstrapolacja poza pomiarem)

Próg: N, przy którym prosta przecina koszt przy najmniejszym N.

| Materiał | Miara | zakres N (punkty) | a [ms] | b [ms/1000] | R² | próg N | 64k [ms] | 128k [ms] |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| ziarna | GPU | 1000–32000 (6) | 0,288 | 0,1159 | 0,985 | 2354 | 7,880 | 15,473 |
| ziarna | GPU | 8000–32000 (3) | -0,076 | 0,1308 | 0,998 | 4865 | 8,496 | 17,068 |
| ziarna | ścienny | 1000–16000 (4) | 0,491 | 0,0929 | 0,981 | 1394 | 6,582 | 12,673 |
| ziarna | ścienny | 8000–16000 (2) | 0,168 | 0,1168 | 1,000 | 3873 | 7,823 | 15,479 |
| woda | GPU | 1000–32000 (6) | 0,874 | 0,2672 | 0,988 | 2541 | 18,388 | 35,902 |
| woda | GPU | 8000–32000 (3) | 0,165 | 0,2966 | 1,000 | 4680 | 19,604 | 39,043 |
| woda | ścienny | 1000–8000 (3) | 1,484 | 0,1357 | 0,999 | 1131 | 10,374 | 19,265 |

Tick GPU przy wolnej wobec szybkiej sondzie CPU, ten sam punkt (1 punktów): mediana stosunku 1,019, zakres 1,019–1,019.

Sondy: CPU mediana 14,444 ms (min 14,204, maks. 73,879); GPU mediana 3,459 ms (min 3,432, maks. 22,592).

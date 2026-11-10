Plan `full`, renderer `NVIDIA GeForce GTX 1650/PCIe/SSE2`, ziarno 4521618711065972830, przebieg wstępny L = 512.

Odcinki: 432; zakwalifikowane dla GPU 432, dla GPU i CPU 349 (powody: {'probe_cpu_after': 83}); odcinki z sw_power_cap: 113; próbki telemetrii: 13678; maks. zegar sesji: 1935.0 MHz; czekanie na schłodzenie: 2460 s w 95 odcinkach.

Odrzucone próbki primed (zlecenie trwało dłużej niż przebieg wstępny): 0.

### Koszt jednego przebiegu (µs, nachylenie a + b·M po M)

| Przebieg | GPU cold | GPU primed | ścienny cold | ścienny finish_each | CPU zlecenie |
| --- | --- | --- | --- | --- | --- |
| pusty + bariera | 1,4 | 1,4 | 1,6 | 23,1 | 0,01 |
| indirect, 0 grup | 1,3 | 1,0 | 1,5 | 26,1 | 0,01 |
| łańcuch T=256 L=16 | 10,8 | 9,4 | 10,9 | 35,9 | 0,01 |
| łańcuch T=256 L=256 | 117,6 | 117,6 | 117,9 | 158,2 | 0,01 |
| łańcuch T=4096 L=16 | 53,8 | 53,8 | 53,9 | 95,0 | 0,01 |
| łańcuch T=32768 L=16 | 409,4 | 409,6 | 409,8 | 450,8 | 0,01 |

### Łańcuch: koszt przebiegu wobec L i T·L (GPU primed)

| T | L | T·L | µs/przebieg | µs na odczyt łańcucha (L) | ns na odczyt (T·L) |
| --- | --- | --- | --- | --- | --- |
| 256 | 16 | 4096 | 9,4 | 0,589 | 2,301 |
| 256 | 256 | 65536 | 117,6 | 0,459 | 1,794 |
| 4096 | 16 | 65536 | 53,8 | 3,363 | 0,821 |
| 4096 | 256 | 1048576 | 808,9 | 3,160 | 0,771 |
| 32768 | 16 | 524288 | 409,6 | 25,602 | 0,781 |
| 32768 | 256 | 8388608 | 6465,4 | 25,255 | 0,771 |

### Ta sama praca: M przebiegów wobec jednego (GPU ms)

| T | L | M | M przebiegów | 1 przebieg, L·M na wątek | 1 przebieg, T·M wątków |
| --- | --- | --- | --- | --- | --- |
| 256 | 16 | 64 | 0,602 | 0,465 | 0,209 |
| 4096 | 16 | 64 | 3,437 | 3,219 | 3,261 |
| 32768 | 16 | 64 | 26,230 | 25,815 | 26,065 |
| 256 | 256 | 64 | 7,543 | 7,392 | 3,227 |
| 4096 | 256 | 64 | 51,777 | 51,522 | 51,598 |
| 32768 | 256 | 64 | 413,719 | 412,623 | 412,672 |

### Sweep: ms na tick (mediana bloków)

| N | ziarna GPU | ziarna ścienny | ziarna dispatche | woda GPU | woda ścienny | woda dispatche |
| --- | --- | --- | --- | --- | --- | --- |
| 1000 | 0,576 | 0,645 | 41 | 1,539 | 1,618 | 51 |
| 2000 | 0,664 | 0,762 | 41 | 1,625 | 1,734 | 51 |
| 4000 | 0,707 | 0,830 | 41 | 1,774 | 1,900 | 51 |
| 8000 | 1,004 | 1,078 | 41 | 2,487 | 2,630 | 51 |
| 16000 | 1,949 | 2,041 | 41 | 4,971 | – | 51 |
| 32000 | 4,164 | 4,302 | 41 | 9,344 | – | 51 |

### Dopasowanie a + b·N i ekstrapolacja (64k i 128k to ekstrapolacja poza pomiarem)

Próg: N, przy którym prosta przecina koszt przy najmniejszym N.

| Materiał | Miara | zakres N (punkty) | a [ms] | b [ms/1000] | R² | próg N | 64k [ms] | 128k [ms] |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| ziarna | GPU | 1000–32000 (6) | 0,286 | 0,1166 | 0,983 | 2488 | 7,927 | 15,567 |
| ziarna | GPU | 8000–32000 (3) | -0,104 | 0,1326 | 0,999 | 5127 | 8,588 | 17,280 |
| ziarna | ścienny | 1000–32000 (6) | 0,370 | 0,1180 | 0,982 | 2329 | 8,104 | 15,837 |
| ziarna | ścienny | 8000–32000 (3) | -0,053 | 0,1353 | 0,999 | 5159 | 8,816 | 17,686 |
| woda | GPU | 1000–32000 (6) | 0,906 | 0,2588 | 0,990 | 2447 | 17,865 | 34,825 |
| woda | GPU | 8000–32000 (3) | 0,300 | 0,2839 | 0,999 | 4362 | 18,908 | 37,516 |
| woda | ścienny | 1000–8000 (4) | 1,427 | 0,1450 | 0,975 | 1317 | 10,928 | 20,430 |

Tick GPU przy wolnej wobec szybkiej sondzie CPU, ten sam punkt (7 punktów): mediana stosunku 0,992, zakres 0,889–1,001.

Sondy: CPU mediana 14,404 ms (min 14,113, maks. 25,315); GPU mediana 3,436 ms (min 3,423, maks. 3,491).

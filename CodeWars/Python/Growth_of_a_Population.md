## Description

In a small town the population is p0 = 1000 at the beginning of a year. The population regularly increases by 2 percent per year and moreover 50 new inhabitants per year come to live in the town. How many years does the town need to see its population greater or equal to p = 1200 inhabitants?

Examples:
```
nb_year(1500, 5, 100, 5000) -> 15
nb_year(1500000, 2.5, 10000, 2000000) -> 10
```

## My solutions

```py
import math
def nb_year(p0, percent, aug, p):
    i = int()
    while p0 < p:
        p0 = math.floor(p0 + (p0 * (percent/100)) + aug)
        i += 1
    return i
```

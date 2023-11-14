## Description

Write an algorithm that takes an array and moves all of the zeros to the end, preserving the order of the other elements.

```move_zeros([1, 0, 1, 2, 0, 1, 3]) # returns [1, 1, 2, 1, 3, 0, 0]```

## My solutions

```py
def move_zeros(lst):
    slov = []
    for i, j in enumerate(lst):
        if j == 0:
            slov.append(i)
        else:
            continue
    slov.reverse()
    for i, j in enumerate(slov):
        lst.pop(j)
        lst.append(0)
    return lst
```
```py
def move_zeros(lst):
    return sorted(lst, key=lambda x: x==0 and type(x) is not bool
```
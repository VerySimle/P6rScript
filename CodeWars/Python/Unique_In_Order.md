## Description

Implement the function unique_in_order which takes as argument a sequence and returns a list of items without any elements with the same value next to each other and preserving the original order of elements.

## My solutions

```py
def unique_in_order(sequence):
    var = ""
    orig = []
    for i in sequence:
        if i != var:
            orig.append(i)
        var = i
    return orig
```
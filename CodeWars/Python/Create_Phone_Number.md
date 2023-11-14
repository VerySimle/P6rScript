## Description

Write a function that accepts an array of 10 integers (between 0 and 9), that returns a string of those numbers in the form of a phone number.

Example

```create_phone_number([1, 2, 3, 4, 5, 6, 7, 8, 9, 0]) # => returns "(123) 456-7890"```
```
'{}-{}-{}'.format(1, 2, 3)  # '1-2-3'
'{}-{}-{}'.format(*[1, 2, 3])  # '1-2-3'
'{one}-{two}-{three}'.format(two=2, one=1, three=3)  # '1-2-3'
'{one}-{two}-{three}'.format(**{'two': 2, 'one': 1, 'three': 3})  # '1-2-3'

```
## My solutions

```py
def create_phone_number(n):
    return "({}{}{}) {}{}{}-{}{}{}{}".format(*n)
```

## Description

You probably know the "like" system from Facebook and other pages. People can "like" blog posts, pictures or other items. We want to create the text that should be displayed next to such an item.

Implement the function which takes an array containing the names of people that like an item. It must return the display text as shown in the examples:
```
[]                                -->  "no one likes this"
["Peter"]                         -->  "Peter likes this"
["Jacob", "Alex"]                 -->  "Jacob and Alex like this"
["Max", "John", "Mark"]           -->  "Max, John and Mark like this"
["Alex", "Jacob", "Mark", "Max"]  -->  "Alex, Jacob and 2 others like this"
```
Note: For 4 or more names, the number in `and 2 others` simply increases.

## My solutions

```py
def likes(names):
    arr = []
    match names:
        case list() as name if len(name) == 0:
            ret = ('no one likes this')
        case list() as name if len(name) > 0 and len(name) < 2:
            for i,j in enumerate(name):
                arr.append(j)
            ret = (f'{arr.pop(0)} likes this')
        case list() as name if len(name) > 0 and len(name) < 3:
            for i,j in enumerate(name):
                arr.append(j)
            ret = (f'{arr.pop(0)} and {arr.pop(0)} like this')
        case list() as name if len(name) > 0 and len(name) < 4:
            for i,j in enumerate(name):
                arr.append(j)
            ret = (f'{arr.pop(0)}, {arr.pop(0)} and {arr.pop(0)} like this')
        case list() as name if len(name) > 3:
            for i,j in enumerate(name):
                arr.append(j)
            ret = (f'{arr.pop(0)}, {arr.pop(0)} and {len(arr)} others like this')
    return ret
```
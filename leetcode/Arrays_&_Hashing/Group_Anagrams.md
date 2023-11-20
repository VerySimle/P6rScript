## Description
Given an array of strings strs, group the anagrams together. You can return the answer in any order.

An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once.

 

Example 1:
```
Input: strs = ["eat","tea","tan","ate","nat","bat"]
Output: [["bat"],["nat","tan"],["ate","eat","tea"]]
```
Example 2:
```
Input: strs = [""]
Output: [[""]]
```
Example 3:
```
Input: strs = ["a"]
Output: [["a"]]

 ```

Constraints:

    1 <= strs.length <= 104
    0 <= strs[i].length <= 100
    strs[i] consists of lowercase English letters.



## My solutions

```Python
class Solution:
    def groupAnagrams(self, strs: List[str]) -> List[List[str]]:
        DefDict = defaultdict(list)
        for i in strs:
            key = ''.join(sorted(i))
            DefDict[key].append(i)
        reversDef = list(DefDict.values())
        reversDef.reverse()
        return reversDef
```

## Best practice

```Python
class Solution:
    def groupAnagrams(self, strs: List[str]) -> List[List[str]]:
        prevDict = {} #key : val
        for words in strs:
            key = tuple(sorted(words))
            prevDict[key] = prevDict.get(key, []) + [words]
        return prevDict.values()
```
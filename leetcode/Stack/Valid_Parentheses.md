## Description
Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid.

An input string is valid if:

    Open brackets must be closed by the same type of brackets.
    Open brackets must be closed in the correct order.
    Every close bracket has a corresponding open bracket of the same type.

 

Example 1:
```
Input: s = "()"
Output: true
```
Example 2:
```
Input: s = "()[]{}"
Output: true
```
Example 3:
```
Input: s = "(]"
Output: false
```
 

Constraints:

    1 <= s.length <= 10^4
    s consists of parentheses only '()[]{}'.


## Solutions


```Python
class Solution:
    def longestConsecutive(self, nums: List[int]) -> int:
        HashSet = set(nums)
        iterableObj = 0
        for x in nums:
            if x - 1 not in HashSet:
                y = x + 1
                while y in HashSet:
                    y += 1
                iterableObj = max(iterableObj, y - x)
        return iterableObj
```
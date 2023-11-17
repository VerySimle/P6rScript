## Description
Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

You can return the answer in any order.

 

Example 1:
```
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
```
Example 2:
```
Input: nums = [3,2,4], target = 6
Output: [1,2]
```
Example 3:
```
Input: nums = [3,3], target = 6
Output: [0,1]
```
 

Constraints:

    2 <= nums.length <= 10^4
    -10^9 <= nums[i] <= 10^9
    -10^9 <= target <= 10^9
    Only one valid answer exists.

 
Follow-up: Can you come up with an algorithm that is less than O(n2) time complexity?

## My solutions

```Python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        out = []
        for i, j in enumerate(nums):
            for s, c in enumerate(nums):
                if i != s and j + c == target:
                    out.append(i), out.append(s)
                    break
            if j + c == target:
                break
        return out
```
### The task was not completed because the list was sorted in order to cut off elements exceeding the target
```Python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        validate = []
        nums.sort()
        out = []
        for i in nums:
            if target > i:
                validate.append(i)
            else:
                break
        for i, j in enumerate(validate):
            for s, c in enumerate(validate):
                if i != s and j + c == target:
                    out.append(i), out.append(s)
                    break
            if j + c == target:
                break
        return out
```
## Best practice

```Python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        prevMap = {} # val : index
        for i, j in enumerate(nums):
            diff = target - j
            if diff in prevMap:
                return [prevMap[diff], i]
            prevMap[j] = i
        return
```
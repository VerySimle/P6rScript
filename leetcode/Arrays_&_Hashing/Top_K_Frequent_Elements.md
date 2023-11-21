## Description
Given an integer array nums and an integer k, return the k most frequent elements. You may return the answer in any order.

 

Example 1:
```
Input: nums = [1,1,1,2,2,3], k = 2
Output: [1,2]
```
Example 2:
```
Input: nums = [1], k = 1
Output: [1]
```
 

Constraints:

    1 <= nums.length <= 10^5
    -10^4 <= nums[i] <= 10^4
    k is in the range [1, the number of unique elements in the array].
    It is guaranteed that the answer is unique.

 

Follow up: Your algorithm's time complexity must be better than O(n log n), where n is the array's size.


## My solutions
### Fail (I misunderstood the condition. Prints all duplicate values ​​greater than k)

```Python
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        arr = []
        MapNumb = Counter(nums)
        i = 0
        while i<=len(nums):
            if MapNumb[i] >= k:
                arr += [i]
            i += 1  
        return arr
```

### Success
```Python
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        MapNumb = Counter(nums).most_common(k)
        arr = []
        for i in range(k):
            value = MapNumb[i]
            arr.append(value[0])
        return arr
```
### №2
```Python
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        MapNumb = Counter(nums)
        arr = []
        MapNumSort = sorted(MapNumb.items(), key=lambda x: x[1], reverse=True)
        for i in range(k):
            value = MapNumSort[i]
            arr.append(value[0])
        return arr
```
## Best practice

```Python
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        count = {}
        freq = [[] for i in range(len(nums) + 1)]
        for n in nums:
            count[n] = 1 + count.get(n, 0)
        for n, c in count.items():
            freq[c].append(n)
        
        res = []
        for i in range(len(freq) - 1, 0, -1):
            for n in freq[i]:
                res.append(n)
                if len(res) == k:
                    return res
```
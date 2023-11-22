## Description
Determine if a 9 x 9 Sudoku board is valid. Only the filled cells need to be validated according to the following rules:

    Each row must contain the digits 1-9 without repetition.
    Each column must contain the digits 1-9 without repetition.
    Each of the nine 3 x 3 sub-boxes of the grid must contain the digits 1-9 without repetition.

Note:

    A Sudoku board (partially filled) could be valid but is not necessarily solvable.
    Only the filled cells need to be validated according to the mentioned rules.

 

Example 1:

![App Screenshot](https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Sudoku-by-L2G-20050714.svg/250px-Sudoku-by-L2G-20050714.svg.png)

```
Input: board = 
[["5","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]
Output: true
```
Example 2:
```
Input: board = 
[["8","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]
Output: false
```
Explanation: Same as Example 1, except with the 5 in the top left corner being modified to 8. Since there are two 8's in the top left 3x3 sub-box, it is invalid.

 

Constraints:

    board.length == 9
    board[i].length == 9
    board[i][j] is a digit 1-9 or '.'.


## My solutions


```Python
class Solution:
    def isValidSudoku(self, board: List[List[str]]) -> bool:
        left_sub_boxes = []
        right_sub_boxes = []
        center_sub_boxes = []
        hash_sub = set()
        for i in range(9):
            left_sub_boxes += board[i][:3]
            center_sub_boxes += board[i][3:6]
            right_sub_boxes += board[i][3:6]
            if i == 2 or i == 5 or i == 8:
                for n in left_sub_boxes:
                    if n in hash_sub and n != ".":
                        return False
                    hash_sub.add(n)
                hash_sub.clear()
                for n in center_sub_boxes:
                    if n in hash_sub and n != ".":
                        return False
                    hash_sub.add(n)
                hash_sub.clear()
                for n in right_sub_boxes:
                    if n in hash_sub and n != ".":
                        return False
                    hash_sub.add(n)
                hash_sub.clear()
                left_sub_boxes.clear(), center_sub_boxes.clear(), right_sub_boxes.clear()
        board_revers = tuple(zip(*board[::-1]))
        hashMap = set()
        for i,j in enumerate(board):
            for n in j:
                if n in hashMap and n != ".":
                    return False
                hashMap.add(n)
            hashMap.clear()
        for i, j in enumerate(board_revers):
            for n in j:
                if n in hashMap and n != ".":
                    return False
                hashMap.add(n)
            hashMap.clear()
        return True
```

## Best practice

```Python
class Solution:
    def isValidSudoku(self, board: List[List[str]]) -> bool:
        cols = collections.defaultdict(set)
        rows = collections.defaultdict(set)
        squares = collections.defaultdict(set)
        for r in range(9):
            for c in range(9):
                if board[r][c] == ".":
                    continue
                if (board[r][c] in rows[r] or board[r][c] in cols[c] or board[r][c] in squares[(r//3,c//3)]):
                    return False
                cols[c].add(board[r][c])
                rows[r].add(board[r][c])
                squares[(r//3,c//3)].add(board[r][c])
        return True
```
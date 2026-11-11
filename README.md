<div align="center">

# 🧩 Prolog & Haskell Projects

**Two small projects from *Concepts of Programming Languages*: a constraint solver in Prolog and a puzzle engine in Haskell.**

[![Verify](https://github.com/DanEhab/prolog-haskell-projects/actions/workflows/verify.yml/badge.svg)](https://github.com/DanEhab/prolog-haskell-projects/actions/workflows/verify.yml)
![Course](https://img.shields.io/badge/Course-CSEN403%20Concepts%20of%20Programming%20Languages-1f6feb)
![Semester](https://img.shields.io/badge/Semester-Spring%202024-8957e5)
![Prolog](https://img.shields.io/badge/Prolog-SWI--Prolog-e61b23)
![Haskell](https://img.shields.io/badge/Haskell-GHC-5e5086)
![Grade](https://img.shields.io/badge/Course%20grade-A%2B-success)

</div>

---

| Project | Paradigm | What it does |
|---|---|---|
| [**Quiz Proctoring System**](#1-quiz-proctoring-system-prolog) | Logic programming | Assigns TAs to proctor quizzes without breaking any scheduling rule |
| [**Peg Reversal**](#2-peg-reversal-haskell) | Functional programming | Models a one-player board game: board setup, legal moves, next states, win check |

---

## 1. Quiz Proctoring System (Prolog)

📄 [`prolog-quiz-proctoring/proctoring.pl`](prolog-quiz-proctoring/proctoring.pl)

Every week there are quizzes in different slots, and each one needs a certain number of TA proctors. The program finds an assignment that respects every rule, checks a given assignment, or answers `false` when no assignment is possible.

**Rules it enforces**

- Each quiz gets exactly the number of proctors it needs.
- A TA never proctors in a slot where they are teaching.
- A TA never proctors on their day off.
- A TA is never assigned to two quizzes in the same slot.

**How it works**

1. `free_schedule/3` turns the teaching schedule into a *free* schedule: for each of the 6 days × 5 slots, the TAs who are neither teaching nor on their day off.
2. `assign_quiz/3` picks the required number of TAs from the free list of that quiz's slot.
3. `assign_quizzes/3` does this for every quiz, then rejects any result where two quizzes in the same slot share a TA.
4. `assign_proctors/4` ties it together. Because it is Prolog, asking for more answers on backtracking gives **every valid schedule**, and checking a given schedule uses the same predicate.

**Run it**

```console
$ cd prolog-quiz-proctoring
$ swipl -q -g run -t halt example.pl
csen403 on sat, slot 2  ->  [slim,nourhan]
csen401 on sat, slot 2  ->  [ahmed]
math401 on tue, slot 1  ->  [nourhan,ahmed]
```

`example.pl` contains a small sample week (4 TAs, 3 quizzes) that you can edit.

---

## 2. Peg Reversal (Haskell)

📄 [`haskell-peg-reversal/PegReversal.hs`](haskell-peg-reversal/PegReversal.hs)

The board is a **plus-shaped grid of 33 pegs** centred on `(0,0)`. At the start every peg is black except one white peg. A move flips a black peg to white, but only if at least one of its four neighbours (up, down, left, right) is already white. You win when every peg is white.

**Types**

```haskell
type Position = (Int, Int)
data Color    = W | B
data Peg      = Peg Position Color
data Move     = M Position
type Board    = [Peg]
data State    = S Move Board
```

**Functions**

| Function | Purpose |
|---|---|
| `createBoard pos` | Builds the 33-peg board with the white peg at `pos` (raises an error for an off-board position) |
| `isValidMove move board` | Checks that the target has a white neighbour in one of the four directions |
| `showPossibleNextStates board` | Lists every state reachable in one move |
| `isGoal board` | `True` when every peg is white |

**Try it in GHCi**

```console
$ cd haskell-peg-reversal
$ ghci PegReversal.hs
ghci> length (createBoard (0,0))
33
ghci> isValidMove (M (0,1)) (createBoard (0,0))
True
ghci> map (\(S m _) -> m) (showPossibleNextStates (createBoard (0,0)))
[M (-1,0),M (0,-1),M (0,1),M (1,0)]
ghci> isGoal (createBoard (0,0))
False
```

Starting from the centre, repeatedly taking the first possible next state wins the game in **32 moves**, one for each black peg.

Both projects run automatically on every push through GitHub Actions: the Prolog program solves the sample week, and the Haskell functions are checked with the examples above.

---

## Looking back

- **Prolog:** `free_schedule` generates every ordering of the free TAs in all 30 slots, not only in the slots that have quizzes. Finding a valid schedule is fast, but proving that *no* schedule exists can take a very long time on larger inputs. Generating orderings only for the quiz slots, or picking TAs as combinations instead of permutations, would remove most of that search.
- **Haskell:** the functions pattern-match on both peg colours separately, which repeats a lot of code. A helper that ignores the colour (or `any`/`all` over the board) would make it much shorter.

---

## Course & team

**CSEN403 Concepts of Programming Languages**, German University in Cairo, Spring 2024 (Dr. Nourhan Ehab).

**Team:** Daniel Ehab · George Amgad · Mina Hossam · Mark

# Day 5

For this day, I thought I would have to infer an order relation between the pages using the specified facts and the usual rules on order relations: Order relations are transitive, that means that if a is lesser than b and b is lesser than c implied a is lesser than c. To model this kind of constraints, logical programming is the best tool.

However, it turned out this inference if not necessary to solve the problem. In fact, infering an order relation is not possible because of cycles (a <= b, b <= c and c <= a).

I still used Prolog for a solution and wrote an other solution without prolog.

## How to run this code

The script using Prolog (pyprolog.py) depends on pyswip and on a local installation SWI/Prolog.
It can be run using [uv](https://github.com/astral-sh/uv).

```bash
uv run pyproject.py
```

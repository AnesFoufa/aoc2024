from collections import defaultdict
from heapq import heappop, heappush
from sys import argv


def part_one(path):
    left, right = [], []
    nb_elems = 0
    with open(path, "r") as f:
        for line in f:
            l, r = line.strip().split()
            heappush(left, int(l))
            heappush(right, int(r))
            nb_elems += 1
    sorted_left = (heappop(left) for _ in range(nb_elems))
    sorted_right = (heappop(right) for _ in range(nb_elems))
    res = sum(abs(l - r) for (l, r) in zip(sorted_left, sorted_right))
    print(res)


def part_two(path):
    left, right = defaultdict(int), defaultdict(int)
    with open(path, "r") as f:
        for line in f:
            l, r = line.strip().split()
            left[int(l)] += 1
            right[int(r)] += 1
    res = 0
    for l, count_left in left.items():
        count_right = right[l]
        res += l * count_left * count_right
    print(res)


if __name__ == "__main__":
    part_one(argv[1])
    part_two(argv[1])

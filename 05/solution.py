from functools import cmp_to_key
from sys import argv


def main(path):
    reading_rules = True
    part_1 = 0
    part_2 = 0
    before_db = set()

    def compare(page1, page2):
        if (page1, page2) in before_db:
            return -1
        elif part_1 == part_2:
            return 0
        else:
            return 1

    with open(path, "r") as f:
        for line in f:
            line = line.strip()
            if not line:
                reading_rules = False
                continue
            if reading_rules:
                page1, page2 = map(int, line.split("|"))
                before_db.add((page1, page2))
                continue
            sequence = list(map(int, line.split(",")))
            i_median = len(sequence) // 2
            sequence_is_sorted = all(
                compare(p1, p2) <= 0 for (p1, p2) in zip(sequence[:-1], sequence[1:])
            )
            if sequence_is_sorted:
                part_1 += sequence[i_median]
            else:
                sequence.sort(key=cmp_to_key(compare))
                part_2 += sequence[i_median]
    print(part_1, part_2, sep="\n")


if __name__ == "__main__":
    main(argv[1])

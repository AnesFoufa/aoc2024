from sys import argv

from pyswip import Prolog


def main(path):
    Prolog.consult("prelude.pl")
    reading_rules = True
    part_1 = 0
    part_2 = 0
    with open(path, "r") as f:
        for line in f:
            line = line.strip()
            if not line:
                reading_rules = False
                continue

            if reading_rules:
                page1, page2 = line.split("|")
                assertion = f"before(p{page1}, p{page2})"
                Prolog.assertz(assertion)
                continue

            sequence = line.split(",")
            i_median = len(sequence) // 2
            sequence_is_sorted = all(
                bool(list(Prolog.query(f"before(p{page1}, p{page2})")))
                for (page1, page2) in zip(sequence[:-1], sequence[1:])
            )
            if sequence_is_sorted:
                part_1 += int(sequence[i_median])
            else:
                list_pages = "[" + ", ".join([f"p{p}" for p in sequence]) + "]"
                query = f"quick_sort2({list_pages}, Sorted)"
                response = next(Prolog.query(query))
                part_2 += int(response["Sorted"][i_median][1:])

    print(part_1)
    print(part_2)


if __name__ == "__main__":
    main(argv[1])

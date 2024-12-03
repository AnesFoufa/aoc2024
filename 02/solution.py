from sys import argv


def part_one(path):
    solution(path, is_safe)


def part_two(path):
    solution(path, is_safe_with_tolerance)


def solution(path, is_safe_func):
    print(sum(is_safe_func(levels) for levels in read_levels(path)))


def read_levels(path):
    with open(path, "r") as f:
        for line in f:
            yield [int(l) for l in line.strip().split()]


def is_safe(levels):
    return is_moderately_increasing(levels) or is_moderately_increasing(levels[::-1])


def is_safe_with_tolerance(levels):
    if is_safe(levels):
        return True
    return any(is_safe(truncated_level) for truncated_level in truncate_levels(levels))


def is_moderately_increasing(levels):
    growth_rates = (
        next_level - current_level
        for (current_level, next_level) in zip(levels[:-1], levels[1:])
    )
    res = all(1 <= growth_rate <= 3 for growth_rate in growth_rates)
    return res


def truncate_levels(levels):
    for i, _ in enumerate(levels):
        yield levels[:i] + levels[i + 1 :]


if __name__ == "__main__":
    path = argv[1]
    part_one(path)
    part_two(path)

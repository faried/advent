#!/usr/bin/env python

from collections import Counter


input = {# (0, 0, 0): ".",
         # (0, 1, 0): ".",
         (0, 2, 0): "#",
         (1, 0, 0): "#",
         # (1, 1, 0): ".",
         (1, 2, 0): "#",
         # (2, 0, 0): ".",
         (2, 1, 0): "#",
         (2, 2, 0): "#"}


def neighbors(point):
    (x, y, z) = point

    return [
        (x - 1, y, z),
        (x + 1, y, z),

        (x, y - 1, z),
        (x, y + 1, z),

        (x, y, z - 1),
        (x, y, z + 1),

        (x - 1, y - 1, z),
        (x - 1, y + 1, z),
        (x + 1, y - 1, z),
        (x + 1, y + 1, z),

        (x - 1, y, z - 1),
        (x - 1, y, z + 1),
        (x + 1, y, z - 1),
        (x + 1, y, z + 1),

        (x, y - 1, z - 1),
        (x, y - 1, z + 1),
        (x, y + 1, z - 1),
        (x, y + 1, z + 1),

        (x - 1, y - 1, z - 1),
        (x - 1, y - 1, z + 1),

        (x - 1, y + 1, z - 1),
        (x - 1, y + 1, z + 1),

        (x + 1, y - 1, z - 1),
        (x + 1, y - 1, z + 1),

        (x + 1, y + 1, z - 1),
        (x + 1, y + 1, z + 1)
    ]


def findactive(state):
    return list(state.keys())


def activeneighbors(state, point):
    npoints = neighbors(point)
    c = 0

    for np in npoints:
        if np in state:
            c += 1

    return c


def cycle(state, count):
    # print(state, len(findactive(state)))

    points = findactive(state)
    # print(points)

    if count == 0:
        return len(points)

    ctr = Counter()
    tocheck = []
    for p in points:
        for n in neighbors(p):
            ctr[n] += 1
        # print(f"n for {p}")
        tocheck.extend(neighbors(p))

    tocheck = list(set(tocheck))

    changes = {}
    for p in ctr:
        active = activeneighbors(state, p)
        if p not in state and active == 3:
            assert p not in changes
            changes[p] = "active"
        elif p in state and active not in (2, 3):
            assert p not in changes
            changes[p] = "inactive"

    for p, changetype in changes.items():
        if changetype == "active":
            state[p] = "#"
        else:
            del state[p]

    todel = []
    for p in state:
        if ctr[p] == 0:
            todel.append(p)

    # todel = []
    # for p in state:
    #     active = activeneighbors(state, p)
    #     print(f"cycle {6-count} check key {p}: {active}")
    #     if active == 0:
    #         todel.append(p)

    for t in todel:
        print(f"cycle {6-count} deleting {t}")
        del state[t]


    return cycle(state, count-1)



# activeneighbors(input, (0, 1, 0))
# activeneighbors(input, (0, 0, 0))

print(cycle(input, 6))

# n = neighbors((1, 2, 0))
# print(len(n), n)

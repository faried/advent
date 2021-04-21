#!/usr/bin/env python


from copy import deepcopy
from os.path import join


def readinput(fname):
    lines = [line.strip() for line in open(join("resources", fname)).readlines()]
    assert lines[0].find("initial state: ") == 0

    tmp = lines[0].replace("initial state: ", "")
    initial = {}
    for idx, plant in enumerate([p for p in tmp]):
        initial[idx] = plant

    # extend initial to the right and left a bit
    for i in range(len(initial), len(initial)+10):
        initial[i] = "."
    # for i in range(-1, -10, -1):
    #     initial[i] = "."
    initial[-3] = "."
    initial[-2] = "."
    initial[-1] = "."

    changes = {}
    for line in lines[2:]:
        parts = line.split(" => ")
        changes[parts[0]] = parts[1]

    return initial, changes


def printgen(state):
    keys = state.keys()
    minval = min(keys)
    maxval = max(keys)
    ls = []
    for i in range(minval, maxval):
        ls.append(state.get(i, "."))
    print("".join(ls))


def part1(initial, changes):
    printgen(initial)
    # print(changes)

    newstate = {}

    for _ in range(2):
        keys = initial.keys()
        minval = min(keys)
        maxval = max(keys)
        for i in range(minval, 0):
            newstate[i] = initial[i]
        i = 0
        logs = []
        while i < maxval-1:
            # print(i)
            checking = "".join([initial[i-2], initial[i-1], initial[i], initial[i+1], initial[i+2]])
            changed = False
            for change, newpot in changes.items():
                if change == checking:
                    logs.append("at %d matched %s with %s => %s" % (i, checking, change, changes[change]))
                    newstate[i-2] = "."
                    newstate[i-1] = "."
                    newstate[i] = newpot
                    newstate[i+1] = "."
                    newstate[i+2] = "."
                    changed = True
                    logs.append("%d changed %s => %s" % (i, checking, "".join([".", ".", newpot, ".", "."])))
                    # print(i, "changed")
                    break
            if i not in newstate and not changed:
                newstate[i] = initial[i]
            i += 1
        printgen(newstate)
        initial = deepcopy(newstate)

    print("\n".join(logs))



if __name__ == "__main__":
    INITIAL, CHANGES = readinput("test.txt")
    part1(INITIAL, CHANGES)

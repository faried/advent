#!/usr/bin/env python

from collections import defaultdict
from os.path import join
try:
    from string import ascii_uppercase as ucase
except ImportError:
    from string import uppercase as ucase


def deptree(lines):
    """Build a tree of what step depends on what other step(s).

    Test input becomes

    {'A': set(['C']), 'C': set([]), 'B': set(['A']),
     'E': set(['B', 'D', 'F']), 'D': set(['A']),
     'F': set(['C'])}

    A depends on C
    B depends on A
    C depends on nothing (starting point)
    D depends on A
    E depends on B, D, F
    F depends on C
    """

    coll = defaultdict(set)
    for line in lines:
        parts = line.split()
        coll[parts[7]].add(parts[1])
        if parts[1] not in coll:
            coll[parts[1]] = set()

    return dict(coll)


def order(deps):
    """Loop through deps in order.

    Using the test input:

    - find the steps that depends on nothing (just one in the beginning -- C)
    - sort the list of steps to take
    - store C in retls, meaning we've "taken" the step
    - remove C from the deps dictionary
    - loop over other key/value pairs to find steps that depend on C
    - remove C from those values
    - at this point, some other step or steps will depend on nothing
      so loop back and operate on them
    - finally, return all the steps we've taken.
    """

    taken = []

    while deps:
        zerodeps = []
        for step, deplist in deps.items():
            if not deplist:
                zerodeps.append(step)
        zerodeps.sort()

        step = zerodeps.pop(0)
        taken.append(step)
        del deps[step]
        for otherstep, deplist in deps.items():
            if step in deplist:
                deps[otherstep].remove(step)

    return "".join(taken)


def part1(deps):
    return order(deps)


def order2(deps, numworkers):
    retls = []
    workers = [None] * numworkers
    curtime = 0

    zerodeps = []
    for step, deplist in deps.items():
        if not deplist:
            zerodeps.append(step)
        zerodeps.sort()

    while True:
        working = set()
        while zerodeps:
            for idx in range(numworkers):
                if workers[idx]:
                    workers[idx][1] -= 1
            freeworkers = 0
            freeingworkers = []
            for idx, worker in enumerate(workers):
                if not worker:
                    freeworkers += 1
                elif worker[1] == 0:
                    freeingworkers.append(idx)
            for idx in freeingworkers:
                worker = workers[idx]
                step = worker[0]
                del deps[step]
                for otherstep, deplist in deps.items():
                    if step in deplist:
                        deps[otherstep].remove(step)
                zerodeps.remove(step)
                working.remove(step)
                retls.append(step)
                workers[idx] = None
                freeworkers += 1
                more = []
                for step, deplist in deps.items():
                    if not deplist:
                        more.append(step)
                zerodeps.extend(more)
                zerodeps = list(set(zerodeps))
                zerodeps.sort()
            if freeworkers:
                for step in zerodeps:
                    if step not in working:
                        for idx in range(numworkers):
                            if not workers[idx]:
                                workers[idx] = [step, ucase.index(step)+1]
                                working.add(step)
                                break
            curtime += 1

        return curtime-1


def part2(deps):
    return order2(deps, 2)


if __name__ == "__main__":
    INSTRUCTIONS = [instruction for instruction in open(join("resources", "input.txt"))]
    print(part1(deptree(INSTRUCTIONS)))
    print(part2(deptree(INSTRUCTIONS)))

# eof

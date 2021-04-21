#!/usr/bin/env python

from collections import defaultdict
from os.path import join
try:
    from string import ascii_uppercase as ucase
except ImportError:
    from string import uppercase as ucase


def deptree(lines):
    coll = defaultdict(set)
    for line in lines:
        parts = line.split()
        coll[parts[7]].add(parts[1])
        # if we haven't seen coll
        if parts[1] not in coll:
            print("missing part1 %s" % parts[1])
            coll[parts[1]] = set()

    return dict(coll)


def order(deps):
    # find the steps with zero deps.
    # sort the steps
    # operate on them, one by one
    retls = []
    while deps:
        zerodeps = []
        for step, deplist in deps.items():
            if not deplist:
                zerodeps.append(step)
        zerodeps.sort()
        for step in zerodeps[:]:
            retls.append(step)
            del deps[step]
            for otherstep, deplist in deps.items():
                if step in deplist:
                    deps[otherstep].remove(step)
            zerodeps.remove(step)
            break

    return "".join(retls)


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
                                workers[idx] = [step, 60+ucase.index(step)+1]
                                working.add(step)
                                break
            curtime += 1

        return curtime-1


def part2(deps):
    return order2(deps, 5)


if __name__ == "__main__":
    INSTRUCTIONS = [instruction for instruction in open(join("resources", "input.txt"))]
    print(part1(deptree(INSTRUCTIONS)))
    print(part2(deptree(INSTRUCTIONS)))

# eof

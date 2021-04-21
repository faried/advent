#!/usr/bin/env python

from collections import defaultdict
from os.path import join
try:
    from string import ascii_uppercase as ucase
except ImportError:
    from string import uppercase as ucase


def deptree(lines):
    coll = defaultdict(list)
    for line in lines:
        parts = line.split()
        coll[parts[7]].append(parts[1])
        if parts[1] not in coll:
            coll[parts[1]] = []

    return dict(coll)


def order(deps):
    # find the steps with zero deps.
    # sort the steps
    # operate on the first step
    while deps:
        zerodeps = []
        for step, deplist in deps.items():
            if not deplist:
                zerodeps.append(step)
        zerodeps.sort()
        for step in zerodeps[:]:
            del deps[step]
            for otherstep, deplist in deps.items():
                if step in deplist:
                    deps[otherstep].remove(step)
            zerodeps.remove(step)
            yield step
            break


def order1(deps):
    # find the steps with zero deps.
    # sort the steps
    # operate on the first step
    while deps:
        zerodeps = []
        for step, deplist in deps.items():
            if not deplist:
                zerodeps.append(step)
        zerodeps.sort()
        step = zerodeps.pop(0)
        del deps[step]
        for otherstep, deplist in deps.items():
            if step in deplist:
                deps[otherstep].remove(step)
        yield step


def part1(deps):
    return "".join([step for step in order1(deps)])


def order2(deps, numworkers):
    retls = []
    workers = [None] * numworkers
    curtime = 0
    while deps:
        zerodeps = []
        for k, deplist in deps.items():
            if not deplist:
                zerodeps.append(k)
        zerodeps.sort()
        for i in zerodeps[:]:
            inctime = True
            print("zd i %s zd %s" % (i, zerodeps))
            workingon = set([w[0] for w in workers if w])
            print(curtime, workers)
            for widx, worker in enumerate(workers):
                if not worker and i not in workingon:
                    workers[widx] = [i, ucase.index(i)+1]
                    workingon.add(i)
                    print("%d: worker %d has started on %s" % (curtime, widx, i))
                    inctime = False
                    break
                elif worker and worker[1] == 0:
                    print("%d: worker %d is done with %s" % (curtime, widx, worker[0]))
                    retls.append(worker[0])
                    # print("".join(retls))
                    if worker[0] in deps:
                        del deps[worker[0]]
                    for k, deplist in deps.items():
                        if worker[0] in deplist:
                            deps[k].remove(worker[0])
                    workers[widx] = None
                    if worker[0] in zerodeps:
                        zerodeps.remove(worker[0])
                    workingon.remove(worker[0])
                    break
                elif worker:
                    workers[widx][1] -= 1
            if inctime:
                curtime += 1

    return "".join(retls)


def order3(deps, numworkers):
    retls = []
    workers = [None] * numworkers
    curtime = 0
    while deps:
        zerodeps = []
        for k, deplist in deps.items():
            if not deplist:
                zerodeps.append(k)
        zerodeps.sort()
        addedtask = False
        removed = False
        for i in zerodeps[:]:
            inctime = True
            print("zd i %s zd %s" % (i, zerodeps))
            workingon = set([w[0] for w in workers if w])
            print(curtime, workers)
            freeworkers = len([w for w in workers if not w or w[1] == 0])
            print("free %d" % freeworkers)
            if not freeworkers:
                for widx in range(len(workers)):
                    workers[widx][1] -= 1
                curtime += 1
                print("%d inc %s" % (curtime, workers))
                addedtask = False
                break
            for widx, worker in enumerate(workers):
                if not worker and i not in workingon:
                    workers[widx] = [i, ucase.index(i)+1]
                    workingon.add(i)
                    print("%d: worker %d has started on %s" % (curtime, widx, i))
                    inctime = False
                    addedtask = True
                    break
                elif worker and worker[1] == 0:
                    print("%d: worker %d is done with %s" % (curtime, widx, worker[0]))
                    retls.append(worker[0])
                    # print("".join(retls))
                    if worker[0] in deps:
                        del deps[worker[0]]
                    for k, deplist in deps.items():
                        if worker[0] in deplist:
                            deps[k].remove(worker[0])
                    workers[widx] = None
                    if worker[0] in zerodeps:
                        zerodeps.remove(worker[0])
                    workingon.remove(worker[0])
                    inctime = False
                    addedtask = False
                    removed = True
                    break
                elif worker and not addedtask:
                    print("dec %s" % workers[widx])
                    workers[widx][1] -= 1
            if removed:
                break
            if inctime and not addedtask:
                curtime += 1
            else:
                print("no inc")

    return "".join(retls)


def order4(deps, numworkers):
    retls = []
    workers = [None] * numworkers
    curtime = 0
    while deps:
        zerodeps = []
        for step, deplist in deps.items():
            if not deplist:
                zerodeps.append(step)
        zerodeps.sort()
        for step in zerodeps[:]:
            del deps[step]
            for otherstep, deplist in deps.items():
                if step in deplist:
                    deps[otherstep].remove(step)
            retls.append(step)
            zerodeps.remove(step)
            curtime += 1
            break

    print(curtime)
    return "".join(retls)




def part2(deps):
    return order22(deps)


if __name__ == "__main__":
    INSTRUCTIONS = [instruction for instruction in open(join("resources", "test.txt"))]
    # print(part1(deptree(INSTRUCTIONS)))
    print(part2(deptree(INSTRUCTIONS)))

# eof

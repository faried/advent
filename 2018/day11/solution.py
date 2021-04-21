#!/usr/bin/env python


def makegrid(serial):
    row = [None] * 300
    grid = []
    for _ in range(300):
        grid.append(row[:])

    for y in range(300):
        for x in range(300):
            rackid = x+1 + 10
            powerlevel = rackid * (rackid * (y+1) + serial)
            h = (powerlevel / 100) % 10
            less = h - 5
            grid[y][x] = less
            # print(x+1, y+1, less)

    return grid


def part1(serial, size=3, grid=None):
    if not grid:
        grid = makegrid(serial)

    grids = []
    foundy = 0
    foundx = 0
    maxpower = -300 * 300
    for y in range(0, 300-size):
        for x in range(0, 300-size):
            power = 0
            for y_ in range(0, size):
                for x_ in range(0, size):
                    power += grid[y+y_][x+x_]
            # print("ok", x, y, power)
            # print("grid %d,%d power %d" % (x+1, y+1, power))
            grids.append((power, x+1, y+1))
            if power > maxpower:
                foundy = y
                foundx = x
                maxpower = power

    grids.sort(key=lambda g: g[0], reverse=True)
    p, x, y = grids[0]

    return x, y, p


def part2(serial):
    grid = makegrid(serial)

    grids = []

    for gridsize in range(1, 300):
        print(gridsize)
        x, y, p = part1(serial, gridsize, grid)
        grids.append((p, x, y, gridsize))
        grids.sort(key=lambda g: g[0], reverse=True)
        print(grids[0])

    grids.sort(key=lambda g: g[0], reverse=True)
    p, x, y, gs = grids[0]

    return x, y, gs, p



if __name__ == "__main__":
    print(part1(7400))
    print(part2(7400))

#!/usr/bin/env python
#
# Maze generator in 152 lines* of python
# Copyright (c) 2008 David Bau.  All rights reserved.
#
# Can be used as either a command-line tool or as a cgi script
# The arguments are w, h, m, cell, tube, wall, curve, and cross;
# they all take numeric values.

# Now also takes a "solve" argument which, when 1,  will add a page with 
# solution for each page.  
#
# *before solve :-)

import cgitb
cgitb.enable()
import sys
import os
import random
import getopt
import cgi
import user
from reportlab.pdfgen.canvas import Canvas
from StringIO import StringIO
import math, cmath

def main():
  opts = {}
  for k, v in getopt.getopt(sys.argv[1:], 'w:h:m:',
              ['cell=', 'tube=', 'wall=', 'curve=', 'cross=', 'solve='])[0]:
    opts[k.strip('-')] = num(v)
  drawmaze(sys.stdout, **opts)

def cgimain():
  import cgitb; cgitb.enable()
  pdfout = StringIO()
  print >> pdfout, "Content-Type: application/pdf"
  print >> pdfout, "Cache-Control: no-cache"
  print >> pdfout, "Expires: Sat, 01 Jan 2000 00:00:00 GMT"
  print >> pdfout
  opts = {}
  fieldStorage = cgi.FieldStorage()
  for key in fieldStorage.keys():
    opts[key] = num(fieldStorage[key].value)
  drawmaze(pdfout, **opts)
  print >> sys.stdout, pdfout.getvalue()

def drawmaze(file, w = 8.5 * 72, h = 11.0 * 72, m = 36,
             cell = 24, tube = 0.7, wall = 0.3, curve = 1, cross = 1,
             count = 1, solve = 0):
  cellw, cellh = [int((x - 2 * m) / cell) for x in (w, h)]
  mx, my = (w - cellw * cell) / 2.0, (h - cellh * cell) / 2.0    # margins
  if cellw <= 0 or cellh <= 0: raise RuntimeError('Bad maze dimensions')
  c = Canvas(file)
  c.setTitle('Maze')
  c.setSubject('%s by %s %s crossings' %
               (cellw, cellh, ('without', 'with')[cross]))
  c.setAuthor("Dave's Maze Maker")
  c.setPageSize((w, h))
  for n in xrange(count):
    maze = [0] * cellw * cellh
    fillmaze(maze, cellw, cellh, cross)
    maze[0] |= 4
    maze[cellw * cellh - 1] |= 1
    for s in xrange(solve+1):
      for x in xrange(cellw):
        for y in xrange(cellh):
          drawcell(c, maze[x + cellw * y],
                   x * cell + mx, y * cell + my, cell, tube, wall, curve)
      if s==1:
        drawsolution(c, maze, cellw, cellh, cross, cell, wall, mx, my, curve, tube)
      c.showPage()
  c.save()

def rect(p0, p1):
  left = min(p0.real, p1.real)
  right = max(p0.real, p1.real)
  lower = min(p0.imag, p1.imag)
  upper = max(p0.imag, p1.imag)
  return left + 1j*lower, right + 1j*upper 
  
class PathWrap(object):
  def __init__(self, canvas, size, tube, lw, a, mx, my):
    canvas.saveState()
    canvas.setLineWidth(size*tube - lw)
    canvas.setStrokeColorRGB(1, 0, 0)
    canvas.translate(a + mx, a + my)
    self.canvas = canvas
    self.path = canvas.beginPath()
    self.size = size
  
  def __del__(self):
    self.canvas.drawPath(self.path)
    self.canvas.restoreState()
    
  def moveTo(self, p):
    self.path.moveTo(self.size*p.real, self.size*p.imag)
  
  def lineTo(self, p):
    self.path.lineTo(self.size*p.real, self.size*p.imag)
  
  def arcTo(self, p1, p2, startAngle, extent):
    s = self.size
    self.path.arcTo(s*p1.real, s*p1.imag, s*p2.real, s*p2.imag, startAngle, extent)

def drawKnee(pw, p0, pMid, p1, curve):
  pw.moveTo(p0)
  if p0.real==p1.real or p0.imag==p1.imag:
    pw.lineTo(p1)
    return
  if not curve:
    pw.lineTo(pMid); pw.lineTo(p1)
  else:
    pc = p1 - pMid + p0
    pMid1 = pc - (pMid - pc)
    pLowerLeft, pUpperRight = rect(pMid, pMid1)
    start = p0 - pc
    stop = p1 - pc
    startAngle = cmath.log(start).imag / cmath.pi * 180.
    pw.arcTo(pLowerLeft, pUpperRight, startAngle, 90*(-1.j*stop/start).real)
    pw.moveTo(p1)
    
def drawsolution(canvas, maze, cellw, cellh, cross, size, wall, mx, my, curve, tube):
  path = [0]
  solve(path, maze, cellw, cellh, cross)
  a, lw = size * 0.5, size * 0.5 * wall
  pw = PathWrap(canvas, size, tube, lw, a, mx, my)
  last, here, p0 = -1, 0, -1 + 0j
  for next in path[1:] + [cellw*cellh]:
    p1 = here%cellw + 1j*(here/cellw)
    if next == cellw*cellh:
      p2 = cellw + 1j*(cellh-1)
    else:
      p2 = next%cellw + 1j*(next/cellw)
    oneSpace = (p2 - p1)/abs(p2 - p1)
    kneeEnd = p1 + oneSpace*.5
    drawKnee(pw, (p0 + p1)/2., p1, kneeEnd, curve)
    if cross:
      stop = p2-oneSpace*(.5)
      partWay = oneSpace*((1 - tube)/2. - wall/4.)
      while abs(kneeEnd-stop) > 0.01:
        z = kneeEnd
        kneeEnd = kneeEnd + oneSpace
        pw.lineTo(z + partWay)
        pw.moveTo(kneeEnd - partWay)
        pw.lineTo(kneeEnd)
      p1 = p2 - oneSpace
    last, here, p0 = here, next, p1

def tunnel(here, step, maze, w):
  candidate = here + step
  backDir = {1:4, w:8, -1:1, -w:2}[step]
  over = maze[candidate] >> 4
  while over:
    if maze[candidate] & backDir: 
      over = 0
      break
    here = candidate
    candidate = candidate + step
    over = maze[candidate] >> 4
  return candidate
  
def solve(path, maze, w, h, cross):
  done = False
  reachables = [[] for m in maze]
  crumb = [False for m in maze]
  while True:
    if len(path)>1:
      last = path[-2]
    else:
      last = -1
    here = path[-1]
    if here == w*h-1:
      break
    if not crumb[here]:
      reachables[here] = []
      for mask, step in [(1,1), (2,w), (4,-1), (8,-w)]:
        if (maze[here] & mask): 
          candidate = tunnel(here, step, maze, w)
          if candidate != last:
            reachables[here] += [candidate]
      crumb[here] = True
    else:
      if not reachables[here]:
        path.pop()
    if reachables[here]:
      path.append(reachables[here][0])
      reachables[here].pop(0)

def drawcell(canvas, bits, x, y, size, shape, wall, curve):
  a, b, lw = size * 0.5, size * 0.5 * shape, size * 0.5 * wall
  over = (0 != (bits & 16))
  canvas.saveState()
  canvas.setLineWidth(lw)
  canvas.setLineCap(curve and 1 or 2)
  canvas.translate(x + a, y + a)
  gaps = rgaps(bits)
  if gaps:
    canvas.rotate((gaps[0] + 1) * 90)
  for gap in gaps[1:]:
    p = canvas.beginPath()
    p.moveTo(b, -a)
    if gap == 0:
      if curve: p.arcTo(b, b - a - a, a + a - b, -b, 180, -90)
      else: p.lineTo(b, -b); p.lineTo(a, -b)
    elif gap == 1:
      p.lineTo(b, a)
      if over: p.moveTo(a, -b); p.lineTo(b, -b); p.moveTo(a, b); p.lineTo(b, b)
    elif gap == 2:
      if curve: p.arcTo(-b - a - a, -b - a - a, b, b, 0, 90)
      else: p.lineTo(b, b); p.lineTo(-a, b)
    elif gap == 3:
      if curve: p.arcTo(-b, -b, b, b, 0, 180)
      else: p.lineTo(b, b); p.lineTo(-b, b)
      p.lineTo(-b, -a)
    canvas.drawPath(p)
    canvas.rotate((gap + 1) * 90)
  canvas.restoreState()

def rgaps(bits):
  result, count = [], 0
  for bit in xrange(4):
    if not (bits & 1 << bit): count += 1
    else: result.append(count); count = 0
  if result:
    result.append(count + result[0])
  return result

def fillmaze(maze, w, h, over):
  path = random.sample([pos for pos in xrange(w * h) if maze[pos] == 0], 1)
  nextdir = -1
  while path:
    pos = path[-1]
    choices = [d for d in xrange(4) if canbuild(maze, w, h, pos, d, over)]
    if nextdir in choices and random.randint(0, 1) == 0: pass
    elif choices: nextdir = random.sample(choices, 1)[0]
    else: path.pop(); continue
    path.append(dobuild(maze, w, h, pos, nextdir, over))

def atedge(w, h, pos, dir):
  if dir == 0: return pos % w == w - 1
  if dir == 1: return pos >= w * (h - 1)
  if dir == 2: return pos % w == 0
  if dir == 3: return pos < w

def cancross(maze, pos, dir):
  return maze[pos] & 15 == (10, 5, 10, 5)[dir]

def canbuild(maze, w, h, pos, dir, over):
  if dir < 0: return False
  offset = (1, w, -1, -w)[dir]
  while not atedge(w, h, pos, dir):
    pos += offset
    if maze[pos] == 0: return True
    if not over or not cancross(maze, pos, dir): return False
  return False

def dobuild(maze, w, h, pos, d, over):
  offset = (1, w, -1, -w)[d]
  maze[pos] |= 1 << d
  pos += offset
  while maze[pos] != 0:
    maze[pos] ^= random.choice((0, 15))
    maze[pos] |= 16
    pos += offset
  maze[pos] |= 1 << (d ^ 2)
  return pos

def num(s):
  if s.find('.') < 0: return int(s)
  else: return float(s)

if __name__ == "__main__":
  if os.getenv('GATEWAY_INTERFACE') is not None: sys.exit(cgimain())
  else: sys.exit(main())



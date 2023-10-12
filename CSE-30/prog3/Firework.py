import random
import pygame
from OpenGL.GL import *
from OpenGL.GLU import *
from pygame.locals import *

clocktick = 150
#the tick rate for clock

class Particle: #a single particle 3-d coordinates, color, if it has a comet trail, and lifetime parameters
    def __init__(self, x=0, y=0, z=0, color=(0, 0, 0, 1), trail=0, time=0):
        self.x = x
        self.y = y
        self.z = z
        self.color = color
        self.exploded = False
        self.velocity = [random.uniform(-.01, .01) * 3, random.uniform(-.01, .01) * 5, random.uniform(-.01, .01) * 3, ]
        self.tick = 0 #used to compare with lifetime, when tick gets +1 when update() is called, when tick > lifetime then self.expire = True
        self.y0 = 0 #location of the particle when it exploded; used in projectile motion formula
        self.trail = 1 #standard comet trail length
        self.temp = trail #temp holder for comet trail
        self.opacitychange = 1 / trail #used to calculate how much the opacity changes from 1 to barely opaque
        self.traillist = [] #listto hold all the points of a particle and its comet trail
        self.time = time #lifetime value
        self.expire = False #stops calculations when the particle reaches its lifetime or hits the ground
    def update(self):
        if self.expire == False:
            if self.time < self.tick or self.y < 0:
                self.color = (0, 0, 0, 0)
                self.expire = True
                self.traillist.clear()
            if self.y > 10 and self.exploded == False: #standard explosion height for a firework
                self.exploded = True
                self.trail = self.temp
                self.y0 = self.y
            if self.exploded:
                self.tick += 1
                self.x += self.velocity[0]
                self.y = self.y0 + self.velocity[1] * (self.tick / clocktick * 100) - 0.5 * 9.8 * (
                            self.tick / clocktick) ** 2 #projectile motion formula with some changes relative to the clocktime
                self.z += self.velocity[2]
            else:
                self.y += 0.1

            if len(self.traillist) <= self.trail: #used to modify the comet trail with the last positions
                self.traillist.append((self.x, self.y, self.z))
            else:
                self.traillist.append((self.x, self.y, self.z))
                self.traillist.pop(0)


    def draw(self):
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
        glEnable(GL_BLEND)
        glLineWidth(3.0)
        glBegin(GL_POINTS)
        if not self.exploded:
            temp = self.color[3]
        else:
            temp = 0
        for i in range(len(self.traillist)): #draws the particle
            glColor4fv((self.color[0], self.color[1], self.color[2], temp))
            glVertex3fv(self.traillist[i])
            temp += self.opacitychange
        glEnd()

class Fireworks(Particle): #(x y z starting coords, amount of particles, color, comet trail, lifetime, standard deviation, type of firework, whether particles should have random colors)
    def __init__(self, x1, y1, z1, n, color, trail, lifetime, stddev, type=0, randomcol=0):
        self.x1 = x1
        self.y1 = y1
        self.z1 = z1
        self.n = n
        self.color = color
        self.bundle = []
        self.bundle2 = []
        self.lifetime = lifetime * clocktick #sets lifetime relative to clock ticks
        self.stddev = stddev
        self.type = type #used to see whether it's a single explosion or double explosion firework
        self.firstExplode = False
        self.countdown = 0
        if self.type == 0: #random colors only works for single explosion fireworks atm
            for i in range(n):
                if randomcol != 0:
                    self.bundle.append(Particle(x1, y1, z1, (random.random(), random.random(), random.random(), 1), trail,  round(random.gauss(self.lifetime, self.stddev))))
                else:
                    self.bundle.append(Particle(x1, y1, z1, color, trail,  round(random.gauss(self.lifetime, self.stddev))))
        elif self.type == 1: #double explosion -> bundle1 gets fireworks and bundle2 appended with particles
            for i in range(n):
                self.bundle.append(Fireworks(x1, 10, z1, round(n/2), color, trail, lifetime, stddev))
                self.bundle2.append(Particle(x1, y1, z1, color, trail, round(random.gauss(self.lifetime,self.stddev))))



    def render(self):
        if self.type == 0:
            for item in self.bundle:
                item.update()
                item.draw()
        elif self.type == 1: #only launches fireworks from bundle1 if bundle2 has exploded aleady
            for item in self.bundle:
                for part in item.bundle:
                    if self.firstExplode == True:
                        self.countdown += 1
                        if self.countdown > clocktick * 10 * self.n/2:
                            part.update()
                            part.draw()
            for test in self.bundle2:
                test.update()
                test.draw()
                if test.exploded == True:
                    self.firstExplode = True

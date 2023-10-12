# -*- coding: utf-8 -*-
import random
import pygame
from OpenGL.GL import *
from OpenGL.GLU import *
from pygame.locals import *
from Firework import *
clocktick = 150
#the tick rate for clock

def terrain():
    ''' Draws a simple square as the terrain '''
    glBegin(GL_QUADS)
    glColor4fv((0, 0, 1, 1))  # Colors are now: RGBA, A = alpha for opacity
    glVertex3fv((10, 0, 10))  # These are the xyz coords of 4 corners of flat terrain.
    glVertex3fv((-10, 0, 10))  # If you want to be fancy, you can replace this method
    glVertex3fv((-10, 0, -10))  # to draw the terrain from your prog1 instead.
    glVertex3fv((10, 0, -10))
    glEnd()
def main():
    pygame.init()

    # Set up the screen
    display = (1200, 800)
    pygame.display.set_mode(display, DOUBLEBUF | OPENGL)
    pygame.display.set_caption("Firework Simulation")
    glEnable(GL_DEPTH_TEST)

    gluPerspective(45, (display[0] / display[1]), 0.1, 50.0)
    glTranslatef(0, -5, -25)
    # glRotatef(10, 2, 1, 0)

    play = True
    sim_time = 0

    # A clock object for keeping track of fps
    clock = pygame.time.Clock()

    while play:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                quit()

            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_LEFT:
                    glRotatef(-10, 0, 1, 0)
                if event.key == pygame.K_RIGHT:
                    glRotatef(10, 0, 1, 0)

                if event.key == pygame.K_UP:
                    glRotatef(-10, 1, 0, 0)
                if event.key == pygame.K_DOWN:
                    glRotatef(10, 1, 0, 0)

            if event.type == pygame.MOUSEBUTTONDOWN:
                if event.button == 4:
                    glTranslatef(0, 0, 1.0)

                if event.button == 5:
                    glTranslatef(0, 0, -1.0)

        glRotatef(0.10, 0, 1, 0)
        # glTranslatef(0, 0.1, 0)
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

        terrain()

        if 0 < sim_time <= 1000:
            firework1.render()
        if 500 < sim_time <= 1500:
            firework2.render()
            firework3.render()
        if 1000 < sim_time <= 1500:
            firework4.render()
            firework5.render()
        if 1500 < sim_time:
            sim_time = 0

        if sim_time == 0:
            firework1 = Fireworks(0, 0, 0, 12, (random.random(), random.random(), random.random(), 1), 10, 1, 30, 1)
            firework2 = Fireworks(-5, 0, 5, 100, (1, 0, 0, 1), 5, .5, 10, 0, 1)
            firework3 = Fireworks(-5, 0, -5, 100, (random.random(), random.random(), random.random(), 1), 5, 2, 100)
            firework4 = Fireworks(5, 0, -5, 100, (0, 1, 0, 1), 5, 1, 3)
            firework5 = Fireworks(5, 0, 5, 100, (random.random(), random.random(), random.random(), 1), 5, 1, 3)

        pygame.display.flip()
        sim_time += 1
        clock.tick(clocktick)

    pygame.quit()


if __name__ == "__main__":
    main()

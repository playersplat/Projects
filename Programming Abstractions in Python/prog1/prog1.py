# COPY THIS CODE TO CREATE A .py FILE TO RUN or COPY TO A JUPYTER (NOT COLAB) NOTEBOOK AND RUN
# -*- coding: utf-8 -*-
"""
Created on Thu Apr 15 15:04:11 2020
CSE 30 Spring 2020 Program 1 helper code
@author: Fahim
"""
import math
import turtle
import random
# Note: For this example, we are using hardcoded points/vertices to test the functionalities of the viewer and animation.
# For Program 1, you need to replace the code between the tags # BEGIN and # END with your code.
# Your code should generate the VERTICES and TRIANGLES using your recursive "midpoint_displacement" function.
# This setup is optimized for points values generated in the range -1.00 to 1.00.
# You may need the adjust the value of FOV to generate points with higher ranges.
# BEGIN
# =====================================================================
def midpoint_displacement(p1, p2, p3, level, roughness,
vertical_displacement=None): #coun
    if level == 1:
        global count #used to append the 3 verts needed to draw a triangle into TRIANGLES
        global TRIANGLES
        global VERTICES
        VERTICES.append((p1[0], p1[1], p1[2]))
        VERTICES.append((p2[0], p2[1], p2[2]))
        VERTICES.append((p3[0], p3[1], p3[2]))
        TRIANGLES.append((count, count + 1, count + 2))
        count += 3
    else:
        if vertical_displacement is None: # case where no vertical_displacement is placed into the function
            vertical_displacement = .5 * 2 ** (-roughness)
        else:
            vertical_displacement *= 2 ** (-roughness)
        level = level - 1
        mx1 = (p1[0] + p2[0]) / 2 #midpoint of the x between two points
        my1 = (p1[1] + p2[1]) / 2 #midpoint of the y between two points
        mx2 = (p2[0] + p3[0]) / 2
        my2 = (p2[1] + p3[1]) / 2
        mx3 = (p3[0] + p1[0]) / 2
        my3 = (p3[1] + p1[1]) / 2
        ranz1 = random.random() * vertical_displacement #random float bet 0 and 1 and gets multiplied by the vertical_displacement
        ranz2 = random.random() * vertical_displacement
        ranz3 = random.random() * vertical_displacement
        #loop through vertices to see if midpoint is already equal to one of the verts
        #if one of the verts is already equal then set the z component of that vert to the ranz so there would be no holes
        for i in VERTICES:
            if mx1 == i[0] and my1 == i[1]:
                ranz1 = i[2]
            elif mx2 == i[0] and my2 == i[1]:
                ranz2 = i[2]
            elif mx3 == i[0] and my3 == i[1]:
                ranz3 = i[2]
        tup1 = (mx1, my1, ranz1)
        tup2 = (mx2, my2, ranz2)
        tup3 = (mx3, my3, ranz3)
        if (level % 2 == 0):
            vertical_displacement *= 2 ** (-roughness)
        else:
            vertical_displacement += .15
        midpoint_displacement(tup1, tup2, tup3, level, roughness,
        vertical_displacement)
        midpoint_displacement(tup1, p2, tup2, level, roughness,
        vertical_displacement)
        midpoint_displacement(tup3, p1, tup1, level, roughness,
        vertical_displacement)
        midpoint_displacement(tup2, p3, tup3, level, roughness,
        vertical_displacement)
#displacement_reduction = 1/(2 ** decay) where decay == roughness
# p1[0] = x1
# p1[1] = y1
# p2[0] = x2
# p2[1] = y2
# p3[0] = x3
# p3[1] = y3
# main code follows:
pt1 = ( 1, 0, 0)
pt2 = ( 0, 1, 0)
pt3 = (-1, 0, 0)
color = (12, 50, 231)
VERTICES = []
TRIANGLES = []
count = 0
midpoint_displacement(pt1, pt2, pt3, 5, .5)
# =====================================================================
# END
def transform(x, y, z, angle, tilt):
    #Animation control (around y-axis). If considered as a view of earth from space, it's moving over the equator.
    s, c = math.sin(angle), math.cos(angle)
    x, z = x * c - z * s, x * s + z * c
    #Camera tilt (around x-axis). If considered as a view of earth from space, the tilt angle is measured from the equator.
    s, c = math.sin(tilt), math.cos(tilt)
    y, z = y * c - z * s, y * s + z * c
    # Setting up View Parameters
    z += 5 #Fixed Distance from top
    FOV = 1000 #Fixed Field of view
    f = FOV / z
    sx, sy = x * f, y * f
    return sx, sy
def main():
    # Create terrain using turtle
    terrain = turtle.Turtle()
    terrain.pencolor("blue")
    terrain.pensize(1)
    # Turn off move time for instant drawing
    turtle.tracer(0, 0)
    terrain.up()
    angle = 20
    while True:
    # Clear the screen
        terrain.clear()
        # Transform the terrain
        VERT2D = []
        for vert3D in VERTICES:
            x, y, z = vert3D
            sx, sy = transform(x, y, z, angle, 0.5)
            VERT2D.append((sx, sy))
        # Draw the terrain
        for triangle in TRIANGLES:
            points = []
            points.append(VERT2D[triangle[0]])
            points.append(VERT2D[triangle[1]])
            points.append(VERT2D[triangle[2]])
            # Draw the trangle
            terrain.goto(points[0][0], points[0][1])
            terrain.down()
            terrain.goto(points[1][0], points[1][1])
            terrain.goto(points[2][0], points[2][1])
            terrain.goto(points[0][0], points[0][1])
            terrain.up()
            # Update screen
        turtle.update()
        # Control the speed of animation
        angle += 0.01
if __name__ == "__main__":
    main()
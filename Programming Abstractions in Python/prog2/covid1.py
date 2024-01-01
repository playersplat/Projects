import pygame
import random
import numpy as np
from dot import Dot
import matplotlib
import matplotlib.pyplot as plt

pygame.init()
myfont = pygame.font.SysFont("monospace", 20)
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
RED = (255, 0, 0)
BLUE = (0, 0, 255)
GREEN = (0, 255, 0)
ORANGE = (255, 165, 0)
pop = 100
size = (700, 500)
screen = pygame.display.set_mode(size)
pygame.display.set_caption("Scenario 1")
untilExit = True
tick = pygame.time.Clock()
people = pygame.sprite.Group() #used to update the dots
peopleList = [] #list of dots
daycount = 0 #frame counter
days = 0 #used for the chart
for i in range(0, pop): #parameters for the type of dots for Scenario 1
    if i == 94:
        temp = Dot()
        temp.state = ORANGE
        peopleList.append(temp)
        people.add(temp)
    elif i > 94:
        temp = Dot()
        temp.state = GREEN
        peopleList.append(temp)
        people.add(temp)
    else:
        temp = Dot()
        peopleList.append(temp)
        people.add(temp)

j = 0
while j < len(peopleList): #while loop that goes through the dot's location and compares it with other dots
    h = 0
    while h < len(peopleList): #if there is a collision already then it randomizes that dot's location and restarts the loop
        if h != j:
            while peopleList[j].collisionDetection(peopleList[h]):
                peopleList[h].home = [random.randint(0, 500), random.randint(0, 500)]
                temp = list.copy(peopleList[h].home)
                peopleList[h].rect.x = temp[0]
                peopleList[h].rect.y = temp[1]
                j = 0
                h = 0
                break
        h += 1
    j += 1
healthy = [94]
asympto = [1]
sick = [0]
immune = [5]
dead = [0]
d = ['0']

#Code in covid2.py and covid3.py are the same as this code
while untilExit:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            print("Close")
            untilExit = False
    #detect collision function
    for i in range(0, len(peopleList)): #goes through each dot location and compares it with another dot
        for j in range(0, len(peopleList)): #uses pygame.sprite.collide_circle to see if a dot collided
            if i is not j:
                collide = peopleList[i].collisionDetection(peopleList[j])
                if collide == 1: #if the collision is near six feet it changes the state of the dot
                    peopleList[i].changeState(peopleList[j])
                    if peopleList[i].collided == False and peopleList[j].collided == False: #enables the collision counter
                        peopleList[i].collided = True
                        peopleList[j].collided = True
                        coin = random.randint(0, 1)
                        peopleList[i].changeState(peopleList[j])
                        if coin == 0 and peopleList[j].SIP == False and peopleList[j].Moving == True: #coinflip to see whether one dot stops or the other stops
                            peopleList[i].Moving = False
                            peopleList[j].Moving = True
                        elif coin == 1 and peopleList[i].SIP == False and peopleList[i].Moving == True:
                            peopleList[i].Moving = True
                            peopleList[j].Moving = False
                        temp1 = peopleList[i].getNormVector()
                        temp2 = peopleList[j].getNormVector()
                        x1 = round(temp1[0])
                        y1 = round(temp1[1])
                        x2 = round(temp2[0])
                        y2 = round(temp2[1])
                        if (x1 == -x2 and y1 == -y2) or (peopleList[i].SIP == True or peopleList[j].SIP == True) or (
                                peopleList[i].SIP == False or peopleList[j].SIP == False):#compares the norm vector with the other norm vector and changes its course of movement depending on whether the vectors are bound to collide
                            peopleList[i].vectorChoice = 0
                            peopleList[j].vectorChoice = 0
                        elif (x1 == -y2 and y1 == x2) or (x1 == y2 and y1 == -x2):
                            peopleList[i].vectorChoice = -1
                            peopleList[j].vectorChoice = -1
                            peopleList[j].Moving = True
                            peopleList[i].Moving = True
                        elif x1 is not x2 and y1 is not y2:
                            peopleList[i].vectorChoice = -1
                            peopleList[j].vectorChoice = -1
                        elif (x1 == x2 and y1 is not y2) or (y1 == y2 and x1 is not x2):
                            peopleList[i].vectorChoice = -1
                            peopleList[j].vectorChoice = -1
    H, A, S, I, D = 0, 0, 0, 0, 0 #displays the values on the screen during the simulation
    for i in range(0, len(peopleList)):
        temp = peopleList[i].state
        if temp == BLUE:
            H += 1
        elif temp == ORANGE:
            A += 1
        elif temp == RED:
            S += 1
        elif temp == GREEN:
            I += 1
        elif temp == BLACK:
            D += 1

    screen.fill(WHITE)
    people.draw(screen)
    text1 = myfont.render("Days: "+str(int(daycount/20)), 3, BLACK) #pygame rendering text onto the screen
    text2 = myfont.render("Healthy: "+str(H), 3, BLUE)
    text3 = myfont.render("Asympto: "+str(A), 3, ORANGE)
    text4 = myfont.render("Sick: "+str(S), 3, RED)
    text5 = myfont.render("Immune: "+str(I), 3, GREEN)
    text6 = myfont.render("Deceased: "+str(D), 3, BLACK)
    screen.blit(text1, (510, 50)) #position for it to render
    screen.blit(text2, (510, 100))
    screen.blit(text3, (510, 150))
    screen.blit(text4, (510, 200))
    screen.blit(text5, (510, 250))
    screen.blit(text6, (510, 300))
    pygame.draw.line(screen, BLACK, (500, 0), (500, 500), 2) #simple line for visual A S C E T H I C S
    people.update() #calls the update function for all the dots
    daycount += 1
    pygame.display.flip()
    tick.tick(60)
    if daycount % 20 == 0: #20 frames equal a day -> used to capture the amount of dots in each role - healthy, sick, etc.
        healthy.append(H)
        asympto.append(A)
        sick.append(S)
        immune.append(I)
        dead.append(D)
        days += 1
        d.append(str(days))
        if days == 70: #leaves the simulation once 70 days past
            untilExit = False

pygame.quit()
5
set=[tuple(d), tuple(healthy), tuple(asympto), tuple(sick), tuple(immune), tuple(dead)] #set of all the needed variables
set1 = np.array(set[1]) #healthy
set2 = np.array(set[2]) #asymptomatic
set3 = np.array(set[3]) #sick
set4 = np.array(set[4]) #immune
set5 = np.array(set[5]) #dead

header = ['Healthy', 'Asympto', 'Sick', 'Immune', 'Deceased'] #header for the chart

ind = np.arange(len(set[0]))
width = 0.4

p1 = plt.bar(ind, set1, width, color='b')
p2 = plt.bar(ind, set2, width, bottom=set1, color='#fd8311')
p3 = plt.bar(ind, set3, width, bottom=set1+set2, color='r')
p4 = plt.bar(ind, set4, width, bottom=set1+set2+set3, color='g')
p5 = plt.bar(ind, set5, width, bottom=set1+set2+set3+set4, color='k')

plt.title('Scenario 1')
plt.xticks(np.arange(0, 71, 5))
plt.yticks(np.arange(0, 101, 10))
plt.xlabel('Days')
plt.ylabel('Population')
plt.legend((p1[0], p2[0], p3[0], p4[0], p5[0]), (header[0], header[1], header[2], header[3], header[4]), fontsize=12, fancybox=True)
plt.show()
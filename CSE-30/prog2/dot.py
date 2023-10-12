import pygame
import random
import math

BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
RED = (255, 0, 0)
BLUE = (0, 0, 255)
GREEN = (0, 255, 0)
ORANGE = (255, 165, 0)
size = (500, 500)
screen = pygame.display.set_mode(size)

class Dot(pygame.sprite.Sprite):
    def __init__(self, state=None, width=None, height=None, home=None, target=None):
        super().__init__()
        if state is None:
            self.state = BLUE
        else:
            self.state = state
        if width is None:
            self.width = 5 #default ball size
        else:
            self.width = width
        if height is None:
            self.height = 5
        else:
            self.height = height
        if home is None:
            self.home = [random.randint(0, size[0]), random.randint(0, size[1])]
        else:
            self.home = home
        if target is None:
            self.target = [random.randint(0, size[0]), random.randint(0, size[1])]
        else:
            self.target = target
        self.image = pygame.Surface([self.width, self.height])
        self.image.fill(BLACK)
        self.image.set_colorkey(BLACK)


        self.rect = self.image.get_rect()
        self.rect.x = self.home[0]
        self.rect.y = self.home[1]
        self.collided = False
        self.Moving = True
        self.SIP = False
        self.SD6 = False
        self.collisioncount = 0 #counter to reset self.collided
        self.vectorChoice = -1 #type of movement the dot would do
        self.movecount = 0 #similar to collisioncount but for self.Moving
        self.sickmeter = 0 #counter that changes the self.state of the dot according the parameters of the PA

    def update(self):
        if self.SIP == False and self.state != BLACK:  #doesn't move if dot dead or sick
            normvector = self.getNormVector() #gets the vector of the dot and normalizes it
            if self.vectorChoice == -1 and self.Moving == True: #default movement ball tries to move in a straight line to its target
                self.rect.x += round(normvector[0])
                self.rect.y += round(normvector[1])
            elif self.vectorChoice == 0 and self.Moving == True: #second choice, the ball move orthogonally - used for collision avoidance if there is a static dot blocking the ball
                self.rect.x += round(normvector[1])
                self.rect.y += round(-normvector[0])
            if self.rect.x == self.target[0] and self.rect.y == self.target[1]: #swaps the target location when the ball reaches it to its home
                self.target, self.home = list.copy(self.home), list.copy(self.target)
        if self.collided == True: #counter adder for collisioncount
            self.collisioncount += 1
        if self.Moving == False and self.SIP == False: #when the ball stops moving
            self.movecount += 1
        if self.movecount > 15: #when the ball stops moving for more than 15 frames
            self.movecount = 0
            self.Moving = True
        if self.collisioncount > 1: #per frame and resets the vector choice
            self.collisioncount = 0
            self.collided = False
            self.vectorChoice = -1

        if self.state == ORANGE or self.state == RED: #state changes depending on the time if was infected
            self.sickmeter += 1
            if self.sickmeter == (5 * 20): #five days in 50/50 on whether it stays asymptomatic or sick
                if random.randint(0, 100) < 50:
                    self.state = RED
                    self.SIP = True
            elif self.sickmeter == (15 * 20): #15 days in the ball gets cured or dies
                if random.randint(0, 100) < 98:
                    self.state = GREEN
                    self.SIP = False
                else:
                    self.state = BLACK

        if self.SD6 == True: #draws a protective circle around the ball, the attribute gets used again on collisionDetection
            pygame.draw.circle(screen, BLACK, (self.rect.x, self.rect.y), self.height * 3, 1)
        pygame.draw.circle(screen, self.state,  (self.rect.x, self.rect.y), self.height)

    def getNormVector(self): #normalizes the vector
        vector = (self.target[0] - self.rect.x, self.target[1] - self.rect.y)
        mag = math.sqrt(vector[0] * vector[0] + vector[1] * vector[1])
        normvector = (0, 0)
        if mag != 0:
            normvector = (vector[0]/mag, vector[1]/mag)
        return normvector

    def collisionDetection(self, ball): #Two types of collision detection, one if it's nearby another dot ( 6 feet or so) and the other is with SD6 in effect
        if self.state == BLACK or ball.state == BLACK:
            return False
        dist = math.sqrt(math.pow(ball.rect.x - self.rect.x, 2) + math.pow(ball.rect.y - self.rect.y, 2))
        if dist < self.width + 8:
            return 1
        elif dist < self.width * 3 + 8 and self.SD6 == True:
            return 2
        else:
            return False

    def changeState(self, ball): #used when pygame.collide.circle gets called and there is a collision
        if self.state == BLUE and (ball.state == RED or ball.state == ORANGE):
            coinflip = random.randint(0, 100)
            if coinflip >= 20:
                self.state = ORANGE
                self.sickmeter = 0
            else:
                self.state = BLUE
        if ball.state == BLUE and (self.state == RED or self.state == ORANGE):
            coinflip = random.randint(0, 100)
            if coinflip <= 80:
                ball.state = ORANGE
                ball.sickmeter = 0
            else:
                ball.state = BLUE

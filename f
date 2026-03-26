import pygame
import cv2
import random 
fist = cv2.CascadeClassifier('/Users/chippedtile/Downloads/fist.xml')
palm = cv2.CascadeClassifier('/Users/chippedtile/Downloads/palm.xml')
gesture = 0
front = cv2.VideoCapture(0) # allows user to choose which webcam is being used
back = cv2.VideoCapture(1) 
capture = front # makes webcam 0 the default
pygame.init()
cv2.namedWindow("Webcam")
clock = pygame.time.Clock()
fps = 60
bottompanel = 300
screen_width = 1200
screen_height = 500 + bottompanel
def drawpanel():
    screen.blit(panel_img, (0, screen_height - bottompanel))
    drawtext (f'{"guy"} HP: {man.hp}', font, (0, 0, 0), 100, screen_height - bottompanel + 20)
    drawtext (f'{"villain"} HP: {evil.hp}', font, (0, 0, 0), 600, screen_height - bottompanel + 20)

screen = pygame.display.set_mode((screen_width, screen_height))
pygame.display.set_caption('a generic rpg')

#define game veriables 
current_man = 1
total_man = 2
action_cooldown = 0
action_wait_time = 90
game_over = 0

font = pygame.font.SysFont('Comic Sans', 26)
#load images  
#background images
background_img = pygame.image.load('/Users/chippedtile/Downloads/windows xp.jpeg').convert_alpha()
#panel image
panel_img = pygame.image.load('/Users/chippedtile/Downloads/pngtree-textured-crumpled-paper-background-with-copy-space-isolated-on-a-white-picture-image_13468466.jpg.png').convert_alpha()

def drawbg():
     screen.blit(background_img, (0, 0))
def drawtext(text, font, textcol, x, y):
    txtimg = font.render(text, True, textcol)
    screen.blit(txtimg, (x, y))

#mc stats 
class guy():
    def __init__(self, x, y, name, max_hp, strength, defense):
        self.name = guy
        self.max_hp = max_hp
        self.hp = max_hp
        self.strangth = strength
        self.defense = defense
        self.alive = True 
        guyimg = pygame.image.load(f'/Users/chippedtile/Downloads/white guy.webp')
        self.image = pygame.transform.scale(guyimg, (guyimg.get_width() * 0.4, guyimg.get_height() * 0.4))
        self.rect = self.image.get_rect()
        self.rect.center = (x, y)

    def attack(self, target):
        #deal danger 
        rand = random.randint(-6, 8)
        damage = 12 + rand
        target.hp -= damage

    def draw(self):
         screen.blit(self.image, self.rect)
man = guy(200, 320, 'man', 50, 10, 10)

class healthbar():
    def __init__(self, x, y, hp, max_hp):
        self.x = x
        self.y = y
        self.hp = hp
        self.max_hp = max_hp

    def draw (self, hp):
        self.hp = hp
        ratio = self.hp / self.max_hp
        pygame.draw.rect(screen, (255, 0, 0), (self.x, self.y, 150, 20))
        pygame.draw.rect(screen, (0, 255, 0), (self.x, self.y, 150 * ratio, 20))



class villian():
    def __init__(self, x, y, name, max_hp, strength, defense):
        self.name = name
        self.max_hp = max_hp
        self.hp = max_hp
        self.strangth = strength
        self.defense = defense
        self.alive = True 
        villianimg = pygame.image.load(f'/Users/chippedtile/Downloads/evil villian guy.jpeg')
        self.image = pygame.transform.scale(villianimg, (villianimg.get_width() * 0.4, villianimg.get_height() * 0.4))
        self.rect = self.image.get_rect()
        self.rect.center = (x, y)
    def draw(self):
         screen.blit(self.image, self.rect)
    def attack(self, target):
        #deal danger 
        rand = random.randint(-5, 5)
        damage = 10 + rand
        target.hp -= damage

evil = villian(1000, 320, 'villian', 50, 10, 10)
screen = pygame.display.set_mode ((screen_width, screen_height))

man_health_bar = healthbar (100, screen_height - bottompanel + 70, man.hp, man.max_hp)
evil_health_bar = healthbar (600, screen_height - bottompanel + 70, evil.hp, evil.max_hp)

class title():
    def __init__(self, x, y):
        titleimg = pygame.image.load(f'/Users/chippedtile/Downloads/a generic rpg update.png')
        self.image = pygame.transform.scale(titleimg, (titleimg.get_width() * 0.8, titleimg.get_height() * 0.8))
        self.rect = self.image.get_rect()
        self.rect.center = (x, y)
    def draw(self):
         screen.blit(self.image, self.rect)

titlecard = title(600, 150)
pygame.display.set_caption('a generic rpg')
showtitle = True
run = True

while run is True:
        clock.tick(fps)
        drawbg()
        drawpanel()
        man_health_bar.draw(man.hp)
        evil_health_bar.draw(evil.hp)
        man.draw()
        evil.draw()
        pygame.display.update()
        ret, frame = capture.read() # frame will get the next frame in camera, ret checks if true
        if ret:
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY) # converts BGR, which cv2 reads in to grayscale
            fisty = fist.detectMultiScale(gray, 1.3, 6)
            palmy = palm.detectMultiScale(gray, 1.3, 6)
            for (x1, y1, w1, h1) in fisty:
                cv2.rectangle(frame, (x1, y1), (x1+w1, y1+h1), (255, 0, 0), 5) # creates rectangle around detected object (fist), makes colour in accordance to bgr, pixel thickness (5)
                gesture = 1
                for (x1, y1, w1, h1) in palmy:
                    cv2.rectangle(frame, (x1, y1), (x1+w1, y1+h1), (0, 255, 0), 5)
                    gesture = 3
            for (x1, y1, w1, h1) in palmy:
                cv2.rectangle(frame, (x1, y1), (x1+w1, y1+h1), (0, 255, 0), 5)
                gesture = 2
                for (x1, y1, w1, h1) in fisty:
                    cv2.rectangle(frame, (x1, y1), (x1+w1, y1+h1), (0, 255, 0), 5)
                    gesture = 3
            cv2.imshow("Webcam",frame)
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                run = False
        key = cv2.waitKey(1) # checks if user presses a key
        if key == ord("b"):
            capture = back # changes cam to webcam 1
        elif key == ord("f"):
            capture = front # changes cam to webcam 0
        #player action
        if current_man > total_man:
            current_man = 1
        if man.hp <= 0:
            man.hp = 0
            man.alive = False
        if evil.hp <= 0:
            evil.hp = 0
            evil.alive = False

        if game_over == 0:
            if man.alive == True:
                if current_man ==1:
                    action_cooldown +=1
                    if action_cooldown >= action_wait_time:
                        #look for player action
                        #attack
                        if gesture == 1:
                            man.attack(evil)
                            current_man +=1  
                            action_cooldown  = 2
                        if gesture == 2:
                            current_man += 1
                            action_cooldown = 2
                            man.hp += 10
            else:
                game_over = -1 

            #enemy action 
            if current_man == 2:
                if evil.alive == True:
                    action_cooldown += 1
                    if action_cooldown >= action_wait_time:
                        evil.attack(man)
                        current_man += 1
                        action_cooldown =0
                else:
                    game_over = 1


cv2.destroyAllWindows()
pygame.quit

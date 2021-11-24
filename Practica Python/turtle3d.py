from vpython import *
from math import *

class Turtle3D:

    def __init__(self):

        self.bola = sphere(pos=vector(0, 0, 0), radius=0.2, color=color.red, make_trail=False)  # inicializamos nuestro objeto principal
        self.alpha = 0  # variable para controlar el angulo horizontal
        self.beta = 0  # variable para controlar el angulo vertical

        self.pintar = True  # variable para controlar cuando queremos dejar el rastro de cilindros
        self.color = vector(1, 1, 1)  # variable que indica el color del cilindro que vamos a pintar

    def initProg(self):

        scene.height = scene.width = 1000  # En esta función buscamos inicializar la escena. Crearemos un escena con tres paredes azules
        scene.autocenter = True
        scene.caption = """\nTo rotate "camera", drag with right button or Ctrl-drag.\nTo zoom, drag with middle button or Alt/Option depressed, or use scroll wheel.\n  On a two-button mouse, middle is left + right.\nTo pan left/right and up/down, Shift-drag.\nTouch screen: pinch/extend to zoom, swipe or two-finger rotate.\n"""

        wallL = box(pos=vector(-6, 0, 0), size=vector(0.2, 12, 12), color=color.blue)
        wallR = box(pos=vector(6, 0, 0), size=vector(0.2, 12, 12), color=color.blue)
        wallBack = box(pos=vector(0, 0, -6), size=vector(12, 12, 0.2), color=color.blue)

    def esperar(self):  # Funcion que provoca un delay en la ejecución del programa
        sleep(0.5)

    def hideRastro(self):  # Cambia el valor de pintar para que no muestre el rastro
        self.pintar = False

    def showRastro(self):   # Cambia el valor de pintar para que muestre el rastro
        self.pintar = True

    def backward(self, mov):    # Funcion que calculo la nueva posicion de las bolas y el cilindro a pintar.

        posX = self.bola.pos.x  # Guaradamos las coordenadas actuales de la bola principal antes de moverla
        posY = self.bola.pos.y
        posZ = self.bola.pos.z
        x = cos(radians(self.alpha)) * cos(radians(self.beta))
        z = sin(radians(self.alpha)) * cos(radians(self.beta))
        y = sin(radians(self.beta))

        if self.pintar == True:  # Solo pintaremos el cilindro estre ambas bolas cuando la variable pintar sea cierta

            nuevaDir = -1 * vector(x, y, z)
            cylinder(pos=vector(posX, posY, posZ), axis=mov*nuevaDir, radius=0.2, color=self.color)
            sphere(pos=vector(posX, posY, posZ), radius=0.2, color=color.red)

        # self.bola2.pos = vector(posX,posY,posZ)
        self.bola.pos -= mov*vector(x, y, z)

    def forward(self, mov):    # Funcion que calculo la nueva posicion de las bolas y el cilindro a pintar.

        posX = self.bola.pos.x  # Guaradamos las coordenadas actuales de la bola principal antes de moverla
        posY = self.bola.pos.y
        posZ = self.bola.pos.z

        x = cos(radians(self.alpha)) * cos(radians(self.beta))
        z = sin(radians(self.alpha)) * cos(radians(self.beta))
        y = sin(radians(self.beta))

        if self.pintar == True:  # Solo pintaremos el cilindro estre ambas bolas cuando la variable pintar sea cierta
            nuevaDir = vector(x, y, z)
            cylinder(pos=vector(posX, posY, posZ), axis=mov*nuevaDir, radius=0.2, color=self.color)
            sphere(pos=vector(posX, posY, posZ), radius=0.2, color=color.red)
        #self.bola2.pos = vector(posX,posY,posZ)

        self.bola.pos += mov*vector(x, y, z)

    def up(self, mov):   # Aumentamos el angulo vertical
        self.beta += mov

    def down(self, mov):   # Decrementamos el angulo vertical
        self.beta -= mov

    def right(self, mov):  # Aumentamos el angulo horizontal
        self.alpha += mov

    def left(self, mov):   # Aumentamos el angulo horizontal
        self.alpha -= mov

    def home(self):  # Funcion que coloca la bola principal en el (0,0,0) y restablece los angulos
        self.initProg()
        self.bola.pos = vector(0, 0, 0)
        self.beta = 0
        self.alfa = 0

    def changeCol(self, col1, col2, col3):  # Funcion que cambia el color que del cilindro
        self.color = vector(col1, col2, col3)

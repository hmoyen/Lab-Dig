from typing import Any
import pygame
from Teclado import Teclado
import os


class Menu():
    TIPO = "MODO" #MODO, VIDA ou MAPA
    MODOS = ['FACIL', 'MEDIO', 'DIFICIL'] #FACIL, MEDIO ou DIFICIL
    MODO = 0 #0 a 2
    VIDAS = 1 #1 a 5
    MAPA = 0 #0 ou 1
    
    def __init__(self, window, listener):
        self.window = window
        self.listener = listener
        
    def modo(self):
        selected_mode = self.MODOS[self.MODO]

        font_path = os.path.join("assets", "Fonts", "ARCADECLASSIC.ttf")
        font = pygame.font.Font(font_path, 36)

        text = font.render("VOCE SELECIONOU O MODO {}".format(selected_mode), True, (0, 0, 0))
        text_rect = text.get_rect()
        text_rect.center = (self.window.get_width() // 2, self.window.get_height() // 2)
        self.window.fill((255, 255, 255))
        self.window.blit(text, text_rect)
        pygame.display.update()
        

        # DEVOLVE UM DICIONARIO COM OS COMANDOS ACIONADOS (True ou False)
        # ENTER confirma o modo
        if self.listener.teclas['ENTER']:
            self.TIPO = "VIDA"
        # SE NÃO, ALTERA O MODO
        if self.listener.teclas['UP']:
            self.MODO = (self.MODO + 1) % 3
        if self.listener.teclas['DOWN']:
            if self.MODO == 0:
                self.MODO = 2
            else:
                self.MODO = (self.MODO - 1) % 3
            

                    
    def __call__(self):
        match self.TIPO:
            case "MODO":
                self.modo()
            case "VIDA":
                self.vida()
            case "MAPA":
                self.mapa()
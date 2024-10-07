# -*- coding: utf-8 -*-
"""
Created on Tue Jun 29 18:34:17 2021

@author: UTENTE
"""

from enum import Enum
import numpy as np
import pandas as pd
import random as rn



class Position(Enum):
    OUT = 0
    SHORT = 1
    LONG = 2
    
    
class Action(Enum):
    SELL = 0
    BUY = 1



class TradingEnv():
    
    
    def __init__(self, ws, mode):
        
        
        if(mode == "training"):
            #prelevo dati 15M NAS100
            self.nas100 = pd.read_csv("C:\\Users\\UTENTE\\Desktop\\Reinforcement learning\\Progetto IA\\Database\\dati_allenamento.csv")
       
            #prelevo solo i dati delle chiusure e trasformo in array
            self.nas100 = self.nas100["Close"].to_numpy()
        
        elif(mode == "verifica1"):
            
            #prelevo dati 15M NAS100
            self.nas100 = pd.read_csv("C:\\Users\\UTENTE\\Desktop\\Reinforcement learning\\Progetto IA\\Database\\dati_verifica1.csv")
       
            #prelevo solo i dati delle chiusure e trasformo in array
            self.nas100 = self.nas100["Close"].to_numpy()
            
        elif(mode == "verifica2"):
            
            #prelevo dati 15M NAS100
            self.nas100 = pd.read_csv("C:\\Users\\UTENTE\\Desktop\\Reinforcement learning\\Progetto IA\\Database\\dati_verifica2.csv")
       
            #prelevo solo i dati delle chiusure e trasformo in array
            self.nas100 = self.nas100["Close"].to_numpy()
            
        else:
            
            #prelevo dati 15M NAS100
            self.nas100 = pd.read_csv("C:\\Users\\UTENTE\\Desktop\\Reinforcement learning\\Progetto IA\\Database\\dati_verifica3.csv")
       
            #prelevo solo i dati delle chiusure e trasformo in array
            self.nas100 = self.nas100["Close"].to_numpy()
            
        
        #dimensione step di un episodio
        self.window_size = ws
        
        #tick inizio dati
        self._start_tick = 0
        
        #true se l'episodio è finito
        self._done = False
        
        #stato iniziale, fuori dal mercarto
        self._state = Position.OUT.value       
        
        #dato corrente
        self._current_tick = self._start_tick
        
        #tick dell' ultima operazione
        self._start_trade_tick = None       
        
        #capitale iniziale
        self._capitale = 1000
        


    
    
    def get_state(self, action):
        
        if(self._state == Position.OUT.value and action == Action.SELL.value):
            self._state = Position.SHORT.value
            #salvo il tick del prezzo di entrata a mercato
            self._start_trade_tick = self._current_tick
            
        elif(self._state == Position.OUT.value and action == Action.BUY.value):
            self._state = Position.LONG.value
            #salvo il tick del prezzo di entrata a mercato
            self._start_trade_tick = self._current_tick
        
        elif(self._state == Position.SHORT.value and action == Action.SELL.value):
            self._state = Position.SHORT.value
        
        elif(self._state == Position.SHORT.value and action == Action.BUY.value):
            self._state = Position.OUT.value
        
        elif(self._state == Position.LONG.value and action == Action.BUY.value):
            self._state = Position.LONG.value
            
        else:
            self._state = Position.OUT.value
        
        
        return self._state
    
    
    
    def action_sample(self):
        
        if(rn.random() <= 0.5):
            return Action.SELL.value 
        else:
            return Action.BUY.value
        
        
    def step(self, action):
        
        #riceve la ricompensa
        reward = self.calculate_reward(action)
        
        #ottiene il prossimo stato
        next_state = self.get_state(action)
        
        #manda vanti di 1  lo step
        self._current_tick += 1
         
        #se True allora l'episodio è finito
        if (self._current_tick % self.window_size == 0):
            self.done = True
                 
        return self.done, next_state, reward
        
    
    def calculate_reward(self, action):
        
        delta = 0
        
        start_price = self.nas100[self._start_trade_tick]
        
        end_price = self.nas100[self._current_tick]
        
        
        #per ottenere una ricompensa bisogna prima essere dentro a mercato e poi uscire con l'apposita azione
        
        if(self._state == Position.OUT.value and action == Action.SELL.value):
            delta = 0
            
        elif(self._state == Position.OUT.value and action == Action.BUY.value):
            delta = 0
        
        elif(self._state == Position.SHORT.value and action == Action.SELL.value):
            delta = 0
        
        elif(self._state == Position.SHORT.value and action == Action.BUY.value):
            delta = -(end_price - start_price)
        
        elif(self._state == Position.LONG.value and action == Action.BUY.value):
            delta = 0
            
        else:
            delta = end_price - start_price
        
        self._capitale += delta 
        
        return delta
    
    
    def reset(self):
        
        #ripristino per inizio nuovo episodio 
        
        self.done = False
        
        self._state = Position.OUT.value
        
        return self.done, self._state
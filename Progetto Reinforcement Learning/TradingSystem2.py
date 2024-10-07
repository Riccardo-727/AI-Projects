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

#questa classe è sostanzialmemte uguale a quella del modulo TradingSystem solo che sono stati unati due capitali
#in particolare capitale2 serve per la fase di valutazione.
#è stata creata un' altra classe per non appesantire il codice dell' altra lasciando così solo le funzioni principali


class TradingEnv():
    
    
    def __init__(self, ws):
               
        #prelevo dati close 
        self.nas100 = pd.read_csv("C:\\Users\\UTENTE\\Desktop\\Reinforcement learning\\Progetto IA\\Database\\dati_system2.csv").to_numpy()
        
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
        
        #capitale iniziale usat quando mode == system2
        self._capitale_2 = 1000
        
        #per capire se si tratta della fase di allenamento o test
        self.session = "allenamento"


    
    
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
        
        reward = self.calculate_reward(action)
        
        next_state = self.get_state(action)
        
        self._current_tick += 1
        
        if (self._current_tick % self.window_size == 0):
            self.done = True
                                
        return self.done, next_state, reward
        
    
    def calculate_reward(self, action):
        
        if(self.session == "allenamento"):
            
            delta = 0
            
            start_price = self.nas100[self._start_trade_tick]
            
            end_price = self.nas100[self._current_tick]
            
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
            
        else:
            
            delta = 0
            
            start_price = self.nas100[self._start_trade_tick]
            
            end_price = self.nas100[self._current_tick]
            
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
            
            self._capitale_2 += delta
            
        
        return delta
    
    
    def reset(self):
        
        self.done = False
        
        self._state = Position.OUT.value
        
        return self.done, self._state
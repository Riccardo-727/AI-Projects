#valutazione agente

import numpy as np
import random as rn
import TradingSystem as ts
import allenamento as al
import matplotlib.pyplot as plt


q_table = al.q_table

window_size = al.window_size

#usare verifica1, verifica2, verifica3 a seconda se si vogliono usare i dati del 2020, 2021 o 2022
tr = ts.TradingEnv(window_size, "verifica1")

#vettore che mi contiene il montante alla fine di ogni periodo
montante = np.zeros(int(len(tr.nas100)/window_size))

for i in range(1, int(len(tr.nas100)/window_size), 1):

    done, state = tr.reset()

    while not done:
        
        action = np.argmax(q_table[state])
    
        done, state, reward = tr.step(action)
    
    montante[i] = tr._capitale

plt.plot(montante)


import numpy as np
import TradingSystem as ts
import random as rn


#parametri algoritmo
alpha = 0.1
gamma = 0.6
epsilon = 0.1

#tabella action-value
q_table = np.zeros([len(ts.Position), len(ts.Action)])

#dimensione step episodio
window_size = 200

#variabile che contiene i metodi utili dell'algoritmo, lasciare sempre impostato su training
tr = ts.TradingEnv(window_size, "training")

#iterazione episodi
for i in range(1, int(len(tr.nas100)/window_size), 1):
    
    done, state = tr.reset()
    
    while not done:
        
        if rn.random() < epsilon:
            action = tr.action_sample()
        else:
            action = np.argmax(q_table[state]) 
    

        done, next_state, reward = tr.step(action)
    
        old_value = q_table[state, action]   
    
        q_table[state, action] = old_value + alpha * (reward + gamma * np.max(q_table[next_state]) - old_value)
    
        state = next_state



    
    
    
    
import numpy as np
import TradingSystem2 as ts2
import random as rn
import matplotlib.pyplot as plt



#parametri algoritmo
alpha = 0.1
gamma = 0.6
epsilon = 0.1

#dimensione step episodio
window_size = 96

#variabile che contiene i metodi utili dell'algoritmo
tr2 = ts2.TradingEnv(window_size)

#montante
montante = np.zeros(100)

for i in range (0, 100 , 1):
    
    #FASE ALLENAMENTO
    
    #tabella action-value
    q_table = np.zeros([len(ts2.Position), len(ts2.Action)])
          
    tr2.session = "allenamento"   
    
    #iterazione episodi
    for j in range(0, 15, 1):
        
        done, state = tr2.reset()
        
        while not done:
            
            #politica epsilon-greedy
            if rn.random() < epsilon:
                action = tr2.action_sample()
            else:
                action = np.argmax(q_table[state]) 
        
    
            done, next_state, reward = tr2.step(action)
        
            old_value = q_table[state, action]
        
        
            q_table[state, action] = old_value + alpha * (reward + gamma * np.max(q_table[next_state, :]) - old_value)
        
            state = next_state
    
    
    # FASE VALUTAZIONE
    
    tr2.session = "valutazione"
    
    for z in range(0, 1, 1):
    
        done, state = tr2.reset()
    
        while not done:
            
            action = np.argmax(q_table[state])
        
            done, state, reward = tr2.step(action)
        
        montante[z + i] = tr2._capitale_2

plt.plot(montante)


        
        
        
        
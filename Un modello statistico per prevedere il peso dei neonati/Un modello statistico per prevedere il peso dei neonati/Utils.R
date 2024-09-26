indice_gini = function(vettore){
  
    
  fi = table(vettore) / length(vettore)
    
  G = 1 - sum(fi^2)
  
  j = length(table(vettore))

  gini = G/((j-1)/j)
  
  return(gini)
  
}


MSE = function(vettore, mu){
  
  temp = sum( (vettore-mu)^2 )/length(vettore)
  
}
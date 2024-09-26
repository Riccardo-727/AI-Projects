#utilizzo la proprietà associativa del prodotto in modo tale da poter gestire vettori grandi, con numeri grandi
geometric_mean = function(vettore){
  
  prod(vettore^(1/length(vettore)))
 
}



armonic_mean = function(vettore){
  
  length(vettore)/(sum(1/vettore))
}



indice_gini = function(vettore, num_classi = 10, tipo_variabile="quantitativa"){
  
  if( tipo_variabile == "quantitativa")
    {
    
    distr_classi = get_distribuzione_frequenze(vettore, num_classi)
    
    fi = distr_classi[["fi"]]
    
    G = 1 - sum(fi^2)
    
    j = num_classi
    
    }
  
  else if(tipo_variabile == "qualitativa")
    {
      
    fi = table(vettore) / length(vettore)
    
    G = 1 - sum(fi^2)
    
    j = length(table(vettore))
    
    }
  
  else
    {
    return()
    }
    
    gini = G/((j-1)/j)
    
    return(gini)
  
}



indice_asimmetria = function(vettore){
  
  skewness_partial = sum( (vettore-mean(vettore))^3 ) / length(vettore)
  
  dev_std = sd(vettore)
  
  skewness =  skewness_partial / dev_std^3 
}




indice_curtosi = function(vettore){
  
  curtosi_partial = sum( (vettore-mean(vettore))^4 ) / length(vettore)
  
  dev_std = sd(vettore)
  
  curtosi =  (curtosi_partial / dev_std^4 ) - 3 
}




get_distribuzione_frequenze = function(vettore, num_classi=10){
  
  vettore_div_classi = cut(vettore, seq(min(vettore), max(vettore), (max(vettore)-min(vettore))/num_classi ))
  
  ni = table(vettore_div_classi)
  fi = table(vettore_div_classi) / length(vettore)
  Ni = cumsum(table(vettore_div_classi))
  Fi = cumsum(table(vettore_div_classi)) / length(vettore)
  
  
  #distribuzione in frequenza di months_inventory
  vettore_distr_freq = as.data.frame( cbind( ni, fi, Ni, Fi))
  return(vettore_distr_freq)
}




indici_di_variabilità = function(name, value){
  
  #range
  min_max = quantile(sort(value))[c(1, 5)] 
  print("**RANGE**")
  print(sprintf("il range per la variabile '%s' è: %s ", name, min_max[2] - min_max[1] ))
  cat("\n")
  
  
  #range interquartile
  iqr = IQR(value)
  print("**RANGE INTERQUARTILE**")
  print(sprintf("il range interquartile per la variabile '%s' è: %s ", name, iqr ))
  cat("\n")
  
  #varianza
  varianza = var(value)
  print("**VARIANZA**")
  print(sprintf("la variazna per la variabile '%s' è: %s ", name, varianza ))
  cat("\n")
  
  #deviazione standard
  dev_std = sd(value)
  print("**DEVIAZIONE STANDARD**")
  print(sprintf("la deviazione standard per la variabile '%s' è: %s ", name, dev_std ))
  cat("\n")
  
  #coefficiente di variazione
  coeff_var = dev_std/mean(value)*100
  print("**COEFFICIENTE DI VARIAZIONE**")
  print(sprintf("il coefficiente di variazione per la variabile '%s' è: %s ", name, coeff_var ))
  cat("\n")
  
  
  #indice di gini
  gini = indice_gini(value, 10)
  print("**INDICE DI GINI**")
  print(sprintf("l' indice di GINI per la variabile '%s' è: %s ", name, gini ))
  cat("\n")
  
  ## return(list(min_max[2]-min_max[1], iqr, varianza, dev_std, coeff_var, gini)
  
}

indici_di_forma = function(name, value){
  
  #asimmetria
  skew = indice_asimmetria(value)
  print("**ASIMMETRIA**")
  print(sprintf("l'indice di asimmetria per la variabile %s è: %s ", name, skew))
  cat("\n")
  
  #curtosi
  kurt = indice_curtosi(value)
  print("**CURTOSI**")
  print(sprintf("l'indice di curtosi per la variabile %s è: %s ", name, kurt))
  cat("\n")
  
}

#Prima parte del progetto


#installazzione dei pacchetti
install.packages("moments")
install.packages("psych")
install.packages("dplyr")


# 1) Importa il dataset “Real Estate Texas.csv”, 

RealEstateTexax_Dataframe = read.csv("Real Estate Texas.csv")

# per riferirmi alle colonne del dataframe senza usare la notazione:  RealEstateTexax_Dataframe$nome_colonna

attach(RealEstateTexax_Dataframe)



# 2) Indica il tipo di variabili

class(city) #qualitativa nominale

class(year) #qualitativa ordinale 

class(month) #qualitativa ordinale

class(sales) #quantitativa discreta, scala rapporti

class(volume) #quantitativa continua, scala rapporti

class(median_price) #quantitativa continua, scala rapporti

class(listings) #quantitativa discreta, scala rapporti

class(months_inventory) #quantitavia discreta, scala rapporti




# 3)	Calcola Indici di posizione, variabilità e forma per tutte le variabili per le quali ha senso farlo, per le altre crea una distribuzione di frequenza.

# -> INDICI DI POSIZIONE

# ->-> CITY, essendo variabili qualitative ha senso calcolare solo la moda

table(city)
max(table(city)) #moda: distribuzione equimodale. Valore della fequenza è 60

# ->-> YEAR 

table(year)
max(table(year)) #moda: distribuzione equimodale. Valore della fequenza è 48


# ->-> MONTH

table(month)
max(table(month)) #moda: distribuzione equimodale. Valore della fequenza è 20



# ->-> SALES

#divisione in classi di sales
sales_div_classi = cut(sales, seq(min(sales), max(sales), (max(sales)-min(sales))/10 ))

ni = table(sales_div_classi)
fi = table(sales_div_classi) / length(sales)
Ni = cumsum(table(sales_div_classi))
Fi = cumsum(table(sales_div_classi)) / length(sales)


#distribuzione in frequenza di sales
sales_distr_freq = as.data.frame( cbind( ni, fi, Ni, Fi))


#moda = classe (148,182], con valore della frequenza uguale a 47
table(sales_div_classi)
max(table(sales_div_classi))  #1° metodo  

max(sales_distr_freq["ni"])  #2° metodo


#mediana =  175.5
median(sort(sales))   #1° metodo 

x = sales_distr_freq["Fi"][[1]]     #2° metodo
index = which(x >= 0.50)[1]         # ritorna la classe "(148,182]", ok la mediana è contenuta in tale classe
rownames(sales_distr_freq)[index]


#quantili
quantile(sort(sales))[c(1, 5)] #minimo = 79, massimo = 423


#media 

# -> ARITMETICA = 192.2917
mean(sales)

# -> PONDERATA = 193.763  NOTA: anche con i dati sintetizzati si ha avuto un'ottima precisione
valori = seq(min(sales), max(sales), (max(sales)-min(sales))/10 ) + (((max(sales)-min(sales))/10) /2)
valori = valori[-11]
pesi = sales_distr_freq["ni"][[1]] 
weighted.mean(valori, pesi)



# ->-> VOLUME

#divisione in classi di volume
volume_div_classi = cut(volume, seq(min(volume), max(volume), (max(volume)-min(volume))/10 ))

ni = table(volume_div_classi)
fi = table(volume_div_classi) / length(volume)
Ni = cumsum(table(volume_div_classi))
Fi = cumsum(table(volume_div_classi)) / length(volume)


#distribuzione in frequenza di volume
volume_distr_freq = as.data.frame( cbind( ni, fi, Ni, Fi))


#moda
#distribuzione bimodale con modalità: (8.17,15.7] e (15.7,23.2]. Valore Frequenza=46
table(volume_div_classi)
max(table(volume_div_classi))  #1° metodo  

max(volume_distr_freq["ni"])  #2° metodo


#mediana =   27.0625
median(sort(volume))   #1° metodo 

x = volume_distr_freq["Fi"][[1]]     #2° metodo
index = which(x >= 0.50)[1]          # ritorna la classe "(23.2,30.8]", ok la mediana è contenuta in tale classe
rownames(volume_distr_freq)[index]


#quantili
quantile(sort(volume))[c(1, 5)] #minimo = 8.166, massimo = 83.547 


#media 

# -> ARITMETICA = 31.00519
mean(volume)

# -> PONDERATA = 31.20609  NOTA: anche con i dati sintetizzati si ha avuto un'ottima precisione
valori = seq(min(volume), max(volume), (max(volume)-min(volume))/10 ) + (((max(volume)-min(volume))/10) /2)
valori = valori[-11]
pesi = volume_distr_freq["ni"][[1]] 
weighted.mean(valori, pesi)



# ->-> MEDIAN_PRICE

#divisione in classi di median_price
median_price_div_classi = cut(median_price, seq(min(median_price), max(median_price), (max(median_price)-min(median_price))/10 ))

ni = table(median_price_div_classi)
fi = table(median_price_div_classi) / length(median_price)
Ni = cumsum(table(median_price_div_classi))
Fi = cumsum(table(median_price_div_classi)) / length(median_price)


#distribuzione in frequenza di median_price
median_price_distr_freq = as.data.frame( cbind( ni, fi, Ni, Fi))


#moda = classe (1.27e+05,1.38e+05], con valore della frequenza uguale a 48
table(median_price_div_classi)
max(table(median_price_div_classi))  #1° metodo  

max(median_price_distr_freq["ni"])  #2° metodo


#mediana =  134500
median(sort(median_price))   #1° metodo 

x = median_price_distr_freq["Fi"][[1]]     #2° metodo
index = which(x >= 0.50)[1]                # ritorna la classe "(1.27e+05,1.38e+05]", ok la mediana è contenuta in tale classe
rownames(median_price_distr_freq)[index]


#quantili
quantile(sort(median_price))[c(1, 5)] #minimo = 73800, massimo = 180000 


#media 

# -> ARITMETICA = 132665.4
mean(median_price)

# -> PONDERATA = 132965.4  
valori = seq(min(median_price), max(median_price), (max(median_price)-min(median_price))/10 ) + (((max(median_price)-min(median_price))/10) /2)
valori = valori[-11]
pesi = median_price_distr_freq["ni"][[1]] 
media_ponderata = weighted.mean(valori, pesi)



# ->-> LISTINGS

#divisione in classi di listings
listings_div_classi = cut(listings, seq(min(listings), max(listings), (max(listings)-min(listings))/10 ))

ni = table(listings_div_classi)
fi = table(listings_div_classi) / length(listings)
Ni = cumsum(table(listings_div_classi))
Fi = cumsum(table(listings_div_classi)) / length(listings)


#distribuzione in frequenza di listings
listings_distr_freq = as.data.frame( cbind( ni, fi, Ni, Fi))


#moda = classe (1.51e+03,1.76e+03], con valore della frequenza uguale a 67
table(listings_div_classi)
max(table(listings_div_classi))  #1° metodo  

max(listings_distr_freq["ni"])  #2° metodo


#mediana =  1618.5
median(sort(listings))   #1° metodo 

x = listings_distr_freq["Fi"][[1]]     #2° metodo
index = which(x >= 0.50)[1]         # ritorna la classe "(1.51e+03,1.76e+03]", ok la mediana è contenuta in tale classe
rownames(listings_distr_freq)[index]


#quantili
quantile(sort(listings))[c(1, 5)] #minimo = 743, massimo = 3296


#media 

# -> ARITMETICA = 1738.021
mean(listings)

# -> PONDERATA = 1739.097  NOTA: anche con i dati sintetizzati si ha avuto un'ottima precisione
valori = seq(min(listings), max(listings), (max(listings)-min(listings))/10 ) + (((max(listings)-min(listings))/10) /2)
valori = valori[-11]
pesi = listings_distr_freq["ni"][[1]] 
media_ponderata = weighted.mean(valori, pesi)



# ->-> MONTHS_INVENTORY  


#divisione in classi di months_inventory
months_inventory_div_classi = cut(months_inventory, seq(min(months_inventory), max(months_inventory), (max(months_inventory)-min(months_inventory))/10 ))

ni = table(months_inventory_div_classi)
fi = table(months_inventory_div_classi) / length(months_inventory)
Ni = cumsum(table(months_inventory_div_classi))
Fi = cumsum(table(months_inventory_div_classi)) / length(months_inventory)


#distribuzione in frequenza di months_inventory
months_inventory_distr_freq = as.data.frame( cbind( ni, fi, Ni, Fi))


#distribuzione bimodale delle classi (6.85,8] e (8,9.15], con valore della frequenza uguale a 54
table(months_inventory_div_classi)
max(table(months_inventory_div_classi))  #1° metodo  

max(months_inventory_distr_freq["ni"])  #2° metodo


#mediana =  8.95
median(sort(months_inventory))   #1° metodo 

x = months_inventory_distr_freq["Fi"][[1]]     #2° metodo
index = which(x >= 0.50)[1]                    # ritorna la classe "(8,9.15]", ok la mediana è contenuta in tale classe
rownames(months_inventory_distr_freq)[index]


#quantili
quantile(sort(months_inventory))[c(1, 5)] #minimo = 3.4, massimo = 14.9 


#media 

# -> ARITMETICA = 9.1925
mean(months_inventory)

# -> PONDERATA = 9.200523  NOTA: anche con i dati sintetizzati si ha avuto un'ottima precisione
valori = seq(min(months_inventory), max(months_inventory), (max(months_inventory)-min(months_inventory))/10 ) + (((max(months_inventory)-min(months_inventory))/10) /2)
valori = valori[-11]
pesi = months_inventory_distr_freq["ni"][[1]] 
media_ponderata = weighted.mean(valori, pesi)




# -> INDICI DI VARIABILITA'

# ->-> CITY

#per le variabili qualitative  ha senso calcolare solo l'indice di gini

gini_city = indice_gini(city, tipo_variabile="qualitativa") # gini = 1 -> le classi hanno il massimo livello di omogeneità, infatti la distribuzione è equimodale
gini_city

# ->-> YEAR

gini_year = indice_gini(year, tipo_variabile="qualitativa")  # gini = 1 -> le classi hanno il massimo livello di omogeneità, infatti la distribuzione è equimodale
gini_year

# ->-> MONTH

gini_month = indice_gini(month, tipo_variabile="qualitativa")  # gini = 1 -> le classi hanno il massimo livello di omogeneità, infatti la distribuzione è equimodale
gini_month

# ->-> SALES

indici_di_variabilità("sales", sales) 

# ->-> VOLUME

indici_di_variabilità("volume", volume) 

# ->-> MEDIAN_PRICE

indici_di_variabilità("median_price", median_price) 

# ->-> LISTINGS

indici_di_variabilità("listings", listings) 

# ->-> MONTHS_INVENTORY

indici_di_variabilità("months_inventory", months_inventory)



# -> INDICI DI FORMA


# ->-> CITY
# ->-> YEAR
# ->-> MONTH
#per le variabili city, year e month non ha senso calcolare gli indici di forma in quanto qualitative

library(moments)

# ->-> SALES

indici_di_forma("sales", sales) 

#prova correttezza funzioni "indice asimmetria"e "indice curtosi"
#funzioni del pacchetto "moments"
skewness(sales)  
kurtosis(sales) - 3
#--> ok piccola differenza dovuta probabilmente ad arrotondamenti
#--> per non installare il pacchetto alscio a voi la verifica, con il pacchetto "e1071" si ottengono valori più vicini ai miei rispetto che al "moments"


# ->-> VOLUME

indici_di_forma("volume", volume) 

# ->-> MEDIAN_PRICE

indici_di_forma("median_price", median_price) 

# ->-> LISTINGS

indici_di_forma("listings", listings) 

# ->-> MONTHS_INVENTORY

indici_di_forma("months_inventory", months_inventory) 




# 4) 	Qual è la variabile con variabilità più elevata? Come ci sei arrivato? E quale quella più asimmetrica?

#-> la variabile con variabilità più elevata è il volume, conclusione fatta osservando il coefficiente di variazione
#   delle diverse variabili. Ho utilizzato questo indice percè permette di confrontare variabili provenienti da distribuzioni diverse.

#-> la variabile più asimmetrica è ancora il volume. Per giungere a questa conclusione ho confrontato il valore assoluto
#   dei vari indici di asimmetria delle variabili e prendendo quello più grande, ricordando che un indice di asimmetria pari
#   a zero corrisponde a una simmetria perfetta, come quella della distribuzione normale.



# 5)	Dividi una delle variabili quantitative in classi, scegli tu quale e come, costruisci la distribuzione di frequenze, il grafico a barre corrispondente e infine calcola l’indice di Gini. 

distribuzione_frequenze_volume = get_distribuzione_frequenze(volume)

#ingrandire per vedere nome classi
barplot(distribuzione_frequenze_volume$ni,
        xlab = "volume, in milioni di dollari",
        ylab = "Frequenze assolute",
        names.arg = rownames(distribuzione_frequenze_volume),
        # cex.axis = 0.8,   -> riduzione font per labelasse y
        # cex.lab = 0.8,    -> riduzione font per per label asse x
        cex.names = 0.7,  # -> riduzione font per per descrizione classi
        xlim = c(0,12),
        ylim = c(0,50),
        col="blue")



# 6)	Indovina l’indice di gini per la variabile city.

gini_city = indice_gini(city, tipo_variabile="qualitativa") # gini = 1 -> le classi hanno il massimo livello di omogeneità, infatti la distribuzione è equimodale
gini_city



# 7)	Qual è la probabilità che presa una riga a caso di questo dataset essa riporti la città “Beaumont”? E la probabilità che riporti il mese di Luglio? E la probabilità che riporti il mese di dicembre 2012?

#essendo che conosco i dati posso usare l'approccio classico: numero di casi favorevoli / totale dei casi

prob_beaumont = table(city)["Beaumont"] / length(city)
prob_beaumont  # ok 0.25 infatti ho 4 valori possibili equiprobabili

prob_luglio = table(month)[7] / length(month)
prob_luglio  # ok 0.0833 infatti ho 12 valori possibili equiprobabili

prob_dic_2012 = sum( RealEstateTexax_Dataframe[["month"]] == "12" & RealEstateTexax_Dataframe[["year"]] == 2012 ) / nrow(RealEstateTexax_Dataframe)  #NOTA: Length(RealEstateTexax_Dataframe) -> ottengo il numero di colonne, non righe
prob_dic_2012  # 0.01666667

#esercizio mio:  E la probabilità che riporti il mese di dicembre  DATO CHE l anno è il 2012?

# A := evento che esca il mese dicembre
# B := evento che esca l'anno 2012

#P(A | B) ?    
#P(A ∩ B) = 0.01666667
#P(B) = 0.2

#->P(A | B) = 0.0833 -> perchè le probabilità dei mesi all interno di un anno sono equiprobabili



# 8)	Esiste una colonna col prezzo mediano, creane una che indica invece il prezzo medio, utilizzando le altre variabili che hai a disposizione

RealEstateTexax_Dataframe["mean_price"] = volume/sales*1000000



# 9)	Prova a creare un’altra colonna che dia un’idea di “efficacia” degli annunci di vendita. Riesci a fare qualche considerazione?


RealEstateTexax_Dataframe["conversion_coefficient"] = sales/listings*100

coefficiente_conversione = RealEstateTexax_Dataframe$conversion_coefficient

mean_coefficiente_conversione = mean(coefficiente_conversione)


std_coefficiente_conversione = sd(coefficiente_conversione)


library(dplyr)

dati_raggruppati1 <- RealEstateTexax_Dataframe[ c("month", "conversion_coefficient")] %>% 
  group_by(month) %>%
  summarise(media_conversione1 = mean(conversion_coefficient, na.rm = TRUE))

dati_raggruppati2 <- RealEstateTexax_Dataframe[ c("year", "conversion_coefficient")] %>% 
  group_by(year) %>%
  summarise(media_conversione2 = mean(conversion_coefficient, na.rm = TRUE))
  
# per il punto 9 come  indicatore si è preso in considerazione il coefficiente di conversione.
#Esso ha una media pari a:
mean_coefficiente_conversione

#e una deviazione standard pari a:
std_coefficiente_conversione

#inoltre si è riscontrato che la maggior efficacia degli annunci la si ha nel periodo estivo:
dati_raggruppati1

#infine si nota un trend positivo nell'efficacia degli annunci in base al tempo
dati_raggruppati2

#ulteriori considerazioni
model <- lm(sales ~ coefficiente_conversione, data = RealEstateTexax_Dataframe)
summary(model)
# 1. -> il p-value proposto permette di non confutare il legame che sussiste tra le due variabili, quindi effettivamente pubblicare annunci ha un effetto sulle vendite
# 2. -> d altra parte considerando Multiple R-squared si può notare che solo il 17% circa della variabilità dei dadti poò essere spiegata dal modello, di consegunza gli annunci non sono l'unico fattore che incide sulle vendite



# 10)	Prova a creare dei summary()
#oltre a quelli fatti nel punto 9:


totale_venduto_città <- RealEstateTexax_Dataframe %>% 
  group_by(city) %>%
  summarise(media_fatturato = mean(volume, na.rm = TRUE))

totale_venduto_città

#città con maggiore fatturato = Tyler




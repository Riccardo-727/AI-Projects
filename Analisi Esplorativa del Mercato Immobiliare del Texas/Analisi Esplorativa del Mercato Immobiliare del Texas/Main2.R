#Seconda parte del progetto

install.packages("ggplot2")
install.packages("dplyr")

library("ggplot2")

# 1) 

RealEstateTexax_Dataframe = read.csv("Real Estate Texas.csv")
attach(RealEstateTexax_Dataframe)

ggplot(data = RealEstateTexax_Dataframe) +
  geom_boxplot( aes(x = city, y = median_price ), fill="skyblue", color = "blue", lwd = 0.5)

# in generale le 4 distribuzioni di prezzo sembrano essere abbastanza simmetriche, con quella relativa alla city Tyler che presenta la maggior simmetria tra le 4
# le case con il median price  più alto si trovano a Bryan-College Station e quelle con quello più basso a Wichita Falls
# le case con i median price più variabili sembrano trovarsi a Wichita Falls, dato ricavato osservando la maggior ampiezza del range interquantile rispetto agli altri e anche dalla maggior lunghezza delle code, considerando anche gli outliers



# 2)

ggplot(data = RealEstateTexax_Dataframe) +
       geom_boxplot(aes(x = city, y = volume, fill = as.factor(year))) +  #as.factor() -> per trasformare variabile integer in categorica
       labs(x = "City", y = "Volume", fill = "Year") +
       theme_minimal()

# il volume totale delle vendite a Wichita Falls è il più basso tra tutti e non presenta trend, si è infatti mosso all'interno di un range orizzontale. Anche la varianza è rimasta costante negli anni. 
# per le altre città invece si può notare un movimento direzionale, meno evidente per Beaumount, mentre molto in vista per le restanti 2.
# Oltre ad avere un trend positivo per quanto riguarda il volume delle vendite , Bryan-College Station e Tyler presentano anche un trend positivo per quanto riguarda la variabilità, la quale infatti è aumentata al passare degli anni.
# Dal grafico si può giungere quindi alla conclusione che negli ultimi anni l'interesse per l'acquisto di una casa a Bryan-College Station o a Tyler è aumentato in maniera significativa, leggermente a Beaumount e per nulla a Wichita falls.



# 3)

library("dplyr")

totale_vendite_mensili <- RealEstateTexax_Dataframe %>% 
  group_by(city, month) %>%
  summarise(totale_vendite = sum(sales, .groups=month, na.rm = TRUE))

totale_vendite_mensili


ggplot(data = totale_vendite_mensili) +
  geom_bar( aes(x = city,  y = totale_vendite_mensili$totale_vendite, fill = as.factor(month)),
            position = "stack", stat = "identity", col = "black", lwd = 0.2) +  
  labs(x = "City", y = "Confronto vendite mensili") +
  scale_fill_discrete(name = "Month") +
  theme_minimal()


# dal grafico a barre sovrapposte si può notare come le vendite nella città di Beaumount e  Wichita Falls siano state più o meno costanti durante tutti i mesi.
# mentre per le città di Bryan-College Station e Tyler sembra che le vendite siano maggiore durante i mesi primaverilie ed estivi piuttosto che gli altri.
# inoltre il numero totale di vendite è maggiore nella città di Tyler e a seguire in Bryan-College Station, Beaumount e  Wichita Falls.


#grafico a barre sovrapposte normalizzato

ggplot(data = totale_vendite_mensili) +
  geom_bar( aes(x = city,  y = totale_vendite_mensili$totale_vendite, fill = as.factor(month)),
            position = "fill", stat = "identity", col = "black", lwd = 0.2) +  
  labs(x = "City", y = "Confronto vendite mensili") +
  scale_fill_discrete(name = "Month") +
  theme_minimal()

# PRO LEVEL

ggplot(data = RealEstateTexax_Dataframe["sales"]) +
  geom_bar( aes(x = city,  y = sales, fill = as.factor(month), col = "grey", lwd = 1),
            position = "fill", stat = "sum", col = "black", lwd = 0.2) +  
  labs(x = "City", y = "Confronto vendite mensili") +
  scale_fill_discrete(name = "Month") +
  theme_minimal()




# 4)


dati_Beaumont <- filter(RealEstateTexax_Dataframe, city == "Beaumont")
dati_Bryan_college <- filter(RealEstateTexax_Dataframe, city == "Bryan-College Station")
dati_Tyler <- filter(RealEstateTexax_Dataframe, city == "Tyler")
dati_Wichita <- filter(RealEstateTexax_Dataframe, city == "Wichita Falls")


dati_Beaumont <- dati_Beaumont %>%
  rename_with(~paste0("Beaumont_", .), everything())

dati_Bryan_college <- dati_Bryan_college %>%
  rename_with(~paste0("Bryan_college_", .), everything())

dati_Tyler <- dati_Tyler %>%
  rename_with(~paste0("Tyler_", .), everything())

dati_Wichita <- dati_Wichita %>%
  rename_with(~paste0("Wichita_", .), everything())



new_dataframe = as.data.frame(cbind(dati_Beaumont, dati_Bryan_college, dati_Tyler, dati_Wichita))

attach(new_dataframe)
                                    # NOTA: un' istruzione che mi ritorna elementi non ripetuti da una colonna posso usare: unique(nome_colonna). Nel caso di year ritornerà i valori 2010, 2022, 2012, 2013, 2014
ggplot(data = new_dataframe)+
  geom_line(aes(x = seq(1,60,1), y = Beaumont_sales, col="Beaumont"), lwd=1)+
  geom_line(aes(x = seq(1,60,1), y = Bryan_college_sales, col="Bryan-College Station"), lwd=1)+
  geom_line(aes(x = seq(1,60,1), y = Tyler_sales, col="Tyler"), lwd=1)+
  geom_line(aes(x = seq(1,60,1), y = Wichita_sales, col="Wichita Falls"), lwd=1)+
  labs(x="mesi",
       y="sales",
       title="Serie storiche")+
    scale_color_manual(
      name   = 'Legenda',
      breaks = c('Beaumont', 'Bryan-College Station', 'Tyler', 'Wichita Falls'),
      values = c("red", "green3", "blue", "pink"),
      labels = c('Beaumont', 'Bryan-College Station', 'Tyler', 'Wichita Falls'))

# Wichita Falls non ha subito incrementi nelle vendite negli anni e la sua bìvariabilità è rimasta la stessa
# Beaumont ha visto un aumento nelle vendite col passare degli anni ma non della variabilita  
# Al contratio invece Bryan-College Station, Tyler hanno visto, col passare degli anni, sia un aumento nella quantità delle vendite sia della loro stessa variabilità
# città con meno vendite (in media): Wichita Falls
# città con più vendite (in media): Tyler
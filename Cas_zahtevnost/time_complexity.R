# PRIKAZ CASOVNE ZAHTEVNOSTI OBEH ALGORITMOV ZA ISKANJE NAJCENEJSEGA POPOLNEGA
# PRIREJANJA V POLNEM DVODELNEM GRAFU

require(dplyr)
require(ggplot2)
require(ggthemes)

# Casi, ki smo jih dobili ob izvedbi algoritma madzarska_metoda, za n velikosti
# 10,20,...,200.
casMM <- c(0.00131033287048,0.0051107673645,0.00961992263794,0.0129133987427,
           0.0215418434143,0.0332087230682,0.0514039993286,0.056156206131,
           0.0666558265686,0.0900566101074,0.109055233002,0.160238027573,
           0.157670164108,0.207566022873,0.199271011353,0.199807167053,
           0.263862609863,0.256449985504,0.349158620834,0.383899593353)

# Casi, ki smo jih dobili ob izvedbi algoritma MinWeightedMatching, za n velikosti
# 10,20,...,200.
casILP <- c(0.00403886413574,0.0157022380829,0.0378730297089,0.08642578125,
            0.133634376526,0.212146186829,0.299379587173,0.499653577805,
            0.606580591202,0.823849582672,1.08954839706,1.44898543358,
            1.70096039772,2.04873380661,2.44853239059,3.08280739784,
            3.40836420059,4.14003000259,5.63451480865,6.13996081352)

# Sestavimo tabelo podatkov:
velikost <-seq(10,200,10)
podatki <- data_frame(n = rep(velikost,2), cas = c(casMM,casILP), 
                      Algoritem = c(rep("Madzarska metoda",20), rep("ILP",20)))

# Na en graf narisemo casovno zahtevnost obeh algoritmov:
grafMM <- ggplot(podatki, aes(x=n, y=cas, colour=Algoritem)) +
  geom_point() + geom_line() + 
  xlab("Velikost matrike (nxn)")+
  ylab("Cas (v sekundah)") + 
  ggtitle("Casovna zahtevnost algoritmov")+
  theme(plot.title = element_text(hjust = 0.5))+
  theme_bw()

grafMM

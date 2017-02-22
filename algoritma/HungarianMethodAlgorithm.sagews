︠6be31baa-9368-4d64-8187-ccfa9e0a83c8︠
## ALGORITMI, KI SO POTREBNI ZA IZVEDBO MADZARSKE METODE:

#v fazi 4.2, ko je y prirejen v M z nekim z-jem, damo z v S in y v T. Popravimo slacky tako, da y odstranimo iz slacky-ja, za ostale y pa pogledamo, ce se je njihova vrednost spremenila (torej ce se je minimum spremenil):

def slacky_spr (lx,ly,A,slacky,z,y):
    slacky.pop(y)
    for i in slacky.keys():
        a = lx[z] + ly[i] - A[z,i]
        if a < slacky[i]:
            slacky[i] = a
    return(slacky)





#izvedemo bfs, da dobimo predhodnike v drevesu Gt, da nato povecamo pot, ko ze imamo y iz Y, ki je prost, (slo bi tudi brez, a je tako bolj pregledno). zacnemo v y.

def bfs(Gt,y):
    L = [y]
    predhodnik = dict()
    while len(L) != 0:
        Novi = []
        for i in L:
            for j in Gt.neighbors(i):
                if j not in predhodnik.keys():
                    predhodnik[j] = i
                    Novi.append(j)
        L = Novi
    return(predhodnik)





#s tem algoritmom povecujemo: Gt je nase drevo, glede na katerega bomo povecali M, y je iz Y in ni prirejen v M, u je iz X in je nase zacetno prosto vozlisce. Sedaj povecamo pot iz u do y:

def augment(Gt,M,y,u):
    predhodnik = bfs(Gt,y)
    i = 0 #namen stevca je, da vemo, ali smo na strani X ali Y. V prvem primeru dodamo prirejeno vozlisce v M, v drugem pa odstranimo. zacnemo v u
    while y not in predhodnik[u]:
        if (i/2).is_integer():
            M[int(u[1:])] = int(predhodnik[u][1:])
        else:
            M[int(predhodnik[u][1:])] = None
        u = predhodnik[u]
        i = i+1
    M[int(u[1:])] = int(y[1:])
    return(M)





#3. in 4. faza glavnega algoritma (MM):

def nov_match (lx,ly,S,Nl,T,slacky,A,M,Gt,u,n):
    #3. faza:
    if len(Nl) == len(T):
        #iscemo nove sosede za x iz S (t.j. mnozice Nl). najdemo minimalno vrednost slacky in ustrezne y:
        delta = slacky.values()[0]
        dodatna_vozl = []
        for (i,j) in slacky.items():
            if j < delta:
                delta = j
                dodatna_vozl = [i]
            elif j == delta:
                dodatna_vozl.append(i)

        #spremenimo lx in ly, ker se je lx spremenil v lx-delta za vozlisca iz S, se tudi slacky zmanjsa za delta:
        for i in S:
            lx[i] = lx[i] - delta
        for j in T:
            ly[j] = ly[j] + delta
        for d in slacky.keys():
            slacky[d] = slacky[d] - delta

        #dobime nove sosede za mnozico sosedov Nl (to so ravno tisti y iz slacky, ki so dali minimum):
        for i in dodatna_vozl:
            Nl.add(i)

    #4. faza:
    for y in Nl.difference(T): #izbere neko vozlisce y, ki je sosed od S, pa ga se nismo obiskali (torej ni v T):
        break
    #ce je y prirejen v M, se naredi opravi faza 4.2. najprej preverimo, ce je y sploh prirejen v M (kar nam pove stavek if j==y):
    for (i,j) in M.items() :
        if j == y:
            Gt.add_edge("x"+str(i),"y"+str(y)) #y je torej prirejen, dodamo i,y v drevo, kjer je i,y povezava v M (i,y sta krajisca te povezave)
            for g in S: #sedaj najdemo vozlisce iz S, ki je sosed y, kajti tako smo sploh prisli do y, drevo pa se tedaj spet poveze (zadostuje, da najdemo enega takega, potem pa damo povezavo v drevo)
                if lx[g] + ly[y] == A[g,y]:
                    Gt.add_edge("x"+str(g),"y"+str(y))
                    break
            S.add(i) #v S damo i in v T y, kjer sta to prirejeni vozlisci v M (ti vozlisci smo ze obiskali)
            T.add(y)
            slacky = slacky_spr(lx,ly,A,slacky,i,y) #popravimo slacky, ker je sedaj eno vozlisce slo iz T, ravno tako pa se je povecal S za eno vozlisce
            for r in range(n): #dodamo sosede od i v Nl.
                if lx[i] + ly[r] == A[i,r]:
                    Nl.add(r)
            return nov_match(lx,ly,S,Nl,T,slacky,A,M,Gt,u,n) #ker y ni bil prost, nismo mogli najti povecujoce poti, zato ponovimo postopek

    #4.1. faza: ce je y prost (sedaj lahko povecamo M), je pa vseeno povezan z nekim vozliscem iz S, to povezavo dodamo v drevo (potrebujemo samo eno povezavo, da je graf povezan):
    for m in S:
        if lx[m] + ly[y] == A[m,y]:
            Gt.add_edge("x"+str(m),"y"+str(y))
            break
    #vrnemo povecano prirejanje M ter lx, ly (kajti tudi vrednost slednjih vedno ohranjamo)
    return (augment(Gt,M,"y"+str(y),"x"+str(u)),lx,ly)





# GLAVNI ALGORITEM:
# iskanje najcenejsega popolnega prirejanja v polnem dvodelnem grafu G=(V,E) (V=X∪Y in X∩Y=∅ ter E⊆X×Y):

def madzarska_metoda(B):
    n = B.nrows()
    A = -B #algoritem dela za najvecje utezeno prirejanje, vendar mi hocemo izracunati najcenejse utezeno prirejanje, zato matriko negiramo.
    lx = dict() #vrednosti vozlisc iz mnozice X so lx
    ly = dict() #vrednosti vozlisc iz mnozice Y so ly
    M = dict() # M je prirejanje v grafu G

    #v naslednji zanki bomo izvedli zacetno oznacevanje, in sicer: lx je enak maximalni vrednosti utezi v posamezni vrstici, ly je pa enak 0 za vsako vozlisce (vedno velja: lx+ly>=w(x,y)), M je pa zacetno prirejanje (na zacetku ni nobenega y v prirejanju)
    for i in range(n):
        d = tuple(A[i,:])
        lx[i] = max(d[0])
        ly[i] = 0
        M[i] = None
    while None in M.values(): #dokler nimamo popolnega prirejanja (to bo natanko takrat, ko bo prirejanje dolgo dolzine n): S bo mnozica vozlisc iz X, ki smo jih ze obiskali, T pa tistih iz Y, ki smo jih ze obiskali. u je prosto vozlisce v X (ni krajisce v prirejanju)
        S = set()
        T = set()
        for (i,j) in M.items():
            if j == None:
                u = i
                S.add(u)
                break
        Nl = set() #Nl je mnozica sosedov za S⊆V (najprej je v S samo u)
        for i in range(n):
            if lx[u] + ly[i] == A[u,i]:
                Nl.add(i)

        #sedaj pa naredimo seznam slacky, ki ima za vsak y iz Y\T minimalno vrednost/tezo izracunano po vseh u-jih iz S (rabimo za to, da ko velja, da je Nl(S)=T, lahko dobimo nove povezave v M):
        slacky = dict()
        for i in range(n):
            slacky[i] = lx[u] + ly[i] - A[u,i]

        Gt = Graph() #to bo nase drevo povecujocih poti
        (M,lx,ly)= nov_match(lx,ly,S,Nl,T,slacky,A,M,Gt,u,n) #vrnemo prirejanje M, lx in ly pa tudi vedno potrebujemo spremenjena.

    #sedaj se (nekoliko lepse) izpisemo prirejanje ter dolocimo njegovo vrednost:
    vrednost = 0
    prirejanje = []
    for i,j in M.items():
        prirejanje.append(("x"+str(i), "y"+str(j), B[i,j])) # povezavi i-j iz prirejanja dodamo njeno tezo iz prvotne matrike B, ker iscemo najvecje utezeno prirejanje
        vrednost = vrednost + B[i,j] #dolocimo koncno vrednost prirejanja, tako da sestejemo vse utezi na povezavah v prirejanju
    return(prirejanje,vrednost)


## Resitev Madzarske metode, za matriko A velikosti nxn, kjer so elementi celostevilski iz intervala [h,k]:
# n= 10
# h= 0
# k= 100
# A = Matrix([[(int(random()*(k-h+1))+h) for j in range(n)] for i in range(n)])
# madzarska_metoda(A)


## Časi resevanja Madzarske metode, ko povecujemo n (10,20,...,200), kjer 10x ponovimo izvedbo ter vzamemo povprecen cas:
# for n in range(10,201,10):
#     h = 0
#     k = 100
#     A = Matrix([[(int(random()*(k-h+1))+h) for j in range(n)] for i in range(n)])
#     %timeit(repeat=10, seconds=True) madzarska_metoda(A)










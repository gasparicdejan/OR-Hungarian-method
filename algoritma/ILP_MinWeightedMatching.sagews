︠0586f845-565a-4ad8-8b14-7b7a18b14335︠
# Celostevilski linearni program (CLI) za iskanje najcenejsega popolnega prirejanja v polnem dvodelnem grafu G=(V,E) (V=X∪Y in X∩Y=∅ ter E⊆X×Y):

def MinWeightedMatching(A):
    n = A.ncols()
    p = MixedIntegerLinearProgram(maximization=False)
    x = p.new_variable(binary=True) #x[i,j]=1 natanko takrat, ko povezava i-j v prirejanju, sicer je x[i,j]=0

    p.set_objective(sum(sum(A[i, j]*x[i, j] for j in range(n)) for i in range(n))) #minimiziramo tezo prirejanja
    for i in range(n):
        p.add_constraint(sum(x[i, j] for j in range(n)) == 1) #vsako vozlisce iz X ima natanko enega soseda v Y (v vsaki vrstici je natanko en x[i,j] = 1)
        p.add_constraint(sum(x[j, i] for j in range(n)) == 1) #vsako vozlisce iz Y ima natanko enega soseda v X (v vsakem stolpcu je natanko en x[i,j] = 1)

    teza = p.solve()
    prirejanje = p.get_values(x)

    #v resitev dodamo samo tiste povezave, za katere je vrednost enaka 1 (torej ko gremo s for zanko čez prirejanje.items(), je i indeks (torej povezava) in j vrednost (torej 0 ali 1):
    resitev = [i for i, j in prirejanje.items() if j == 1]
    return(resitev, teza)


## Resitev ILP, za matriko A velikosti nxn, kjer so elementi celostevilski iz intervala [h,k]:
# n = 10
# h = 0
# k = 100
# A = Matrix([[(int(random()*(k-h+1))+h) for j in range(n)] for i in range(n)])
# MinWeightedMatching(A)

## Časi resevanja ILP, ko povecujemo n (10,20,...,200), kjer 10x ponovimo izvedbo ter vzamemo povprecen cas:
# for n in range(10,201,10):
#     h = 0
#     k = 100
#     A = Matrix([[(int(random()*(k-h+1))+h) for j in range(n)] for i in range(n)])
#     %timeit(repeat=10, seconds=True) MinWeightedMatching(A)










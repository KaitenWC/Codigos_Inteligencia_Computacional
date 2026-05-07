from neuronio import neuronio

x = [0, 0]
# porta = 'Or'
porta = 'NAND'

if porta == 'Or':
    w = [1, 1]
    bias = -1
elif porta == 'NAND':
    w = [-1, -1]
    bias = 1

saida = neuronio(x, w, bias)
print(saida)

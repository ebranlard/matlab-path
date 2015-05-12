import sys
import sympy 

from collections import defaultdict

class GenerateSymbols(defaultdict):
  def __missing__(self, key):
    return sympy.Symbol(key)

if __name__ == '__main__':
    d= GenerateSymbols()    
    eq = sys.argv[1]
    #sys.stdout.write(str(sympy.latex(sympy.simplify(eval(eq,d)))))
    sys.stdout.write(str(sympy.latex(eval(eq,d))))

import sys
from antlr4 import *
from logo3dLexer import logo3dLexer
from logo3dParser import logo3dParser
from visitor import visitor

visitorEval = visitor()

input_stream = FileStream(sys.argv[1])
 
lexer = logo3dLexer(input_stream)
token_stream = CommonTokenStream(lexer)
parser = logo3dParser(token_stream)
tree = parser.root()

res = visitorEval.visit(tree)

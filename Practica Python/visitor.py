# Generated from logo3d.g by ANTLR 4.7.2
#from turtle3d import Turtle3D
import turtle3d

if __name__ is not None and "." in __name__:
    from .logo3dParser import logo3dParser
    from .logo3dVisitor import ExprVisitor
else:
    from logo3dParser import logo3dParser
    from logo3dVisitor import logo3dVisitor

# This class defines a complete generic visitor for a parse tree produced by logo3dParser.

class visitor(logo3dVisitor):

    def __init__(self):
        self.variables = {}
        self.programas = {}
        self.obj = turtle3d.Turtle3D()
        self.obj.initProg()
        self.listo = True

    # Visit a parse tree produced by logo3dParser#root.
    def visitRoot(self, ctx:logo3dParser.RootContext):

        self.visitChildren(ctx)

    def visitFunc(self, ctx:logo3dParser.FuncContext):

        l = [x for x in ctx.getChildren()]

        nombreFunc = str(l[1].getText())

        listaParams = self.visit(l[2])

        n = len(l)
        body = l[4:n-1]
        tuplaDic = (listaParams, body)

        if nombreFunc in self.programas :
            raise Exception("Procedimineto ya definido anteriormente")

        self.programas[nombreFunc] = tuplaDic

        if l[1].getText() == "main":
            self.listo = False
            return self.visitChildren(ctx)

    def visitExpr(self, ctx:logo3dParser.ExprContext):

        l = [x for x in ctx.getChildren()]

        return self.visitChildren(ctx)


    def visitFuncionauxiliar(self, ctx:logo3dParser.FuncionauxiliarContext):

        l = [x for x in ctx.getChildren()]

        nombreFunc = l[0].getText()
        listaParams = self.visit(l[1])

        if nombreFunc in self.programas :

            (params,body) = self.programas[nombreFunc]

        else:

            raise Exception("no existe la funcion " + nombreFunc)


        size = len(params)
        size2 = len(listaParams)

        if (size != size2):
            raise Exception("Parametros incorrectos")

        for i in range (0, size):
            nom = params[i]
            valor = listaParams[i]
            self.variables[nom] = valor

        for expr in body:
            self.visit(expr)

    def visitListParametros(self, ctx:logo3dParser.ListParametrosContext):
        l = [x for x in ctx.getChildren()]

        aux = len(l)
        parametros = []

        if self.listo == False:

            if aux > 2:

                i = 1
                while i < aux:
                    if l[i].getSymbol().type == logo3dParser.VAR:

                        nom = l[i].getText()
                        param = self.variables[nom]
                        parametros.append(param)

                    else:

                        param = l[i].getText()
                        parametros.append(param)

                    i = i + 2

        else:
            if aux > 2:
                i = 1
                while i < aux:
                    param = l[i].getText()
                    parametros.append(param)

                    i = i + 2

        return parametros


    def visitLlamada(self, ctx:logo3dParser.LlamadaContext):
        l = [x for x in ctx.getChildren()]

        self.obj.esperar()

        if l[0].getText() == "home":
            self.obj.home()

        elif l[0].getText() == "show":
            self.obj.showRastro()

        elif l[0].getText() == "hide":
            self.obj.hideRastro()

        elif l[0].getText() == "color":
            col1 = float(l[2].getText())
            col2 = float(l[4].getText())
            col3 = float(l[6].getText())
            self.obj.changeCol(col1, col2, col3)

        else:
            if l[2].getSymbol().type == logo3dParser.ENTERO :

                param =  float(l[2].getText())

            if l[2].getSymbol().type == logo3dParser.VAR :

                aux = l[2].getText()
                aux1 = self.variables[aux]
                param = float(aux1)

            if l[0].getText() == "forward":

                self.obj.forward(param)

            if l[0].getText() == "backward":

                self.obj.backward(param)

            if l[0].getText() == "up":

                self.obj.up(param)

            if l[0].getText() == "down":

                self.obj.down(param)

            if l[0].getText() == "right":

                self.obj.right(param)

            if l[0].getText() == "left":

                self.obj.left(param)

    def visitLoopwhile(self, ctx:logo3dParser.LoopwhileContext):
        l = [x for x in ctx.getChildren()]

        condicion = self.visit(l[1])
        while(condicion):

            self.visit(l[3])
            condicion = self.visit(l[1])

    def visitBuclefor(self, ctx:logo3dParser.BucleforContext):
        l = [x for x in ctx.getChildren()]

        variable = l[1].getText()
        indice = variable
        ini = int(l[3].getText())

        self.variables[variable] = ini
        aux = ini
        fin = int(l[5].getText())
        for indice in range(ini,fin):

            self.visit(l[7])
            aux = aux + 1
            self.variables[variable] = aux

    def visitCondicion(self, ctx:logo3dParser.CondicionContext):
        l = [x for x in ctx.getChildren()]

        param = self.visit(l[1])

        if param == True:
            self.visit(l[3])

    def visitEvalua(self, ctx:logo3dParser.EvaluaContext):
        l = [x for x in ctx.getChildren()]

        if len(l) > 1:

            a = self.visit(l[0])
            b = self.visit(l[2])

            if (l[1].getSymbol().type == logo3dParser.EQ):

                return a == b

            if (l[1].getSymbol().type == logo3dParser.MAYOR):

                return a > b

            if (l[1].getSymbol().type == logo3dParser.MENOR):

                return a < b

            if (l[1].getSymbol().type == logo3dParser.NQ):

                return a != b

            if (l[1].getSymbol().type == logo3dParser.EQMAYOR):

                return a >= b

            if (l[1].getSymbol().type == logo3dParser.EQMENOR):

                return a <= b

        else:
            if l[0].getSymbol().type == logo3dParser.ENTERO :
                return int(l[0].getText())

            if l[0].getSymbol().type == logo3dParser.VAR :
                aux = l[0].getText()
                aux1 = self.variables[aux]
                return int(aux1)

    def visitAsignacion(self, ctx:logo3dParser.AsignacionContext):
        l = [x for x in ctx.getChildren()]
        #print([str(t) for t in l])
        valorAsig = self.visit(l[2])
        nombreVar = l[0].getText()

        self.variables[nombreVar] = valorAsig

        print("Variable guardada")

    def visitProc(self, ctx:logo3dParser.ProcContext):

        l = [x for x in ctx.getChildren()]
        #print([str(t) for t in l])

        if len(l) > 1:

            a = self.visit(l[0])
            b = self.visit(l[2])

            if (l[1].getSymbol().type == logo3dParser.MAS):

                return float(a) + float(b)
            if (l[1].getSymbol().type == logo3dParser.MENOS):

                return float(a) - float(b)

            if (l[1].getSymbol().type == logo3dParser.POR):

                return float(a) * float(b)

            if (l[1].getSymbol().type == logo3dParser.DIV):

                if b != 0 :
                    return float(a) / float(b)

                else:
                    raise Exception("No se permite la división por cero")

        else:
            if l[0].getSymbol().type == logo3dParser.ENTERO :

                return int(l[0].getText())

            if l[0].getSymbol().type == logo3dParser.VAR :

                aux = l[0].getText()
                aux1 = self.variables[aux]
                return aux1

    def visitAuxiliares(self, ctx:logo3dParser.AuxiliaresContext):
         l = [x for x in ctx.getChildren()]

         if l[0].getSymbol().type == logo3dParser.ENTERO :

             return int(l[0].getText())

         if l[0].getSymbol().type == logo3dParser.VAR :

             aux = l[0].getText()
             aux1 = self.variables[aux]
             return aux1

    def visitLectura(self, ctx:logo3dParser.LecturaContext):
        l = [x for x in ctx.getChildren()]
        print("introduzca el valor")
        valor = input()
        nombreVar = l[1].getText()
        self.variables[nombreVar] = valor

    def visitEscritura(self, ctx:logo3dParser.EscrituraContext):

        l = [x for x in ctx.getChildren()]

        out = self.visit(l[1])
        print("print:" )
        print(out)

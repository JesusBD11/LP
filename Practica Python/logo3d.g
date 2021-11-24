grammar logo3d;

root: func* EOF ;

func: 'PROC' VAR listParametros 'IS' (expr)* 'END' ;

expr : buclefor
      | loopwhile
      | condicion
      | escritura
      | asignacion
      | llamada
      | funcionauxiliar
      | lectura
      | ENTERO
      | VAR
      ;

funcionauxiliar : VAR listParametros ;

llamada : 'forward' '('(ENTERO | VAR)')'
        | 'backward' '('(ENTERO | VAR)')'
        | 'up' '('(ENTERO | VAR)')'
        | 'down' '('(ENTERO | VAR)')'
        | 'right' '('(ENTERO | VAR)')'
        | 'left' '('(ENTERO | VAR)')'
        | 'home' '()'
        | 'hide' '()'
        | 'show' '()'
        | 'color' '('(ENTERO|DEC) ',' (ENTERO|DEC) ',' (ENTERO|DEC)')'
        ;

listParametros: '(' (VAR|ENTERO) (',' (VAR|ENTERO))* ')' ;

asignacion : VAR ':=' proc;

lectura : '>>' VAR ;

condicion : 'IF' evalua 'THEN' cuerpo  'END';

cuerpo: expr* ;

buclefor: 'FOR' VAR 'FROM' ENTERO 'TO' ENTERO 'DO' cuerpo 'END' ;

loopwhile: 'WHILE' evalua 'DO' cuerpo 'END' ;

escritura : '<<' proc ;

auxiliares: VAR | ENTERO ;


proc : proc (POR|DIV) proc
      | proc (MAS|MENOS) proc
      | VAR
      | ENTERO
      ;

evalua : evalua (EQ|NQ|MENOR|MAYOR|EQMAYOR|EQMENOR) evalua
      | ENTERO
      | VAR
      ;


VAR : [A-Za-z] [A-Za-z_$0-9]* ;
ENTERO : [0-9]+ ;
WS : [ \t\r\n]+ -> skip ;
DEC : [0-9]+ POINT [0-9]+ ;
MAS : '+' ;
MENOS : '-' ;
POR : '*' ;
DIV : '/' ;
EQ : '==' ;
NQ: '!=' ;
MENOR: '<' ;
MAYOR: '>' ;
EQMENOR: '<=' ;
EQMAYOR: '>=' ;
POINT       : '.' ;

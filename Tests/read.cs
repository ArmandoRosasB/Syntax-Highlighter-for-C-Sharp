using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//Esto es un comentario

/*
    Esto también es un comentario
*/
namespace Fibonacci {
    class Program {
        static void Main(string[] args) {
            
            int a, b, limite, i, auxiliar; 
            Console.WriteLine("Ingrese el número de numeros de Fibonacci que desea mostrar");
            limite = int.Parse(Console.ReadLine()); 
            a = 0;
            b = 1; 
            for (i = 0; i < limite; i++) {
                auxiliar = a;
                a = b; 
                b = auxiliar + a; 
                Console.WriteLine(a); 
            }
            Console.ReadKey(); 
        }
    }  
}
// Terminé

public class Solution {
    public bool IsValid(string s) {
        List<char> arr = s.ToList();
            
            if(arr.Count == 1 && arr.Count == 0) {
                return false;
            }

            for(int i = 0; i < arr.Count; i++) {
                if(arr[i].Equals('}')) {
                    if(i != 0 && arr[i - 1].Equals('{')) {
                        arr.RemoveAt(i - 1);
                        arr.RemoveAt(i - 1);
                        i -= 2;
                    } else {
                        return false;
                    }
                } else if (arr[i].Equals(')')) {
                    if (i != 0 && arr[i - 1].Equals('(')) {
                        arr.RemoveAt(i - 1);
                        arr.RemoveAt(i - 1);
                        i -= 2;
                    } else {
                        return false;
                    }
                } else if (arr[i].Equals(']')) {
                    if (i != 0 && arr[i - 1].Equals('[')) {
                        arr.RemoveAt(i - 1);
                        arr.RemoveAt(i - 1);
                        i -= 2;
                    } else {
                        return false;
                    }
                }
            }
            
            if(arr.Count == 0) {
                return true;
            }
            return false;
        }
    }

  class ValidParentheses {
       public static void main(string[] args) {
            var solution = new Solution();

            if (solution.IsValid(Console.ReadLine())) {
                Console.WriteLine("valid");
            } else {
                Console.WriteLine("invalid");
            }
        }
    }


<title> Operadores </title>

[X]  <subtitle> Aritmeticos </subtitle>

        Incremento: ++
            Posfijo: ++i    regex => / ^(\+\+)\s*([A-z]{1})(\w)*$ /
            Prefijo: i++    regex => / ^([A-z]{1})(\w)*\s*(\+\+)$ /


        Decremento: --
            Posfijo: --i    regex => / ^(\-\-)\s*([A-z]{1})(\w)*$ /
            Prefijo: i--    regex => / ^([A-z]{1})(\w)*\s*(\-\-)$ /

        Unario Mas: +       regex => / ^(\+)\s*([A-z]{1})(\w)*$ /
            Ej. +i          
        Unario Menos: -     regex => / ^(\-)\s*([A-z]{1})(\w)*$ /
            Ej. -i      


        Multiplicacion: *   regex => / \* /
        Division: /         regex => / \/ /
        Modulo: %           regex => / \% /
        Suma: +             regex => / \+ /
        Resta: -            regex => / \- /


[X?]  <subtitle> Comparacion </subtitle>
        Menor que: <                regex => \/ < /            
        Mayor que: >                regex => \/ > /
        Menor o igual que: <=       regex => \/ <= /
        Mayor o igual que: >=       regex => \/ >= /

[X?]  <subtitle> Logicos Booleanos </subtitle>

        Negacion Logica: !          regex => / \! /  
            Ej. !a

        AND logico: &                   regex => / \& / 
        OR exclusivo logico: ^          regex => / \^ / 
        OR logico: |                    regex => / \| / 
        AND logico condicional: &&      regex => / \(&&) / 
        OR logico condicional: ||       regex => / \(||) / 


[!X]    <subtitle> Desplazamiento </subtitle>
        Complemento bit a bit: ~                        regex => / \~ / 
        Desplazamiento a la izquierda: <<               regex => / \(<<) / 
        Desplazamieto a la derecha: >>                  regex => / \(>>) / 
        Desplazamiento a la derecha sin signo: >>>      regex => / \(>>>) / 


[!X]  <subtitle> Igualdad </subtitle>
        Igualdad: ==        regex => / \== / 
        Desigualdad: !=     regex => / \!= / 

[X]  <title> Parentesis </title>
        Parentesis: ()      regex => / \( /     regex => / \) /
        Llaves: []          regex => / \[ /     regex => / \] /
        Corchetes {}        regex => / \{ /     regex => / \} /

[X]  <title> Comillas </title>
     Simples: ''         regex => /'([^"]){1}'/
     Dobles: ""          regex => /"([^"])*"/

[X]  <title> Comentarios </title>
    Comentario unilinea: //         regex => /^(\/){2}(\w|\W)*$/
                                             /^(\/\/)(\w|\W|\s)*(\<br\>)$/
    Comentario multilinea: /**/     regex => / (\/\*)([^(\*\/)])*\*\/ /


<title> Palabras reservadas </title>
 - C# cuenta con 76 palabras reservadas

[X]     <subtitle> Tipos de datos y modificadores </subtitle>
        1. int             regex => /^(\s)*int$/
        2. uint            regex => /^(\s)*uint$/
        3. long            regex => /^(\s)*long$/
        4. ulong           regex => /^(\s)*ulong$/
        5. float           regex => /^(\s)*float$/
        6. double          regex => /^(\s)*double$/
        7. decimal         regex => /^(\s)*decimal$/   
        8. string          regex => /^(\s)*string$/
        9. char            regex => /^(\s)*char$/
        10. bool           regex => /^(\s)*bool$/
        11. short          regex => /^(\s)*short$/
        12. ushort         regex => /^(\s)*ushort$/
        13. byte           regex => /^(\s)*byte$/
        14. sbyte          regex => /^(\s)*sbyte$/
        15. stackalloc     regex => /^(\s)*stackalloc$/
        16. fixed          regex => /^(\s)*fixed$/
        17. params         regex => /^(\s)*params$/
        18. ref            regex => /^(\s)*ref$/
        19. internal       regex => /^(\s)*internal$/
        20. var            regex => /^(\s)*var$/

[X]  <subtitle> Condicionales </subtitle>
     21. if
     22. else
     23. switch
     24. case
     25. default

[X]  <subtitle> Ciclos </subtitle>
     26. do
     27. while
     28. for
     29. foreach

[X]  <subtitle> Instrucciones jump </subtitle>
     30. return  regex => /^\s*return\s*\b/
     31. continue  regex => /^\s*continue\s*\b/
     32. break  regex => /^\s*break\s*\b/
     33. goto

[X]  <subtitle> Nulo </subtitle>
     34. null

[X]  <subtitle> Booleanos </subtitle>
     34. true
     35. false

[X]  <subtitle> Clases, metodos y mas </subtitle>
     36. public
     37. private
     38. static
     39. abstract
     40. virtual
     41. protected
     42. class
     43. this
     44. event
     45. base
     46. explicit
     47. implicit
     48. operator
     49. extern
     50. object
     51. override
     52. readonly
     53. unsafe
     54. delegate
     55. sealed
     56. void

[X]  <subtitle> Estructuras </subtitle>
     57. const
     58. struct
     59. enum
     60. new
     61. interface

[X]  <subtitle> Bloques </subtitle>
     62. try  regex => /^\s*try/
     63. catch
     64. throw
     65. finally
     66. checked
     67. unchecked
     68. lock

[]  <subtitle> Tipo y tamaño </subtitle>
     69. sizeof
     70. typeof

    <subtitle> Is as </subtitle>
     71. is
     72. as

[]    <subtitle> Entrada y salida </subtitle>
     73. in
     74. out

[X]  <subtitle> Using y namespace </subtitle>
     75. using  regex => /^using$/
     76. namespace  regex => /^namespace$/

[?]      <title> Identificadores válidos </title>
        - Deben comenzar con letra o underscore
        - No deben ser iguales a las palabras reservadas
        - No se aceptan inicios con números o signos
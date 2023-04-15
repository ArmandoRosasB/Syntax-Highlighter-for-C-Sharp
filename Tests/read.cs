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
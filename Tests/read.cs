using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
//Esto es un comentario
/*
Esto tambien es un comentario
*/
namespace Fibonacci
{
    class Program
    {
        static void Main(string[] args)
        {
            
            int a, b, limite, i, auxiliar; 
            Console.WriteLine("Ingrese el número de numeros de Fibonacci que desea mostrar");
            limite = int.Parse(Console.ReadLine()); 
            a = 0;
            b = 1; 
            for (i = 0; i < limite; i++)  
            {
                auxiliar = a;
                a = b; 
                b = auxiliar + a; 
                Console.WriteLine(a); 
            }
            Console.ReadKey(); 
        }
    }
    // Termine
}
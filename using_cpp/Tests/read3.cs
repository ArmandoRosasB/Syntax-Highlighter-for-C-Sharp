// ****************************************************************
// ****************************************************************
// **                                                            **
// **                                                            **
// **               Criba de Eratóstenes en C#                   **
// **                       By Hendrix                           **
// **                                                            **
// **                                                            **
// ****************************************************************
// ****************************************************************
    
using System;
using System.Collections.Generic;
using System.Text;
    
namespace ConsoleApplication1
{
    class Program
    {
        public static int max;
    
        static void Main(string[] args)
        {
            int nume;
    
            Console.WriteLine("Introduce el numero hasta donde se va a buscar");
            max = Convert.ToInt32(Console.ReadLine());
    
            int[,] num = new int[max, 2];
            string primos = "";
    
            for (int i = 2; i < max; i++) //Rellenamos el array
            {
                num[i, 0] = i;
                num[i, 1] = 0;
            }
    
            for (int i = 2; i < max; i++)
            {
                if (num[i, 1] == 0)
                {
                    primos = primos + i.ToString() + ",";
                    for (int e = 1; e < max + 1; e++)
                    {
                        nume = num[i, 0];
                        nume = nume * e;
                        if (nume < max)
                        {
                            num[nume, 1] = 1;
                        }
                        else
                        {
                            break;
                        }
                    }
                }
            }
    
            primos = primos.Substring(0, primos.Length - 1);
            Console.WriteLine("Numeros primos encontrados: {0}", primos);
            Console.Read();
    
        }
    }
}

// REFERENCE: https://foro.elhacker.net/net/c_criba_de_eratostenes-t182358.0.html

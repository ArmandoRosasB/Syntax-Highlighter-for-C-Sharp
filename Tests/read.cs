/*
    Hello World 
        --> Random tests
*/

void DisplayCharacter(char ch) {
    if (char.IsUpper(ch)) {
        Console.WriteLine($"An uppercase letter: {ch}");
    } else if (char.IsLower(ch)) {
        Console.WriteLine($"A lowercase letter: {ch}");
    } else if (char.IsDigit(ch)) {
        Console.WriteLine($"A digit: {ch}");
    } else {
        Console.WriteLine($"Not alphanumeric character: {ch}");
    }
}

namespace HelloWorld {
    class Hello {         
        static void Main(string[] args) {
            System.Console.WriteLine("Hello World!");
            System.Console.WriteLine("Goodbye");
        }

        static void tests() {
            // Condicionales
            DisplayCharacter(',');
        }
    }
}

// end-of-file

using 

namespace
using uhdkfsh using unsing
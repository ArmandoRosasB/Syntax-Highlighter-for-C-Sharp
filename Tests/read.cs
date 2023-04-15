using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

/*
Codigo de prueba 

Autores del resaltador:
    Ramona Najera Fuentes
    Jose Armando Rosas Balderas
*/

// Fibonacci
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


// Validar parentesis
public class SolutionOne {
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
            var solution = new SolutionOne();

            if (solution.IsValid(Console.ReadLine())) {
                Console.WriteLine("valid");
            } else {
                Console.WriteLine("invalid");
            }
        }
    }

    // Validar palindromo
    public class SolutionTwo {
    public bool IsPalindrome(string s) {

      System.Text.RegularExpressions.Regex rgx = 
            new System.Text.RegularExpressions.Regex("[^a-zA-Z0-9]");
      s = rgx.Replace(s.ToLower(),"");
      int l = 0;
      int r = s.Length - 1;

      while(l<=r)
      {
        if (s[l] == s[r])
        {
          l++;
          r--;
        }
        else 
          return false;
      }
      return true;
    }
}

// Remover enesimo numero de una lista

/*
  Definition for singly-linked list.
  public class ListNode {
      public int val;
      public ListNode next;
      public ListNode(int val=0, ListNode next=null) {
          this.val = val;
          this.next = next;
      }
  }
 */
 
public class Solution {
    public ListNode RemoveNthFromEnd(ListNode head, int n) {
        if (head == null) {
            return null;
        }

        ListNode dummy = new ListNode(0, head);
        ListNode fast = head;
        ListNode slow = dummy;

        while (n > 0 && fast != null) {
            fast = fast.next;
            n -= 1;
        }

        if (n > 0) {
            throw new ArgumentException("n must be less than or equal to length of linked list");
        }

        while (fast != null) {
            slow = slow.next;
            fast = fast.next;
        }

        slow.next = slow.next.next;
        return dummy.next;
    }
}
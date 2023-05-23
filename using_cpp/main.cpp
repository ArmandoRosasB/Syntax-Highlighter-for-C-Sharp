#include <iostream>
#include <fstream>
#include <regex>

using namespace std;

int main(int argc, char* argv[]) {
    ifstream inputFile;
    ofstream outputHTML;
    ofstream outputStyles;

    string html;

    string header = "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><meta http-equiv='X-UA-Compatible' content='IE=edge'><meta name='viewport' content='width=device-width, initial-scale=1.0'><link rel='stylesheet' href='styles.css'><title>C# code editor</title></head><body><pre>";
    string footer = "</pre></body></html>";
    string styles = "body{background:#333333;color:#FDFFFC;width: 90vw} .cadena{color:rgb(236, 203, 11);} .cadena span{color:rgb(236, 203, 11);} .use_namespc{color:#F71735;} .condicionales{color:#F71735;} .comentarios{color:rgb(190, 190, 190);} .comentarios span{color:rgb(190, 190, 190);}  .operador{color:#F15156;} .tipos{color:#3edff5;font-style:italic;} .tipos span{color:#00BCD4;font-style:italic;} .ciclos{color:#F71735;} .parentheses{color:#CDDC39;} .jump{color:magenta;} .flag{color:#4A8FE7;} .nulo {color:rebeccapurple;font-style:italic;} .definition{color:#FF9F1C;} .oop{color:#E82164;} .bloques{color:#9C27B0;} .type_tam{color:#CDDC39;} .isas{color:#F71735;} .in_out{color:#F71735;}";
    
    if(argc != 2) {
        cout << "ERROR Appropiate format: ./app cSharpFIle" << endl;
        return -1;
    }

    outputStyles.open("styles.css", ios::out);
    outputStyles << styles;

    inputFile.open(argv[1], ios::in);

    html = header;
        
    string aux, cs = "";
    while(!inputFile.eof()) {
        getline(inputFile, aux);
        cs += aux;
        cs += " <br> ";
    }

    // Secuencial
    regex strings("((\")([^(\")])*(\"))|((\')([^\"])?(\'))");
    cs = regex_replace(cs, strings, "<span class='cadena'>$&</span>");

    regex use_namespc("\\busing\\b|\\bnamespace\\b"); // |using
    cs = regex_replace(cs, use_namespc, "<span class='use_namespc'>$&</span>");

    regex ciclos("\\bdo\\b|\\bwhile\\b|\\bfor\\b|\\bforeach\\b");
    cs = regex_replace(cs, ciclos, "<span class='ciclos'>$&</span>");

    regex comentarios("([/][*][^*/]*[*][/])|([/][/][^(<)]*)");
    cs = regex_replace(cs, comentarios, "<span class='comentarios'>$&</span>");

    regex condicionales("\\bif\\b|\\belse\\b|\\bswitch\\b|\\bcase\\b|\\bdefault\\b");
    cs = regex_replace(cs, condicionales, "<span class='condicionales'>$&</span>");

    regex operadores("\\+|\\-|\\%|&{1}|\\|{1}|\\^{1}|\\*{1}|/{1}(?!span)|<{1}(?!(span|/span|br))|!|\\b\\~\\b"); //|(?<!span)(?<!')(?<!br)>{1}|(?<!class)={1}
    cs = regex_replace(cs, operadores, "<span class='operador'>$&</span>");
    
    regex tipos("\\bint\\b|\\buint\\b|\\bfloat\\b|\\bdouble\\b|\\blong\\b|\\bulong\\b|\\bdecimal\\b|\\bstring\\b|\\bchar\\b|\\bbool\\b|\\bshort\\b|\\bushort\\b|\\bbyte\\b|\\bsbyte\\b|\\bparams\\b|\\bref\\b|\\binternal\\b|\\bstackalloc\\b|\\bfixed\\b|\\bvar\\b");
    cs = regex_replace(cs, tipos, "<span class='tipos'>$&</span>");
    
    regex parentesis("[(]|[)]|[[]|[\\]]|[{]|[}]");
    cs = regex_replace(cs, parentesis, "<span class='parentheses'>$&</span>");

    regex jump("\\breturn(;)?\\b|\\bcontinue(;)?\\b|\\bbreak(;)?\\b|\\bgoto\\b");
    cs = regex_replace(cs, jump, "<span class='jump'>$&</span>");

    regex flag("\\btrue\\b|\\bfalse\\b");
    cs = regex_replace(cs, flag, "<span class='flag'>$&</span>");

    regex nulo("\\bnull\\b");
    cs = regex_replace(cs, nulo, "<span class='nulo'>$&</span>");

    regex classes("\\bpublic\\b|\\bstatic\\b|\\bprivate\\b|\\bvirtual\\b|\\babstract\\b|\\bprotected\\b|\\bclass\\b[^=]|\\bthis\\b|\\bevent\\b|\\bbase\\b|\\bexplicit\\b|\\bimplicit\\b|\\boperator\\b|\\bextern\\b|\\bobject\\b|\\boverride\\b|\\breadonly\\b|\\bunsafe\\b|\\bdelegate\\b|\\bsealed\\b|\\bvoid\\b");
    cs = regex_replace(cs, classes, "<span class='oop'>$&</span>");

    regex estructuras("\\bconst\\b|\\bstruct\\b|\\benum|\\bnew\\b|\\binterface\\b");
    cs = regex_replace(cs, estructuras, "<span class='definition'>$&</span>");

    regex bloques("\\btry\\b|\\bcatch\\b|\\bthrow\\b|\\bfinally\\b|\\bchecked\\b|\\bunchecked\\b|\\block\\b");
    cs = regex_replace(cs, bloques, "<span class='bloques'>$&</span>");

    regex type_tam("\\bsizeof\\b|\\btypeof\\b");
    cs = regex_replace(cs, type_tam, "<span class='type_tam'>$&</span>");

    regex in_out("\\bout\\b|\\bin\\b");
    cs = regex_replace(cs, in_out, "<span class='in_out'>$&</span>");

    regex is_as("\\bis\\b|\\bas\\b");
    cs = regex_replace(cs, is_as, "<span class='isas'>$&</span>");

    regex methods("\\.{1}\\w+[^(<]");
    cs = regex_replace(cs, methods, "<span class='parentheses'>$&</span>");

    html += cs;
    html += footer;

    outputHTML.open("index.html", ios::out);
    outputHTML << html;

    outputHTML.close();
    outputStyles.close();
    inputFile.close();
}

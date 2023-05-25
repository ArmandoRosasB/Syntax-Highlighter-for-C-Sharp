/*
    Resaltador de sintaxis en C++

    Autores:
        José Armando Rosas Balderas
        Ramona Nájera Fuentes
*/

#include <sys/types.h>
#include <sys/stat.h>
#include <filesystem>
#include <iostream>
#include <unistd.h>
#include <fstream>
#include <string>
#include <regex>
#include "utils.h"
#include <pthread.h>

using namespace std;

const int THREADS = 8;
const int SIZE = 18;
typedef struct {
    int start, end;
} Block;
string cSharp;

const string HEADER = "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><meta http-equiv='X-UA-Compatible' content='IE=edge'><meta name='viewport' content='width=device-width, initial-scale=1.0'><link rel='stylesheet' href='styles.css'><title>C# code editor</title></head><body><pre>";
const string FOOTER = "</pre></body></html>";
const string STYLES = "body{background:#333333;color:#FDFFFC;width: 90vw} .cadena{color:rgb(236, 203, 11);} .cadena span{color:rgb(236, 203, 11);} .use_namespc{color:#F71735;} .condicionales{color:#F71735;} .comentarios{color:rgb(190, 190, 190);} .comentarios span{color:rgb(190, 190, 190);}  .operador{color:#F15156;} .tipos{color:#3edff5;font-style:italic;} .tipos span{color:#00BCD4;font-style:italic;} .ciclos{color:#F71735;} .parentheses{color:#CDDC39;} .jump{color:magenta;} .flag{color:#4A8FE7;} .nulo {color:rebeccapurple;font-style:italic;} .definition{color:#FF9F1C;} .oop{color:#E82164;} .bloques{color:#9C27B0;} .type_tam{color:#CDDC39;} .isas{color:#F71735;} .in_out{color:#F71735;}";

const pair<regex, string>EXPRESIONES_REGULARES[SIZE]= {
    pair<regex, string>("((\")([^(\")])*(\"))|((\')([^\"])?(\'))", "cadena"),
    pair<regex, string>("\\busing\\b|\\bnamespace\\b", "use_namespc"), // |using
    pair<regex, string>("\\bdo\\b|\\bwhile\\b|\\bfor\\b|\\bforeach\\b", "ciclos"),
    pair<regex, string>("([/][*][^*/]*[*][/])|([/][/][^(<)]*)", "comentarios"),
    pair<regex, string>("\\bif\\b|\\belse\\b|\\bswitch\\b|\\bcase\\b|\\bdefault\\b", "condicionales"),
    pair<regex, string>("\\+|\\-|\\%|&{1}|\\|{1}|\\^{1}|\\*{1}|/{1}(?!span)|<{1}(?!(span|/span|br))|!|\\b\\~\\b", "operador"), //|(?<!span)(?<!')(?<!br)>{1}|(?<!class)={1}
    pair<regex, string>("\\bint\\b|\\buint\\b|\\bfloat\\b|\\bdouble\\b|\\blong\\b|\\bulong\\b|\\bdecimal\\b|\\bstring\\b|\\bchar\\b|\\bbool\\b|\\bshort\\b|\\bushort\\b|\\bbyte\\b|\\bsbyte\\b|\\bparams\\b|\\bref\\b|\\binternal\\b|\\bstackalloc\\b|\\bfixed\\b|\\bvar\\b", "tipos"),
    pair<regex, string>("[(]|[)]|[[]|[\\]]|[{]|[}]", "parentheses"),
    pair<regex, string>("\\breturn(;)?\\b|\\bcontinue(;)?\\b|\\bbreak(;)?\\b|\\bgoto\\b", "jump"),
    pair<regex, string>("\\btrue\\b|\\bfalse\\b", "flag"),
    pair<regex, string>("\\bnull\\b", "nulo"),
    pair<regex, string>("\\bpublic\\b|\\bstatic\\b|\\bprivate\\b|\\bvirtual\\b|\\babstract\\b|\\bprotected\\b|\\bclass\\b[^=]|\\bthis\\b|\\bevent\\b|\\bbase\\b|\\bexplicit\\b|\\bimplicit\\b|\\boperator\\b|\\bextern\\b|\\bobject\\b|\\boverride\\b|\\breadonly\\b|\\bunsafe\\b|\\bdelegate\\b|\\bsealed\\b|\\bvoid\\b", "oop"),
    pair<regex, string>("\\bconst\\b|\\bstruct\\b|\\benum|\\bnew\\b|\\binterface\\b", "definition"),
    pair<regex, string>("\\btry\\b|\\bcatch\\b|\\bthrow\\b|\\bfinally\\b|\\bchecked\\b|\\bunchecked\\b|\\block\\b", "bloques"),
    pair<regex, string>("\\bsizeof\\b|\\btypeof\\b", "type_tam"),
    pair<regex, string>("\\bout\\b|\\bin\\b", "in_out"),
    pair<regex, string>("\\bis\\b|\\bas\\b", "isas"),
    pair<regex, string>("\\.{1}\\w+[^(<]", "parentheses")
};

void* regexea(void*);

int main(int argc, char* argv[]) {
    ofstream outputStyles;
    ifstream inputFile;
    ofstream outputHTML;

    string name, html, path, dir = "HTML_SEQ", dir2 = "HTML_PARALEL";
    int acc = 1;

    if(argc != 2) {
        cout << "ERROR\nAppropiate format: ./app path" << endl;
        return -1;
    }

    path = argv[1];

    mkdir(dir.c_str(), 0777);

    outputStyles.open("./" + dir + "/styles.css", ios::out);
    outputStyles << STYLES; 
    outputStyles.close();

    mkdir(dir2.c_str(), 0777);

    outputStyles.open("./" + dir2 + "/styles.css", ios::out);
    outputStyles << STYLES; 
    outputStyles.close();

    double seqTime = 0;
    start_timer();

    for(auto &p:filesystem::directory_iterator(path)){
        ifstream inputFile;
        ofstream outputHTML;
        
        inputFile.open(p.path(), ios::in);

        html = HEADER;
        string aux, cs = "";
        
        while(!inputFile.eof()) {
            getline(inputFile, aux);
            cs += aux; 
            cs += " <br> ";
        }
        
        for(int i = 0; i < SIZE; i++){
            cs = regex_replace(cs, EXPRESIONES_REGULARES[i].first, "<span class='" + EXPRESIONES_REGULARES[i].second + "'>$&</span>");
        }

        html += cs;
        html += FOOTER;

        name = "./" + dir + "/code";
        name += to_string(acc);
        name += ".html";

        outputHTML.open(name, ios::out);
        outputHTML << html;
        acc++;

        outputHTML.close();
        inputFile.close();
    }
    
    seqTime = stop_timer();
    cout << "El tiempo de ejecución del resaltador Armona en modo secuencial es de: " << seqTime << " ms\n";
    cout << "Archivos resaltados: " << acc - 1 << endl << endl;


    double paralelTime;
    Block blocks[THREADS];

    int blockSize = SIZE/THREADS;
    for(int i = 0; i < THREADS; i++){
        blocks[i].start = i * blockSize;
        blocks[i].end = (i == THREADS - 1)? SIZE - 1 : (i + 1) * blockSize;
    }
    
    acc = 1;
    paralelTime = 0;
    start_timer();

    for(auto &p:filesystem::directory_iterator(path)){
        ifstream inputFile;
        ofstream outputHTML;

        pthread_t ptid[THREADS];
        
        inputFile.open(p.path(), ios::in);

        html = HEADER;
        string aux;
        cSharp = "";
        
        while(!inputFile.eof()) {
            getline(inputFile, aux);
            cSharp += aux; 
            cSharp += " <br> ";
        } 

        for(int i = 0; i < THREADS; i++){
            pthread_create(&ptid[i], NULL, regexea, &blocks[i]);
        }

        for(int i = 0; i < THREADS; i++){
            pthread_join(ptid[i], NULL);
        }

        html += cSharp;
        html += FOOTER;

        name = "./" + dir2 + "/code";
        name += to_string(acc);
        name += ".html";

        outputHTML.open(name, ios::out);
        outputHTML << html;
        acc++;

        outputHTML.close();
        inputFile.close();
    }

    paralelTime = stop_timer();
    cout << "El tiempo de ejecución del resaltador Armona en modo paralelo es de: " << paralelTime << " ms\n";
    cout << "Archivos resaltados: " << acc - 1 << endl << endl;

    return 0;
}

void* regexea(void* params){
    Block* b;
    b = (Block*) params;

    for(int i = b->start; i <= b->end; i++) {
        cSharp = regex_replace(cSharp, EXPRESIONES_REGULARES[i].first, "<span class='" + EXPRESIONES_REGULARES[i].second + "'>$&</span>");
    }

    pthread_exit(NULL);
}

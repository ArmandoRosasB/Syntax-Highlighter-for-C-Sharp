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


const string HEADER = "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><meta http-equiv='X-UA-Compatible' content='IE=edge'><meta name='viewport' content='width=device-width, initial-scale=1.0'><link rel='stylesheet' href='styles.css'><title>C# code editor</title></head><body><pre>";
const string FOOTER = "</pre></body></html>";
const string STYLES = "body{background:#333333;color:#FDFFFC;width: 90vw} .cadena{color:rgb(236, 203, 11);} .cadena span{color:rgb(236, 203, 11);} .use_namespc{color:#F71735;} .condicionales{color:#F71735;} .comentarios{color:rgb(190, 190, 190);} .comentarios span{color:rgb(190, 190, 190);}  .operador{color:#F15156;} .tipos{color:#3edff5;font-style:italic;} .tipos span{color:#00BCD4;font-style:italic;} .ciclos{color:#F71735;} .parentheses{color:#CDDC39;} .jump{color:magenta;} .flag{color:#4A8FE7;} .nulo {color:rebeccapurple;font-style:italic;} .definition{color:#FF9F1C;} .oop{color:#E82164;} .bloques{color:#9C27B0;} .type_tam{color:#CDDC39;} .isas{color:#F71735;} .in_out{color:#F71735;}";
string DIR = "HTML_SEQ";
string DIR2 = "HTML_PARALEL";

vector<string> PATHS;
const pair<regex, string>EXPRESIONES_REGULARES[SIZE]= {
    pair<regex, string>("((\")([^(\")])*(\"))|((\')([^\"])?(\'))", "cadena"),
    pair<regex, string>("\\busing\\b|\\bnamespace\\b", "use_namespc"), // |using
    pair<regex, string>("\\bdo\\b|\\bwhile\\b|\\bfor\\b|\\bforeach\\b", "ciclos"),
    pair<regex, string>("([/][*][^*/]*[*][/])|([/][/][^(<)]*)", "comentarios"),
    pair<regex, string>("\\bif\\b|\\belse\\b|\\bswitch\\b|\\bcase\\b|\\bdefault\\b", "condicionales"),
    pair<regex, string>("\\+|\\-|\\%|&{1}|\\|{1}|\\^{1}|\\*{1}|/{1}(?!span)|<{1}(?!(span|/span|br))|!|\\b\\~\\b|\\s=\\s", "operador"), //|(?<!span)(?<!')(?<!br)>{1}|(?<!class)={1}
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

    string name, html, path;

    if(argc != 2) {
        cout << "ERROR\nAppropiate format: ./app path" << endl;
        return -1;
    }

    path = argv[1];

    mkdir(DIR.c_str(), 0777);

    outputStyles.open("./" + DIR + "/styles.css", ios::out);
    outputStyles << STYLES; 
    outputStyles.close();

    mkdir(DIR2.c_str(), 0777);

    outputStyles.open("./" + DIR2 + "/styles.css", ios::out);
    outputStyles << STYLES; 
    outputStyles.close();
    
    for(auto &p:filesystem::directory_iterator(path)){
        PATHS.push_back(p.path());
    }

    double seqTime = 0;
    for(int j = 0; j < N; j++){
        start_timer();
        for(int i = 0; i < PATHS.size(); i++){
            ifstream inputFile;
            ofstream outputHTML;
            
            inputFile.open(PATHS[i], ios::in);

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

            name = "./" + DIR + "/code";
            name += to_string(i);
            name += ".html";

            outputHTML.open(name, ios::out);
            outputHTML << html;

            outputHTML.close();
            inputFile.close();
        }
        seqTime += stop_timer();
    }
    
    seqTime /= N;
    cout << "El tiempo de ejecución promedio del resaltador en modo secuencial es de: " << seqTime << " ms\n";
    cout << "Archivos resaltados: " << PATHS.size() << endl << endl;


    double paralelTime;
    Block blocks[THREADS];

    int blockSize = PATHS.size()/THREADS;
    for(int i = 0; i < THREADS; i++){
        blocks[i].start = i * blockSize;
        blocks[i].end = (i == THREADS - 1)? PATHS.size(): (i + 1) * blockSize;
    }
    
    paralelTime = 0;
    pthread_t ptid[THREADS];

    for(int j = 0; j < N; j++){
        start_timer();
        for(int i = 0; i < THREADS; i++){
        pthread_create(&ptid[i], NULL, regexea, &blocks[i]);
        }

        for(int i = 0; i < THREADS; i++){
        pthread_join(ptid[i], NULL);
        }
        paralelTime += stop_timer();
    }


    paralelTime /= N;
    cout << "El tiempo de ejecución del resaltador en modo paralelo es de: " << paralelTime << " ms\n";
    cout << "Archivos resaltados: " << PATHS.size()  << endl << endl << endl;

    double speedup = seqTime/paralelTime;
    cout << "Speed up: " << speedup << endl;

    return 0;
}

void* regexea(void* params){
    Block* b;
    b = (Block*) params;

    for(int i = b->start; i < b-> end; i++){

        ifstream inputFile;
        ofstream outputHTML;
        
        inputFile.open(PATHS[i], ios::in);

        string html = HEADER;
        string aux, cs = "";
        
        while(!inputFile.eof()) {
            getline(inputFile, aux);
            cs += aux; 
            cs += " <br> ";
        }
        //cout << "Hola soy un hilo... " << cs << endl;
        
        for(int j = 0; j < SIZE; j++){
            cs = regex_replace(cs, EXPRESIONES_REGULARES[j].first, "<span class='" + EXPRESIONES_REGULARES[j].second + "'>$&</span>");
        }

        html += cs;
        html += FOOTER;
        string name = "./" + DIR2 + "/code";
        name += to_string(i);
        name += ".html";

        outputHTML.open(name, ios::out);
        outputHTML << html;

        outputHTML.close();
        inputFile.close();
    }

    pthread_exit(NULL);
}

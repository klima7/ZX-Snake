#include <iostream>
#include <fstream>

#define SNA_SIZE        131103
#define DEFAULT_ORIGIN  16411

using namespace std;

int main(int argc, char **argv)
{
    // Sprawdzenie liczby argumentów
    if(argc<4)
    {
        cerr << "Too few arguments! Proper call: " << argv[0] << " [input SNA file] [input binary file] [output SNA file][origin " << DEFAULT_ORIGIN << " by default]";
        return 1;
    }

    // Adres pod którym należy umieścić dane binarne
    int origin = argc>4 ? atoi(argv[4]) : DEFAULT_ORIGIN;

    // Otworzenie pliku SNA
    ifstream outer = ifstream(argv[1], ios::binary | ios::in);
    if(!outer.is_open())
    {
        cerr << "Unable to open file " << argv[1] << endl;
        return 1;
    }

    // Otworzenie pliku binarnego
    ifstream inner = ifstream(argv[2], ios::binary | ios::in);
    if(!inner.is_open())
    {
        cerr << "Unable to open file " << argv[2] << endl;
        inner.close();
        return 1;
    }

    // Stworzenie wynikowego pliku SNA
    ofstream output = ofstream(argv[3], ios::out | ios::binary);
    if(!output.is_open())
    {
        cerr << "Unable to create file " << argv[3] << endl;
        inner.close();
        outer.close();
    }

    // Skopiowanie źródłowego pliku SNA do docelowego
    for(unsigned int i=0; i<SNA_SIZE; i++)
    {
        char byte;
        outer.get(byte);
        output.put(byte);
        if(output.bad() || output.bad())
        {
            cerr << "Error occured during injecting" << endl;
            return 1;
        }
    }

    // Wstrzykiwanie danych z pliku binarnego do docelowego pliku SNA
    unsigned int byte_counter = 0;
    output.seekp(origin);
    while(1)
    {
        char byte;
        inner.get(byte);
        output.put(byte);
        if(output.bad() || output.bad())
        {
            cerr << "Error occured during injecting" << endl;
            return 1;
        }

        if(inner.eof()) break;
        else byte_counter++;
    }

    // Zamykanie plików
    outer.close();
    inner.close();

    cout << byte_counter << " bytes was injected under address " << origin << endl;
    return 0;
}

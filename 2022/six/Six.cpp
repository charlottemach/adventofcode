#include <fstream>
#include <iostream>
#include <string>

using namespace std;

bool uniqChars(string s)
{
    for (int i = 0; i < s.length(); i++)
    {
        for (int j = i+1; j < s.length(); j++)
        {
    	    if (s[i] == s[j])
    	        return false;
    	}
    }
    return true;
}
 

int main()
{
    ifstream in("six.txt");
 
    char c = in.get();
    string four(4,c);
    string fourteen(14,c);

    int cntA = 0; int cntB = 0; int resA;
    while ((c = in.get()) != in.eof())
    {
        if (uniqChars(four) && resA == 0)
            resA = cntA;
        if (uniqChars(fourteen))
        {
            cout << "A: " << resA << "\n";
            cout << "B: " << cntB << "\n";
            break;
        }
        cntA++;
        cntB++;
        four = four.substr(1,3).append(1,c);
        fourteen = fourteen.substr(1,13).append(1,c);
    }
    in.close();
    return 0;
}

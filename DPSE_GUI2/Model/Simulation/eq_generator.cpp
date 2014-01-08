//
//  eq_generator.cpp
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/8/14.
//  Copyright (c) 2014 Petro Korienev. All rights reserved.
//

#include "eq_generator.h"
#include <fstream>

using namespace std;

void eq_generate(int n, int m, const char *workingDir)
{
	matrix Ax(n - 1, n - 1), Ay (n - 1, m - n + 1),Sx(m - n + 1, n - 1), Sy(m - n + 1, n - m + 1), S(m - n + 1, m), Kx(n - 1, n - 1), Ky(m - n + 1, m - n + 1);
	ifstream fin;
	istream *pfin;
    chdir(workingDir);
	fin.open("ax");
	pfin= dynamic_cast <istream*>(&fin);
	*pfin>>Ax;
	fin.close();
	fin.open("ay");
	*pfin>>Ay;
	fin.close();
	fin.open("sx");
	*pfin>>Sx;
	fin.close();
	fin.open("sy");
	*pfin>>Sy;
	fin.close();
	fin.open("s");
	*pfin>>S;
	fin.close();
	fin.open("kx");
	*pfin>>Kx;
	fin.close();
	fin.open("ky");
	*pfin>>Ky;
	fin.close();
	ofstream fout;
	ostream *pfout;
	fout.open("w");
	pfout=dynamic_cast<ostream*>(&fout);
	Ax.inverse();
	cout<<"Ax inverse="<<endl;
	cout<<Ax;
	matrix *W = new matrix(Ax * Ay);
	cout<<"W="<<endl;
	cout<<*W;
	*pfout<<*W;
	fout.close();
    matrix *sxkx = new matrix(Sx * Kx);
    matrix *sxkxw = new matrix(*sxkx * *W);
    matrix *syky = new matrix(Sy * Ky);
	matrix *tempTP = new matrix(*syky - *sxkxw);
	cout<<*tempTP;
	tempTP->inverse();
    matrix *TP = new matrix(*tempTP * S);
	fout.open("tp");
	*pfout<<*TP;
	fout.close();
    delete sxkx;
    delete sxkxw;
    delete syky;
    delete tempTP;
    delete TP;
    delete W;
}

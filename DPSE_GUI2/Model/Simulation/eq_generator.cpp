//
//  eq_generator.cpp
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/8/14.
//  Copyright (c) 2014 Petro Korienev. All rights reserved.
//
/*
#include "eq_generator.h"
#include <fstream>

using namespace std;

int main(void)
{
	matrix Ax(4,4),Ay(4,6),Sx(6,4),Sy(6,6),S(6,10),Kx(4,4),Ky(6,6);
	ifstream fin;
	istream *pfin;
	fin.open("..\\ax.txt");
	pfin= dynamic_cast <istream*>(&fin);
	*pfin>>Ax;
	fin.close();
	fin.open("..\\ay.txt");
	*pfin>>Ay;
	fin.close();
	fin.open("..\\sx.txt");
	*pfin>>Sx;
	fin.close();
	fin.open("..\\sy.txt");
	*pfin>>Sy;
	fin.close();
	fin.open("..\\s.txt");
	*pfin>>S;
	fin.close();
	fin.open("..\\kx.txt");
	*pfin>>Kx;
	fin.close();
	fin.open("..\\ky.txt");
	*pfin>>Ky;
	fin.close();
	ofstream fout;
	ostream *pfout;
	fout.open("..\\w.txt");
	pfout=dynamic_cast<ostream*>(&fout);
	matrix W(4,6);
	Ax.inverse();
	cout<<"Ax inverse="<<endl;
	cout<<Ax;
	W=Ax*Ay;
	cout<<"W="<<endl;
	cout<<W;
	*pfout<<W;
	fout.close();
	matrix tempTP(6,6),TP(6,10);
	tempTP=Sy*Ky-(Sx*Kx)*W;
	cout<<tempTP;
	tempTP.inverse();
	TP=tempTP*S;
	fout.open("..\\tp.txt");
	*pfout<<TP;
	fout.close();
}
*/
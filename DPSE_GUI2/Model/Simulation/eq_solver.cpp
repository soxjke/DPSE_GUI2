//
//  eq_solver.cpp
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/8/14.
//  Copyright (c) 2014 Petro Korienev. All rights reserved.
//

#include "eq_solver.h"

#include "matrix.h"
#include <iostream>
#include <fstream>
#include <stdio.h>
#include <math.h>

#define h 0.01
#define delta 0.00001

void solve()
{
	ifstream fin,fin1,fin2,fin3,fin4;
	istream *pfin,*pfin1,*pfin2,*pfin3,*pfin4;
	matrix H(10,1),R(10,10),Q(10,1),Q_prev(10,1),Z(10,1);
	fin.open("..\\h.txt");
	pfin= dynamic_cast <istream*>(&fin);
	*pfin>>H;
	fin.close();
	fin1.open("..\\r.txt");
	pfin1= dynamic_cast <istream*>(&fin1);
	*pfin1>>R;
	fin1.close();
	matrix W(4,6),TP(6,10);
	fin2.open("..\\w.txt");
	pfin2= dynamic_cast <istream*>(&fin2);
	*pfin2>>W;
	fin2.close();
	fin3.open("..\\tp.txt");
	pfin3= dynamic_cast <istream*>(&fin3);
	*pfin3>>TP;
	fin3.close();
//	TP = TP * h;
	matrix X(4,1),Y(6,1);
	fin4.open("..\\y0.txt");
	pfin4= dynamic_cast <istream*>(&fin4);
	*pfin4>>Y;
	fin4.close();
//	X=(W*Y)*(-1);
//	Q_prev=Q=X&Y;
	ofstream fout;
	ostream *pfout;
	fout.open("..\\q.txt");
	pfout=dynamic_cast<ostream*>(&fout);
	long double tcur=0;
	do
	{
		Q_prev=Q;
		Z=Q;
		Z.quadraten();
//		Y=Y+TP*(H-R*Z);
//		X=(W*Y)*(-1);
//		Q=X&Y;
//		tcur+=h;
		*pfout<<tcur<<endl<<Q;
	}
	while (((Q-Q_prev).sum())>delta);
	fout.close();
}
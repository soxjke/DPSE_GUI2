//
//  eq_solver.cpp
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/8/14.
//  Copyright (c) 2014 Petro Korienev. All rights reserved.
//

#include "eq_solver.h"
#include <fstream>

#define MAX_TIME 100
#define h 0.001
#define delta 0.0001

using namespace std;

void eq_solve(int n, int m, const char *workingDir)
{
    chdir(workingDir);
    ifstream fin, fin1, fin2, fin3, fin4;
	istream *pfin,*pfin1,*pfin2,*pfin3,*pfin4;
	matrix H(m, 1), R(m, m), Q_prev(m, 1), /* Q(m, 1),*/ Z(m, 1);
	fin.open("h");
	pfin= dynamic_cast <istream*>(&fin);
	*pfin>>H;
	fin.close();
	fin1.open("r");
	pfin1= dynamic_cast <istream*>(&fin1);
	*pfin1>>R;
	fin1.close();
	matrix W(n - 1, m - n + 1), TP(m - n + 1, m);
	fin2.open("w");
	pfin2= dynamic_cast <istream*>(&fin2);
	*pfin2>>W;
	fin2.close();
	fin3.open("tp");
	pfin3= dynamic_cast <istream*>(&fin3);
	*pfin3>>TP;
	fin3.close();
    matrix TPh = TP * h;
	matrix Y0(m - n + 1, 1);
    matrix Yprev = Y0;
	fin4.open("y0");
	pfin4= dynamic_cast <istream*>(&fin4);
	*pfin4>>Y0;
	fin4.close();
	matrix X = ((W*Y0)*(-1));
    matrix Q_glob = X&Y0;
    Q_prev = Q_glob;
    matrix Q_horizontal = Q_glob;
    ofstream fout;
	ostream *pfout;
	fout.open("q");
	pfout=dynamic_cast<ostream*>(&fout);
	long double tcur=0;
    *pfout<<"t="<<tcur<<endl<<Q_glob;
	do
	{
		Q_prev=Q_glob;
		Z=Q_glob;
		Z.quadraten();
        matrix rz = R * Z;
        matrix hrz = H - rz;
        matrix tphrz = TP * hrz;
		matrix Y=Yprev+tphrz;
        Yprev = Y;
		matrix X=(W*Y)*(-1);
		matrix Q=X&Y;
        Q_glob = Q;
		tcur+=h;
        matrix Q_horizontal_temp = Q_horizontal | Q;
        Q_horizontal = Q_horizontal_temp;
		*pfout<<"t="<<tcur<<endl<<Q;
	}
	while (((Q_glob-Q_prev).sum())>delta && tcur < MAX_TIME);
	fout.close();
    
    ofstream fout1;
	ostream *pfout1;
	fout1.open("q_hor");
	pfout1=dynamic_cast<ostream*>(&fout1);
    *pfout1 << Q_horizontal;
    fout1.close();

    ofstream ftime;
	ostream *pftime;
	ftime.open("time");
	pftime=dynamic_cast<ostream*>(&ftime);
    *pftime << 0.0f << " " << tcur << " " << h;
    ftime.close();
}
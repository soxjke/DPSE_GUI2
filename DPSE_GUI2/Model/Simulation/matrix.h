//
//  matrix.h
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/8/14.
//  Copyright (c) 2014 Petro Korienev. All rights reserved.
//

#ifndef __Distributed_parallel_simulation_environment_graphical_user_interface__matrix__
#define __Distributed_parallel_simulation_environment_graphical_user_interface__matrix__

#include <math.h>
#include <iostream>

using namespace std;

class matrix {
private:
    long double *p;
    size_t n,m;
    inline void swap(size_t, size_t);
    inline void swap_cols(size_t, size_t);
    inline void swap_rows(size_t, size_t);
    inline void mul_row(size_t, long double);
    inline void divide_row(size_t, long double);
    inline void sum_rows(size_t, size_t);
    inline void sub_multed_row(size_t, size_t, long double);
public:
    inline matrix(size_t,size_t);
    ~matrix();
    bool inverse();
    void transpon();
    long double sum();
    long double minimum();
    long double maximum();
    void null();
    void quadraten();
    matrix operator +(matrix&);
    matrix operator -(matrix&);
    matrix operator -();
    matrix operator *(matrix&);
    matrix operator *(long double);
    matrix operator =(matrix&);
    matrix operator &(matrix&); //add below
    matrix operator |(matrix&); //add right
    inline long double* operator [](size_t);
    friend ostream& operator <<(ostream&, const matrix&);
    friend istream& operator >>(istream&, const matrix&);
};

#endif /* defined(__Distributed_parallel_simulation_environment_graphical_user_interface__matrix__) */

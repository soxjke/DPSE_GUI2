//
//  matrix.cpp
//  Distributed parallel simulation environment graphical user interface
//
//  Created by Petro Korienev on 1/8/14.
//  Copyright (c) 2014 Petro Korienev. All rights reserved.
//
/*
#include "matrix.h"

inline matrix::matrix(size_t n, size_t m)
{
	p=new long double[(matrix::n=n)*(matrix::m=m)];
}

matrix::~matrix()
{
	delete p;
}

inline void matrix::swap(size_t index1, size_t index2)
{
	long double temp=p[index1];
	p[index1]=p[index2];
	p[index2]=temp;
}

inline void matrix::swap_cols(size_t index1, size_t index2)
{
	if (index1==index2) return;
	for(size_t i=0; i<n; i++,index1+=m,index2+=m) swap(index1,index2);
}

inline void matrix::swap_rows(size_t index1, size_t index2)
{
	if (index1==index2) return;
	index1*=m;
	index2*=m;
	for(size_t i=0; i<m; i++) swap(index1++,index2++);
}

inline void matrix::mul_row(size_t index, long double coeff)
{
	index*=m;
	for(size_t i=0; i<m; i++) p[index++]*=coeff;
}

inline void matrix::divide_row(size_t index, long double coeff)
{
	index*=m;
	for(size_t i=0; i<m; i++) p[index++]/=coeff;
}

inline void matrix::sum_rows(size_t src, size_t dest)
{
	if (src==dest) return;
	src*=m;
	dest*=m;
	for(size_t i=0; i<m; i++) p[dest++]+=p[src++];
}

inline void matrix::sub_multed_row(size_t src, size_t dest, long double coeff)
{
	if (src==dest) return;
	src*=m;
	dest*=m;
	for(size_t i=0; i<m; i++) p[dest++]-=coeff*p[src++];
}

bool matrix::inverse()
{
	if (n!=m) return false;
	matrix temp(n,n);
	temp=*this;
	matrix E(n,n);
	for(size_t i=0; i<n; i++)
	{
		for(size_t j=0; j<n; j++)
		{
			(i==j)?E.p[n*i+j]=1.0:E.p[n*i+j]=0.0;
		}
	}
	for(size_t k=0; k<n; k++)
	{
		size_t left_col,upper_row;
		bool has_nozero=false;
		for(size_t i=k; i<n; i++)
		{
			for(size_t j=k; j<n; j++)
			{
				if (p[i+j*n]!=0.0)
				{
					has_nozero=true;
					upper_row=j;
					break;
				}
			}
			if (has_nozero)
			{
				left_col=i;
				break;
			}
		}
		if (!has_nozero)
		{
			*this=temp;
			return false;
		}
		swap_cols(k,left_col);
		E.swap_cols(k,left_col);
		swap_rows(k,upper_row);
		E.swap_rows(k,upper_row);
		long double coeff=p[k*(n+1)];
		divide_row(k,coeff);
		E.divide_row(k,coeff);
		for(size_t i=k+1; i<n; i++)
		{
			coeff=p[i*n+k];
			sub_multed_row(k,i,coeff);
			E.sub_multed_row(k,i,coeff);
		}
	}
	for(size_t k=n-1; k>0; k--)
	{
		for(size_t i=k; i>0;)
		{
			long double coeff=p[--i*n+k];
			sub_multed_row(k,i,coeff);
			E.sub_multed_row(k,i,coeff);
		}
	}
	*this=E;
	return true;
}

void matrix::transpon()
{
	long double *p_temp=new long double[n*m];
	for(size_t i=0; i<n; i++)
	{
		for(size_t j=0; j<m; j++)
		{
			p_temp[j*n+i]=p[i*m+j];
		}
	}
	size_t temp=n;
	n=m;
	m=temp;
	delete p;
	p=p_temp;
}

long double matrix::sum()
{
	long double ac=0;
	for(size_t i=0; i<n; i++)
	{
		long double *str_base=p+i*m;
		for(size_t j=0; j<m ; j++) ac+=fabs(str_base[j]);
	}
	return ac;
}

long double matrix::minimum()
{
	long double min=*p;
	for(size_t i=0; i<n; i++)
	{
		long double *str_base=p+i*m;
		for(size_t j=0; j<m ; j++)
		{
			long double elem=str_base[j];
			if (elem<min) min=elem;
		}
	}
	return min;
}

long double matrix::maximum()
{
	long double max=*p;
	for(size_t i=0; i<n; i++)
	{
		long double *str_base=p+i*m;
		for(size_t j=0; j<m ; j++)
		{
			long double elem=str_base[j];
			if (elem>max) max=elem;
		}
	}
	return max;
}

void matrix::null()
{
	for(size_t i=0; i<n; i++)
	{
		long double *str_base=p+i*m;
		for(size_t j=0; j<m ; j++) str_base[j]=0;
	}
}

void matrix::quadraten()
{
	for(size_t i=0; i<n; i++)
	{
		long double *str_base=p+i*m;
		for(size_t j=0; j<m ; j++) str_base[j]*=fabsl(str_base[j]);
	}
}

matrix matrix::operator +(matrix& matr)
{
	matrix *temp=new matrix(n,m);
	for(size_t i=0; i<n; i++)
	{
		size_t str_base=i*m;
		for(size_t j=0; j<m; j++)
		{
			size_t index=str_base+j;
			temp->p[index]=p[index]+matr.p[index];
		}
	}
	return *temp;
}

matrix matrix::operator -(matrix& matr)
{
	matrix *temp=new matrix(n,m);
	for(size_t i=0; i<n; i++)
	{
		size_t str_base=i*m;
		for(size_t j=0; j<m; j++)
		{
			size_t index=str_base+j;
			temp->p[index]=p[index]-matr.p[index];
		}
	}
	return *temp;
}

matrix matrix::operator -()
{
	for(size_t i=0; i<n; i++)
	{
		size_t str_base=i*m;
		for(size_t j=0; j<m; j++)
		{
			size_t index=str_base+j;
			p[index]=-p[index];
		}
	}
	return *this;
}
matrix matrix::operator *(matrix& matr)
{
	matrix *temp=new matrix(n,matr.m);
	for(size_t i=0; i<n; i++)
	{
		size_t str_base=i*matr.m;
		for(size_t j=0; j<matr.m; j++)
		{
			size_t index=str_base+j;
			long double sum=0.0;
			for(size_t k=0; k<m; k++)
			{
				sum+=p[i*m+k]*matr[k][j];
			}
			temp->p[index]=sum;
		}
	}
	return *temp;
}

matrix matrix::operator *(long double coeff)
{
	matrix *temp=new matrix(n,m);
	for(size_t i=0; i<n; i++)
	{
		size_t str_base=i*m;
		for(size_t j=0; j<m; j++)
		{
			temp->p[str_base+j]=p[str_base+j]*coeff;
		}
	}
	return *temp;
}

matrix matrix::operator =(matrix& matr)
{
	p=new long double[matr.n*matr.m];
	matrix *temp=new matrix(matr.n,matr.m);
	memcpy(temp->p,matr.p,sizeof(long double)*matr.n*matr.m);
	memcpy(p,matr.p,sizeof(long double)*matr.n*matr.m);
	temp->n=n=matr.n;
	temp->m=m=matr.m;
	return *temp;
}

matrix matrix::operator &(matrix& matr)
{
	matrix *temp=new matrix(matr.n+n,matr.m);
	size_t size_cur=m*n,size_matr=sizeof(long double)*m*matr.n;
	memcpy(temp->p,p,sizeof(long double)*size_cur);
	memcpy(temp->p+size_cur,matr.p,size_matr);
	temp->n=matr.n+n;
	return *temp;
}

matrix matrix::operator |(matrix& matr)
{
	matrix *temp=new matrix(matr.n,matr.m+m);
	size_t str_size_cur=sizeof(long double)*m;
	size_t str_size_matr=sizeof(long double)*matr.m;;
	for(size_t i=0; i<n; i++)
	{
		size_t str_base_temp=i*temp->m;
		size_t str_base_cur=i*m;
		size_t str_base_matr=i*matr.m;
		memcpy(temp->p+str_base_temp,p+str_base_cur,str_size_cur);
		memcpy(temp->p+str_base_temp+m,matr.p+str_base_matr,str_size_matr);
	}
	return *temp;
}

inline long double* matrix::operator [](size_t index)
{
	return p+index*m;
}

ostream& operator<<(ostream& os, const matrix& m)
{
	streamsize prec=os.precision();
	os.precision(4);
	for(size_t i=0; i<m.n; i++)
	{
		size_t str_base=i*m.m;
		for(size_t j=0; j<m.m; j++)
		{
			os.width(10);
			os<<m.p[str_base+j]<<' ';
		}
		os<<endl;
	}
	os.precision(prec);
	return os;
}

istream& operator>>(istream& is,const matrix& m)
{
	for(size_t i=0; i<m.n; i++)
	{
		size_t str_base=i*m.m;
		for(size_t j=0; j<m.m; j++)
		{
			is>>m.p[str_base+j];
		}
	}
	return is;
}
*/
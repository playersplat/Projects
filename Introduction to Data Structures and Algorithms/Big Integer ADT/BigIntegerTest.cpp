/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa5
 * List.c
 * Implementation file for BigInteger ADT in C++
 * Programming Assignment: pa5
 *********************************************************************************/
#include<string>
#include<iostream>
#include"BigInteger.h"
#include"List.h"
using namespace std;

int main() {
	/*
	string test = "123456789";
	string test1 = "+1111111112222222220000000002044444444";
	string test2 = "+123456789";
	string test3 = "355797";
	string test4 = "149082";
	BigInteger A = BigInteger(test3);
	BigInteger B = BigInteger(test4);
	BigInteger C = A.add(B);

	if (A.sign() != 1) return 1;
	B = BigInteger("13378008135");
	C = BigInteger("+13378008135");
	BigInteger D = BigInteger("-13378008135");
	if (B.sign() != 1) return 2;
	if (C.sign() != 1) return 3;
	if (D.sign() != -1) return 4;

	A = BigInteger("+13378008135");
	A.makeZero();
	if (A.sign() != 0) return 5;

	B = BigInteger();
	if (B.sign() == 0 && A.sign() != 0) {
		return 6;
	}
	if (!(A == B)) return 7;
	 
	//test cases for add()

	A = BigInteger("+111122223333");
	B = BigInteger("+222211110000");

	//pos + pos = pos
	D = BigInteger("+333333333333");
	C = A + B;

	if (!(C == D)) return 8;

	//add a positive and a negative integer
	//-> pos + neg = 0
	B = BigInteger("-111122223333");
	C = A + B;
	if (C.sign() != 0) return 9;

	//-> pos + neg > 0
	B = BigInteger("-110122223333");
	D = BigInteger("1000000000");
	C = A + B;
	if (C.sign() != 1) return 10;
	if (!(C == D)) return 11;

	//-> pos + neg < 0
	B = BigInteger("-112122223333");
	D = BigInteger("-1000000000");
	C = A + B;
	if (C.sign() != -1) return 12;
	if (!(C == D)) return 13;


	//-> neg + neg = neg
	A = BigInteger("-221211110000");
	D = BigInteger("-333333333333");
	C = A + B;
	if (!(C == D)) return 14;


	//test cases for sub()
	A = BigInteger("+111122223333");
	B = BigInteger("+111122223333");

	C = A - B;
	if (C.sign() != 0) return 15;

	// pos - pos < 0
	B = BigInteger("121122223333");
	D = BigInteger("-10000000000");
	C = A - B;
	if (C.sign() != -1) return 16;
	if (!(C == D)) return 17;

	// pos - pos > 0
	B = BigInteger("101122223333");
	D = BigInteger("10000000000");
	C = A - B;
	if (C.sign() != 1) return 18;
	if (!(C == D)) return 19;

	//pos - neg = pos
	B.negate();
	D = BigInteger("212244446666");
	C = A - B;
	if (C.sign() != 1) return 20;
	if (!(C == D)) return 21;

	//neg - pos = neg
	D.negate();
	C = B - A;
	if (C.sign() != -1) return 22;
	if (!(C == D)) return 23;
	*/
	//multiply test cases

	BigInteger A = BigInteger("111122223333");
	BigInteger B = BigInteger("111122223333");
	BigInteger C = BigInteger();
	BigInteger D = BigInteger("12348148518469129628889");

	// pos * pos = pos
	C = A * B;
	if (C.sign() != 1) return 1;
	if (!(C == D)) return 2;

	// pos * neg = neg
	B.negate();
	D.negate();
	C = A * B;
	if (C.sign() != -1) return 3;
	if (!(C == D)) return 4;

	B.makeZero();
	C = A * B;
	if (C.sign() != 0) return 5;

	return 0;
}

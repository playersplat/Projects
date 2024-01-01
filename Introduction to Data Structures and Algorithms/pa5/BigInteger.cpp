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
LIST_ELEMENT base = 1000000000;
int power = 9;
// Private Helper Functions
void negateList(List& L);
void normalizeList(List& L);
void shiftList(List& L);
// Class Constructors & Destructors ----------------------------------------

// BigInteger()
// Constructor that creates a new BigInteger in the zero state: 
// signum=0, digits=().
BigInteger::BigInteger() {
	signum = 0;
	digits = List();
}

// BigInteger()
// Constructor that creates a new BigInteger from the string s.
// pre: s is a non-empty string consisting of (at least one) base 10 digit
// {0,1,2,3,4,5,6,7,8,9}, and an optional sign {+,-} prefix.
BigInteger::BigInteger(std::string s) {
	signum = 0;
	digits = List();
	digits.moveFront();
	if (s.length() == 0) {
		cerr << "BigInteger Error: constructor called on empty string";
	}
	int sign = 0;
	int strLength = s.size();
	if (s[0] == '-') {
		signum = -1;
		sign = 1;
		
	}
	else if (s[0] != '-') {
		signum = 1;
		if (s[0] == '+') {
			sign = 1;
		}
	}

	if (sign == 1) {
		string checkNum = s.substr(1, strLength - 1);
		if (checkNum.find_first_not_of("0123456789") != string::npos) {
			cerr << "BigIntegerError: constructor called on non-numeric string";
		}
	}
	else
	{
		if (s.find_first_not_of("0123456789") != string::npos) {
			cerr << "BigIntegerError: constructor called on non-numeric string";
		}
	}

	int x = strLength;
	for (int i = strLength; i > sign; i -= power) {
		string str = s;
		string str2;
		
		if (i - power > sign) {
			x -= power;
			str2 = str.substr(x, power);
		}
		else {
			if (sign == 1)
			{
				x--;
				if (x % power == 0) {
					str2 = str.substr(sign, power);
				}
				else {
					str2 = str.substr(sign, x % power);

				}
			}
			else {
				str2 = str.substr(sign, x % power);
			}
		}
		long toList = stol(str2);
		digits.insertAfter(toList);
	}
}
// BigInteger()
// Constructor that copies the BigInteger N.
BigInteger::BigInteger(const BigInteger& N) {
	digits = List(N.digits);
	signum = N.signum;
}

// Access functions --------------------------------------------------------

// sign()
// Returns -1, 1 or 0 according to whether this BigInteger is positive, 
// negative or 0, respectively.
int BigInteger::sign() {
	return signum;
}

// compare()
// Returns -1, 1 or 0 according to whether this BigInteger is less than N,
// greater than N or equal to N, respectively.
int BigInteger::compare(BigInteger N) {
	if (this->signum > N.signum) {
		return 1;
	}
	else if (this->signum < N.signum) {
		return -1;
	}
	else {
		if (this->digits.size() > N.digits.size()) {
			return 1;
		}
		else if (this->digits.size() < N.digits.size()) {
			return -1;
		}
		else {
			this->digits.moveFront();
			N.digits.moveFront();
			for (int i = 0; i < this->digits.size(); i++) {
				LIST_ELEMENT num1 = this->digits.peekNext();
				LIST_ELEMENT num2 = N.digits.peekNext();
				if (num1 > num2) {
					return 1;
				}
				else if (num1 < num2) {
					return -1;
				}
				else {
					this->digits.moveNext();
					N.digits.moveNext();
				}
			}
		}
		return 0;
	}
}


// Manipulation procedures -------------------------------------------------

// makeZero()
// Re-sets this BigInteger to the zero state.
void BigInteger::makeZero() {
	signum = 0;
	digits = List();
}

// negate()
// If this BigInteger is zero, does nothing, otherwise reverses the sign of 
// this BigInteger positive <--> negative. 
void BigInteger::negate() {
	if (signum == 1) {
		signum = -1;
	}
	else if (signum == -1) {
		signum = 1;
	}
}


// BigInteger Arithmetic operations ----------------------------------------

// add()
// Returns a BigInteger representing the sum of this and N.
BigInteger BigInteger::add(const BigInteger& N) {
	List L = this->digits;
	List J = N.digits;
	List added = List();
	int size1 = L.size();
	int size2 = J.size();
	int signumhold = 0;

	L.moveFront();
	J.moveFront();
	for (int i = 0; i < L.size(); i++) {
		LIST_ELEMENT num1 = L.peekNext();
		LIST_ELEMENT num2 = J.peekNext();
		if (num1 > num2) {
			if (this->signum == 1)
			{
				signumhold = 1;

			}
			else if (this->signum == -1)
			{
				signumhold = -1;
			}
			break;
		}
		else if (num1 < num2) {
			if (this->signum == 1) {
				signumhold = -1;
			}
			else if (this->signum == -1) {
				signumhold = 1;
			}
			break;
		}
		else {
			L.moveNext();
			J.moveNext();
		}
	}

	L.moveBack();
	J.moveBack();
	if (this->signum == 1 && N.signum == 1) { //pos + pos
		signumhold = 1;
	}
	else if (this->signum == 1 && N.signum == -1) { //pos + neg == negatelist
		negateList(J);
	}
	else if (this->signum == -1 && N.signum == 1) { //neg + pos == negatelist
		negateList(L);
	}
	else { //neg + neg
		signumhold = -1;
	}

	for (int i = size1; i > 0; i--) {
		if (size2 > 0) {
			added.insertAfter((L.peekPrev() + J.peekPrev()));
		}
		else {
			added.insertAfter(L.peekPrev());
		}
		L.movePrev();
		J.movePrev();
		size2--;
	}

	BigInteger A = BigInteger();
	normalizeList(added);
	A.digits = added;
	A.signum = signumhold;
	
	return A;
	
}
// sub()
// Returns a BigInteger representing the difference of this and N.
BigInteger BigInteger::sub(const BigInteger& N) {
	List L = this->digits;
	List J = N.digits;
	List added = List();
	int size1 = L.size();
	int size2 = J.size();
	int signumhold = 0;

	L.moveFront();
	J.moveFront();
	for (int i = 0; i < L.size(); i++) {
		LIST_ELEMENT num1 = L.peekNext();
		LIST_ELEMENT num2 = J.peekNext();
		if (num1 > num2) {
			if (this->signum == 1)
			{
				signumhold = 1;

			}
			else if (this->signum == -1)
			{
				signumhold = -1;
			}
			break;
		}
		else if (num1 < num2) {
			if (this->signum == 1) {
				signumhold = -1;
			}
			else if (this->signum == -1) {
				signumhold = 1;
			}
			break;
		}
		else {
			L.moveNext();
			J.moveNext();
		}
	}

	L.moveBack();
	J.moveBack();
	if (this->signum == 1 && N.signum == 1) { //pos - pos == pos + neg
		negateList(J);
	}
	else if (this->signum == 1 && N.signum == -1) { //pos - neg == pos + pos
		signumhold = 1;
	}
	else if (this->signum == -1 && N.signum == 1) { //neg - pos == neg + neg
		signumhold = -1;
	}
	else { //neg - neg == neg + pos
		negateList(L);
	}


	for (int i = size1; i > 0; i--) {
		if (size2 > 0) {
			added.insertAfter((L.peekPrev() + J.peekPrev()));
		}
		else {
			added.insertAfter(L.peekPrev());
		}
		L.movePrev();
		J.movePrev();
		size2--;
	}

	BigInteger A = BigInteger();
	normalizeList(added);
	A.digits = added;
	A.signum = signumhold;

	return A;

}

// mult()
// Returns a BigInteger representing the product of this and N. 
BigInteger BigInteger::mult(const BigInteger& N) {
	List L = this->digits;
	List J = N.digits;
	List added = List();
	int size2 = J.size();
	int signumhold = 0;
	if ((this->signum == 1 && N.signum == 1) || (this->signum == -1 && N.signum == -1)) {
		signumhold = 1;
	}
	else if ((this->signum == 1 && N.signum == -1) || (this->signum == -1 && N.signum == 1)) {
		signumhold = -1;
	}



	//modulo for norm
	//floor base for carry
	List temp = List();
	L.moveBack();
	J.moveBack();
	for (int j = size2; j > 0; j--) {
		L.moveBack();
		for (int i = size2; i > 0; i--) {
			long val = L.peekPrev() * J.peekPrev();
			temp.insertAfter(val);
			L.movePrev();
		}
		shiftList(temp);
		J.movePrev();
	}

	BigInteger A = BigInteger();
	A.signum = signumhold;
	return A;
	
}


// Other Functions ---------------------------------------------------------

// to_string()
// Returns a string representation of this BigInteger consisting of its
// base 10 digits. If this BigInteger is negative, the returned string 
// will begin with a negative sign '-'. If this BigInteger is zero, the
// returned string will consist of the character '0' only.
std::string BigInteger::to_string() {
	std::string s;
	if (signum == 0) {
		s = "0";
		return s;
	}
	else if (signum == -1) {
		s = "-";
	}

	digits.moveFront();
	for (int i = 0; i < digits.size(); i++) {
		int x = digits.moveNext();
		string str = std::to_string(x);
		//padding
		int count = power - str.length();
		while (count > 0) {
			s += "0";
			count--;
		}
		s += std::to_string(x);
	}
	return s;
}


// Overriden Operators -----------------------------------------------------

// operator<<()
// Inserts string representation of N into stream.
 std::ostream& operator<<(std::ostream& stream, BigInteger N) {
	 return stream << " ";

}

// operator==()
// Returns true if and only if A equals B. 
 bool operator==(BigInteger& A, const BigInteger& B) {
	 int test = A.compare(B);
	 if (test == -1) {
		 return false;
	 }
	 else if (test == 1) {
		 return false;
	 }
	 else {
		 return true;
	 }

}

// operator<()
// Returns true if and only if A is less than B. 
 bool operator<(BigInteger& A, const BigInteger& B) {
	 int test = A.compare(B);
	 if (test == -1) {
		 return true;
	 }
	 else if (test == 1) {
		 return false;
	 }
	 else {
		 return false;
	 }
}

// operator<=()
// Returns true if and only if A is less than or equal to B. 
 bool operator<=(BigInteger& A, const BigInteger& B) {
	 int test = A.compare(B);
	 if (test == -1) {
		 return true;
	 }
	 else if (test == 1) {
		 return false;
	 }
	 else {
		 return true;
	 }

}

// operator>()
// Returns true if and only if A is greater than B. 
 bool operator>(BigInteger& A, const BigInteger& B) {
	 int test = A.compare(B);
	 if (test == -1) {
		 return false;
	 }
	 else if (test == 1) {
		 return true;
	 }
	 else {
		 return false;
	 }

}

// operator>=()
// Returns true if and only if A is greater than or equal to B. 
 bool operator>=(BigInteger& A, const BigInteger& B) {
	 int test = A.compare(B);
	 if (test == -1) {
		 return false;
	 }
	 else if (test == 1) {
		 return true;
	 }
	 else {
		 return true;
	 }

}

// operator+()
// Returns the sum A+B. 
 BigInteger operator+(BigInteger A, const BigInteger& B) {
	 return A.add(B);
}

// operator+=()
// Overwrites A with the sum A+B. 
 BigInteger operator+=(BigInteger& A, const BigInteger& B) {
	 A = A.add(B);
	 return A;
}

// operator-()
// Returns the difference A-B. 
 BigInteger operator-(BigInteger A, const BigInteger& B) {
	 return A.sub(B);
 }

// operator-=()
// Overwrites A with the difference A-B. 
 BigInteger operator-=(BigInteger& A, const BigInteger& B) {
	 A = A.sub(B);
	 return A;
 }

// operator*()
// Returns the product A*B. 
 BigInteger operator*(BigInteger A, const BigInteger& B) {
	 return A.mult(B);
 }

// operator*=()
// Overwrites A with the product A*B. 
 BigInteger operator*=(BigInteger& A, const BigInteger& B) {
	 A = A.mult(B);
	 return A;
 }


 //helper functions

// negateList()
// Changes the sign of each integer in List L. Used by sub().
 void negateList(List& L) {
	 L.moveFront();
	 for (int i = 0; i < L.size(); i++) {
		 LIST_ELEMENT num = L.peekNext();
		 num = -1 * num;
		 L.eraseAfter();
		 L.insertAfter(num);
		 L.moveNext();
	 }
 }


 // normalizeList()
 // Performs carries from right to left (least to most significant
 // digits), then returns the sign of the resulting integer. Used
 // by add(), sub().
 void normalizeList(List& L) {
	 L.moveBack();
	 LIST_ELEMENT carry = 0;
	 for (int i = L.size(); i > 0; i--) {
		 std::string len = std::to_string(L.peekPrev());
		 LIST_ELEMENT num = L.peekPrev();

		 if (carry == 1) {
			 num += carry;
		 }
		 else if (carry == -1) {
			 num -= carry;
		 }
		 int lengt = len.size();
		 if (lengt > power) {
			 carry = 1;
			 if (num > base) {
				 num -= base;

			 }
			 else if (num < 0) {
				 num += base;
			 }
			 L.eraseBefore();
			 L.insertBefore(num);
		 }
		 else if (lengt < power) {
			 carry = 0;
		 }
		 L.movePrev();

	 }
	 if (carry == 1) {
		 LIST_ELEMENT te = L.peekNext();
		 te += 1;
		 L.eraseAfter();
		 L.insertAfter(te);
	 }
	 
	 L.moveFront();
	 for (int i = 0; i < L.size(); i++) {
		 int x = L.peekNext();
		 if (x < 0) {
			 negateList(L);
			 break;
		 }
		 L.moveNext();
	 }
 }

 // shiftList()
 // Prepends p zero digits to L, multiplying L by base^p. Used by mult().
 void shiftList(List& L) {
	 L.moveBack();
	 L.insertAfter(0);

 }


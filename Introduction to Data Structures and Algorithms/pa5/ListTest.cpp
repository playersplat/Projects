<<<<<<< HEAD
//-----------------------------------------------------------------------------
// List.h
// Header file for List ADT. List is a double ended queue with a vertical
// cursor standing between elements. The cursor position is always defined
// to be an int in the range 0 (at front) to length of List (at back).
// An empty list consists of the vertical cursor only, with no elements.
//-----------------------------------------------------------------------------
#include<string>
#include<iostream>
#include"List.h"

using namespace std;

int main() {
	List L;
	return 0;
}
=======
/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa4
 * ListTest.cpp
 * Implementation file for List ADT in C++
 * Programming Assignment: PA4
 *********************************************************************************/
#include<string>
#include<iostream>
#include"List.h"
using namespace std;

int main() {
	
	List L = List();
	if (!(L.isEmpty())) {
		printf("L is not empty!\n");
	}
	L.insertAfter(10);
	L.insertAfter(4);
	L.insertBefore(1);
	L.insertBefore(2);
	
	if (L.size() != 4) {
		printf("L is suppose to be equal to 4\n");
	}
	if (L.isEmpty()) {
		printf("L is suppose to have items\n");
	}

	if (L.position() != 2) {
		printf("cursor is not moving properly!\n");
	}
	L.moveFront();
	if (L.position() != 0) {
		printf("cursor did not move to the front!\n");
	}
	L.moveBack();
	if (L.position() != L.size()) {
		printf("cursor did not move to the back!\n");
	}
	L.eraseBefore();
	L.movePrev();
	L.eraseBefore();
	L.insertAfter(5);
	
	List N = List(L);
	std::cout << N;
	std::cout << L;
	

	List A = List();
	A.insertAfter(1);
	A.insertAfter(3);
	A.insertAfter(1);
	A.moveBack();
	A.insertBefore(100);
	List* B = &A;
	std::cout << A;
	std::cout << *B;

}

>>>>>>> 7f36081c3581019ddc6bf3dcffcfed552717acb6

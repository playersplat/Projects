/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa5
 * List.c
 * Implementation file for List ADT in C++
 * Programming Assignment: PA5
 *********************************************************************************/
#include<string>
#include<iostream>
#include"List.h"
using namespace std;

// Node constructor
List::Node::Node(LIST_ELEMENT x) {
	data = x;
	next = nullptr;
	prev = nullptr;
}


List::List() {
	frontDummy = new Node(-1);
	backDummy = new Node(-1);
	frontDummy->next = backDummy;
	backDummy->prev = frontDummy;
	beforeCursor = frontDummy;
	afterCursor = backDummy;
	pos_cursor = 0;
	num_elements = 0;
}

List::List(const List& L) {
	//makes this an empty List
	frontDummy = new Node(-1);
	backDummy = new Node(-1);
	frontDummy->next = backDummy;
	backDummy->prev = frontDummy;
	beforeCursor = frontDummy;
	afterCursor = backDummy;
	pos_cursor = 0;
	num_elements = 0;

	// loads elements of L into this
	Node* N = L.frontDummy;
	moveBack();
	while (N->next->data != -1) {
		N = N->next;
		insertBefore(N->data);
	}
	moveFront();
}

List::~List() {
	moveFront();
	while (num_elements > 0) {
		eraseAfter();
	}
	delete frontDummy;
	delete backDummy;

}

//Access Functions
bool List::isEmpty() {
	return(num_elements == 0);
}

int List::size() {
	return(num_elements);
}

int List::position() {
	return(pos_cursor);
}


//Manipulation Procedures
void List::moveFront() {
	beforeCursor = frontDummy;
	afterCursor = frontDummy->next;
	pos_cursor = 0;
}

void List::moveBack() {
	beforeCursor = backDummy->prev;
	afterCursor = backDummy;
	pos_cursor = size();
}

// peekNext()
   // Returns the element after the cursor.
   // pre: position()<size()
int List::peekNext() {
	if (position() < size()) {
		return afterCursor->data;
	}
	return -1;
}
// peekPrev()
// Returns the element before the cursor.
// pre: position()>0
int List::peekPrev() {
	if (position() > 0) {
		return beforeCursor->data;
	}
	return -1;
}

// moveNext()
// Advances cursor to next higher position. Returns the List element that
// was passed over. 
// pre: position()<size() 
int List::moveNext() {
	if (position() < size()) {
		pos_cursor++;
		beforeCursor = afterCursor;
		afterCursor = afterCursor->next;
		return beforeCursor->data;

	}
	return -1;
}

// movePrev()
// Advances cursor to next lower position. Returns the List element that
// was passed over. 
// pre: position()>0
int List::movePrev() {
	if (position() > 0) {
		pos_cursor--;
		afterCursor = beforeCursor;
		beforeCursor = beforeCursor->prev;
		return afterCursor->data;
	}
	return -1;
}

// insertAfter()
   // Inserts x after cursor.
void List::insertAfter(LIST_ELEMENT x) {
	Node* N = new Node(x);
	N->next = afterCursor;
	N->prev = beforeCursor;
	afterCursor->prev = N;
	beforeCursor->next = N;
	afterCursor = N;

	num_elements++;
}

// insertBefore()
  // Inserts x before cursor.
void List::insertBefore(LIST_ELEMENT x) {
	Node* N = new Node(x);
	N->next = afterCursor;
	N->prev = beforeCursor;
	afterCursor->prev = N;
	beforeCursor->next = N;
	beforeCursor = N;

	pos_cursor++;
	num_elements++;
}

// eraseAfter()
// Deletes element after cursor.
// pre: position()<size()
void List::eraseAfter() {
	if (position() < size()) {
		Node* N = afterCursor;
		N->next->prev = beforeCursor;
		beforeCursor->next = N->next;
		afterCursor = afterCursor->next;
		delete N;
		num_elements--;
	}

}

// eraseBefore()
// Deletes element before cursor.
// pre: position()>0
void List::eraseBefore() {
	if (position() > 0) {
		Node* N = beforeCursor;
		N->prev->next = afterCursor;
		afterCursor->prev = N->prev;
		beforeCursor = beforeCursor->prev;
		delete N;
		pos_cursor--;
		num_elements--;
	}
}

// findNext()
// Starting from the current cursor position, performs a linear search (in 
// the direction front-to-back) for the first occurrence of the element x.
// If x is found, places the cursor immediately after the found element (so 
// eraseBefore() would remove the found element), and returns the final 
// cursor position. If x is not found, places the cursor at position size(),
// and returns -1. 
int List::findNext(LIST_ELEMENT x) {
	for (int i = position(); i < size(); i++) {
		if (moveNext() == x) {
			return position();
		}
	}
	moveBack();
	return -1;
}


// findPrev()
// Starting from the current cursor position, performs a linear search (in 
// the direction back-to-front) for the first occurrence of the element x.
// If x is found, places the cursor immediately before the found element (so 
// eraseAfter() would remove the found element), and returns the final 
// cursor position. If x is not found, places the cursor at position 0, and 
// returns -1. 
int List::findPrev(LIST_ELEMENT x) {
	for (int i = position(); i > 0; i--) {
		if (movePrev() == x) {
			return position();
		}
	}
	moveFront();
	return -1;
}


// cleanup()
// Removes any repeated elements in this List, leaving only unique data
// values. The order of the remaining elements is obtained by retaining
// the frontmost occurrance of each element, and removing all other 
// occurances. The cursor is not moved with respect to the retained 
// elements, i.e. it lies between the same two retained elements that it 
// did before cleanup() was called.
void List::cleanup() {
	int oc = position();
	List A;
	moveFront();
	while (peekNext() != -1) {
		A.moveFront();
		if (A.findNext(moveNext()) == -1) {
			A.insertBefore(peekPrev());
		}
	}

	int count = 0;
	int has = 0;
	A.moveFront();
	for (int i = 0; i < A.size(); i++) {
		moveFront();
		for (int j = 0; j < oc; j++) {
			if (moveNext() == A.peekNext()) {
				count++;
				has = 1;
			}
		}
		A.moveNext();
		if (has == 1) {
			count--;
			has = 0;
		}
	}

	clear();
	A.moveFront();
	for (int i = 0; i < A.size(); i++) {
		insertBefore(A.moveNext());
	}

	moveFront();
	for (int i = 0; i < (oc - count); i++) {
		moveNext();
	}
}

// clear()
// Deletes all elements in this List, setting it to the empty state.
void List::clear() {
	moveFront();
	while (num_elements > 0) {
		eraseAfter();
	}
}


// concat()
// Returns a new List consisting of the elements of this List, followed
// the elements of L. The returned List's cursor will be at its front
// (position 0).
List List::concat(const List& L) {
	List temp = List(*this);
	temp.moveBack();

	Node* N = L.frontDummy->next;
	while (N != L.backDummy) {
		temp.insertBefore(N->data);
		N = N->next;
	}
	return temp;
}


// to_string()
 // Returns a string representation of this List consisting of a comma 
 // separated sequence of elements, surrounded by parentheses.
std::string List::to_string() {
	Node* N = nullptr;
	std::string s = "(";
	for (N = this->frontDummy->next; N != backDummy; N = N->next) {
		if (N != backDummy->prev) {
			s += std::to_string(N->data) + ", ";
		}
		else {
			s += std::to_string(N->data);
		}
	}
	s += ")";

	return s;

}


// equals()
// Returns true if and only if this List is the same integer sequence as R.
// The cursors in this List and in R are unchanged.
bool List::equals(const List& R) {
	bool eq = false;
	Node* N = frontDummy;
	Node* M = R.frontDummy;

	eq = (this->num_elements == R.num_elements);
	N = N->next;
	M = M->next;
	while (eq && N != nullptr) {
		eq = (N->data == M->data);
		N = N->next;
		M = M->next;
	}

	return eq;
}



// Overriden Operators -----------------------------------------------------

  // operator<<()
  // Inserts string representation of L into stream.
std::ostream& operator<<(std::ostream& stream, List& L) {
	return stream << L.List::to_string();
}

// operator==()
// Returns true if and only if A is the same integer sequence as B. The 
// cursors in both Lists are unchanged are unchanged.
bool operator==(List& A, const List& B) {
	return A.List::equals(B);
}
// operator=()
// Overwrites the state of this List with state of L.
List& List::operator=(const List& L) {
	if (this != &L) {
		List temp = L;
		std::swap(frontDummy, temp.frontDummy);
		std::swap(backDummy, temp.backDummy);
		std::swap(beforeCursor, temp.beforeCursor);
		std::swap(afterCursor, temp.afterCursor);
		std::swap(pos_cursor, temp.pos_cursor);
		std::swap(num_elements, temp.num_elements);
	}
	return *this;
}


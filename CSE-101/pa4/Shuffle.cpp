/********************************************************************************
 * Brian Bui, bbui3
 * 2021 Spring CSE 101 pa4
 * Shuffle.cpp
 * Implementation file for Shuffling Cards
 * Programming Assignment: PA4
 *********************************************************************************/
#include<string>
#include<iostream>
#include"List.h"
using namespace std;

void shuffle(List& D);

int main(int argc, char* argv[])
{
	int argu = stoi(argv[1]);
	List cards;
	cout << "deck size shuffle count\n";
	cout << "------------------------------\n";
	List temp;
	for (int i = 1; i <= argu; i++) {
		int count = 0;
		cards.insertBefore(i);
		temp = cards;
		shuffle(cards);
		count++;

		while (true) {
			if (temp == cards) {
				break;
			}
			shuffle(cards);
			count++;

		}
		cout << i << "                " << count << "\n";
	}
	
}

void shuffle(List& D) {
	List A;
	List B;
	D.moveFront();
	for (int i = 0; i < (D.size() / 2); i++) {
		A.insertBefore(D.moveNext());
	}
	while (D.position() < D.size()) {
		B.insertBefore(D.moveNext());
	}
	//merging time
	int Dsize = D.size();
	D.clear();
	A.moveFront();
	B.moveFront();
	for (int i = 0; i < Dsize/2; i++) {
		D.insertBefore(B.moveNext());
		D.insertBefore(A.moveNext());
	}
	if (Dsize % 2 != 0) {
		D.insertBefore(B.moveNext());
	}

}
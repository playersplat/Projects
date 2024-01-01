#------------------------------------------------------------------------------
#  Makefile for List ADT
#
#  make             TOP client
#  make clean       removes object files
#  make check1      runs valgrind on TOP client to check for memory errors
#  make check2      runs valgrind on BigIntegerClient to check for memory errors
#------------------------------------------------------------------------------

TOP              = Arithmetic
ADT1             = BigInteger
ADT2             = List
TOP_OBJ          = $(TOP).o
TOP_SRC          = $(TOP).cpp
TEST             = BigIntegerClient
TEST_OBJ         = $(TEST).o
TEST_SRC         = $(TEST).cpp
ADT1_OBJ         = $(ADT1).o
ADT1_SRC         = $(ADT1).cpp
ADT1_HDR         = $(ADT1).h
ADT2_OBJ         = $(ADT2).o
ADT2_SRC         = $(ADT2).cpp
ADT2_HDR         = $(ADT2).h
COMPILE          = g++ -std=c++11 -Wall -c
LINK             = g++ -std=c++11 -Wall -o
REMOVE           = rm -f
MEMCHECK         = valgrind --leak-check=full

$(TOP) : $(TOP_OBJ) $(ADT1_OBJ) $(ADT2_OBJ)
    $(LINK) $(TOP) $(TOP_OBJ) $(ADT1_OBJ) $(ADT2_OBJ)

$(TEST) : $(TEST_OBJ) $(ADT1_OBJ) $(ADT2_OBJ)
    $(LINK) $(TEST) $(TEST_OBJ) $(ADT1_OBJ) $(ADT2_OBJ)

$(TOP_OBJ) : $(TOP_SRC) $(ADT1_HDR) $(ADT2_HDR)
    $(COMPILE) $(TOP_SRC)

$(TEST_OBJ) : $(TEST_SRC) $(ADT1_HDR) $(ADT2_HDR)
    $(COMPILE) $(TEST_SRC)

$(ADT1_OBJ) : $(ADT1_SRC) $(ADT1_HDR)
    $(COMPILE) $(ADT1_SRC)

$(ADT2_OBJ) : $(ADT2_SRC) $(ADT2_HDR)
    $(COMPILE) $(ADT2_SRC)

clean :
    $(REMOVE) $(TOP) $(TOP_OBJ) $(ADT1_OBJ) $(ADT2_OBJ) $(TEST) $(TEST_OBJ)

check1 : $(TOP)
    $(MEMCHECK) $(TOP) in4 blah4

check2 : $(TEST)
    $(MEMCHECK) $(TEST)

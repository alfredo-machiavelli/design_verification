/*
  supports C built-in types; int = 32 bits; longint = 64 bits; float in sysV => 'shortreal'
  typedef = user defined types' automatic conversions btwn logic and bit
  
  INTEGER DATA TYPES
    shortint = 16 bit signed integer; int = 32 bit signed integer; longint = 64 bit signed integer
  
  STRING
    len(), putc(), getc(), toupper(), tolower(), compare(), substr()
    
    atoi(), atohex(), atooct(), atobin(), atoreal() -> string to int, hex, octal, bin, real
    
    -- inverse is itoa(), hextoa(), ...
    
  EVENT DATA TYPE - synchronization objects
    
    trigger var -> 'persistent triggered state that lasts for the duration of the entire time step'
                    assigned 'null' -> the association btwn the synch object and the event var = broken
                    
    event variable_name [= initial_value]; 
    
    event done;            // declare a new event called done
    event done_too = done; // alias to done
    event empty = null;    // event var w/ no synch object
    
*/

/*
  user-defined types (use typedef) - users can define a new type
  
  typedef in intP;
  intP a,b;
  
  we can also use it before it is defined - but it doesn't apply to enumeration vals
  
  typedef foo;
  foo f = 1;
  typedef int foo;
*/

/*

  enumerations => enum type ; set of named int values
  
  enum {red, yellow, green} light1, light2;  // anonymous int type; light1 & light2 are var w/ 3 mem - red, yellow, green
  
  //must have explicit data type
  
  Syntax error: IDLE=2’b00, XX=2’bx <ERROR>, S1=2’b01, S2=2’b10
      enum {IDLE, XX=’x, S1=2’b01, S2=2’b10} state, next;
      enum integer {IDLE, XX=’x, S1, S2} state, next;               
      enum bit [3:0] {bronze=5'h13, silver, gold=3'h5} medal4;      // error in bronze and gold declaration
      enum bit [0:0] {a,b,c} alphabet;                              // requires at least 2 bits
      
  Correct: IDLE=0, XX=’x, S1=1, S2=2
      enum integer {IDLE, XX=’x, S1=’b01, S2=’b10} state, next;    
      enum bit [3:0] {bronze='h3, silver, gold='h5} medal4;
      enum bit [3:0] {bronze=4'h3, silver, gold=4'h5} medal4;
 
 incrementing enum types
      // values can be cast to integer types + incremented from init value of 0 - can be overriden
      
      enum {bronze=3, silver, gold} medal; // silver=4, gold=5
      
      //values can be set for some names but not others; 
      //a name without a value is auto assigned as an increment of the the previous val
      
      enum {a=3, b=7, c} alphabet;        // so c is 8
      
      //if an automatically incremented val is assigned elsewhere in the same enumeration, error
      
      enum {a=0, b=7, c, d=8} alphabet;   // syntax error bc c and d are both assigned 8
      
      //if first name is not assigned a val, given init val of 0
      
      enum {a , b=7, c}                   // a = 0, b = 7, c = 8
      
  enumeration type ranges
      
      i.e. 
*/
      typedef enum { add=10, sub[5], jmp[6:8] } E1;
/*      
      this is an enumerated type E1, assigns #10 to the constant add
      it also creates sub0 = 11; sub1 = 12; sub2 = 13; sub4 = 14; sub5 = 15
      creates jmp[6] = 16, jmp[7] = 17, jmp[8] = 18
      
      i.e. enum { register[2] = 1, register[2:4] = 10 } vr;
      
      enumerated variable vr; register[0] = 1; register[2] = 2
      register[2] = 10, register[3] = 11, register[4] = 12
*/  
  //type checking 
    
    typedef enum { red, green, blue, yellow, white, black } Colors;
    Colors c; 
    c = green; 
    c = 1;            //invalid assignment
    if (1 == c)       //c is now auto-cast to an integer
  
    //numerical expressions
    
    typedef enum {Red, Green, Blue} Colors;
    typedef enum {Mo,Tu,We,Th,Fr,Sa,Su} Week;
    Colors C;
    
    Week W;
    int I; 
    
    C = Colors' (C+1)         //here C is converted to an int
                              //its added to 1
                              //converted back to Colors
                              
    C = C+1; C++; C+=2; C=I   //all illegal
    
    C = Colors' (Su);         //legal; puts an out of range value into C  
    
    I = C + W                 //legal; C and W are auto cast to int
/*    
METHODS 
    
    first() - returns first member of enumeration; 
            function enum first();
    last()  - returns last member of enumeration;
            function enum last();
    next()  - returns Nth next enumeration val starting from curr val of given var
            function enum next( int unsigned N = 1 );
    prev()  - returns Nth prev enumeration val starting from curr val of given var
            function enum prev( int unsigned N = 1 );       
    num()   - returns num of elements in given enumeration
            function int num();
    name()  - returns string representatin of enumeration val
            function string name();
            
    ok ... how to display all names and vals in an enumeration??
*/
  typedef enum { red, green, blue, yellow } Colors;                   //Colors holds red,green, blue, yellow 
  Colors c = c.first;                                                 //init first val - c is init into enum
  forever begin                                                       //this is kind of like a while loop
    $display( "%s : %d\n", c.name, c );                               //get name and val 
    if( c == c.last ) break;                                          //if we are at end, just break out of loop
    c = c.next;                                                       //get to the next element
  end  

/*   
STRUCTS AND UNIONS
*/  
  struct { bit [7:0] opcode; bit [23:0] addr; }IR; // anonymous structure
                                                   // defines variable IR
  IR.opcode = 1;                                   // set field in IR

//more examples

typedef struct { bit [7:0] opcode; bit [23:0] addr;} instruction; // named structure type
instruction IR; // define variable    
    
//union example

 typedef union { int i; shortreal f; } num; // named union type
 num n;
 n.f = 0.0;                                 // set n in floating point format
 
//example w/ an array

typedef struct { bit isfloat; union { int i; shortreal f; } n; // anonymous type
               } tagged_st;                                    // named structure
tagged_st a[9:0]; // array of structures named a

/* what is the difference between a struct and a union?
      For a struct, there is a piece of memoery allocated for each data input - store multiple values of various members
      For a union, there is one piece of memory for the whole data structure - store one val at a time for each member
   
   what is a packed structure?
       consists of bit fields which are packeed together in memory without gaps - easily converted to and from bit vectors
*/

//Packed Structure Examples
  
struct packed signed {
    int a;
    shortint b;
    byte c;
    bit [7:0] d; 
} pack1;              //signed, 2-state

struct packed unsigned {
    time a;
    integer b;
    logic [31:0] c; 
} pack2;              //unsigned, 4-state

// if any data type within a packed structure is 4-state, the whole structure is treated as a 4-state; any 2-state members are converted to cast
// to access:
pack1 [15:8] //c

//a packed structure can be used with a typedef -- but what does a typedef do??
  
typedef struct packed { // default unsigned
  bit [3:0] GFC;
  bit [7:0] VPI;
  bit [11:0] VCI;
  bit CLP;
  bit [3:0] PT ;
  bit [7:0] HEC;
  bit [47:0] [7:0] Payload;
  bit [2:0] filler;
} s_atmcell; 

// a packed union contains members that must be packed structures all of the SAME SIZE (unpacked can be of different sizes)
// example: a union can be accessible with difference access widths 

typedef union packed {        //defaut unsigned
  s_atmcell acell;
  bit [423:0] bit_slice;
  bit [

















  
  
  
  

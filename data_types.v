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
  
  
  
  
  
  
  
  
  
  
  
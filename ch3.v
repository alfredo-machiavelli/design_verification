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
      
  Correct: IDLE=0, XX=’x, S1=1, S2=2
      enum integer {IDLE, XX=’x, S1=’b01, S2=’b10} state, next;
      
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

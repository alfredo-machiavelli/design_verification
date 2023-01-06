// RANDOM CONTRAINTS - generate tests for functional verification 


//object oriented method to assign random var to the member var of an obj
class Bus;
  rand bit[15:0] addr;
  rand bit[31:0] data;
  constraint word_align {addr[1:0] == 2’b0;}
endclass

/*
  Bus class models a simplified bus with two random variables: addr and data

  word_align constraint declare that the random vals for addr must be such that addr is word-aligned
  
  word-aligned means that the low-order 2 bits are 0
*/

// randomize() method - generate new random vals for bus object

   Bus bus = new;
   repeat (50) begin
      if ( bus.randomize() == 1 )
        $display ("addr = %16h data = %h\n", bus.addr, bus.data);
      else
        $display ("Randomization failed.\n");
   end
// here a Bus object is created + randomized 50 times- result of each randomization is checked
// if the randomization succeeds, new random values for addr and data are printed else error

// ONLY THE ADDR VAL IS CONSTRAINED - THE DATA VAL IS NOT

//whats the advantage? lets users build generic, reusable objects
    
/* 
  another example
  
  here MyBus inherits all of the random variables + constraints of the Bus class 
  adds a rand var called atype used to control the addrss range using another constraint
  addr_range constraint  - select one of 3 range constraints depending on the random val of atype
  
*/
typedef enum {low, mid, high} AddrType;

class MyBus extends Bus;
  
  rand AddrType atype;
  
  constraint addr_range{
    (atype == low ) -> addr inside { [0 : 15] };
    (atype == mid ) -> addr inside { [16 : 127]};
    (atype == high) -> addr inside {[128 : 255]};
  }
  
endclass
    
    
//with construct - declares additional constraints in-line with the call to randomize()

task exercise_bus (MyBus bus);
  
  int res;
  // EXAMPLE 1: restrict to low addresses
  res = bus.randomize() with {atype == low;};
  // EXAMPLE 2: restrict to address between 10 and 20
  res = bus.randomize() with {10 <= addr && addr <= 20;};
  // EXAMPLE 3: restrict data values to powers-of-two
  res = bus.randomize() with {data & (data - 1) == 0;};
  
endtask
    
//disable constraints on random variables    
 
task exercise_illegal(MyBus bus, int cycles);
  
  int res;
  // Disable word alignment constraint
  // constraint_mode() disables/enables constraint block on an object
  
  bus.word_align.constraint_mode(0);
  
  repeat (cycles) begin
    
    // CASE 1: restrict to small addresses.
    res = bus.randomize() with {addr[0] || addr[1];};
      ...
  end
  
  // Re-enable word alignment constraint
  bus.word_align.constraint_mode(1);
  
endtask

//RANDOM VARIABLES
    
rand bit [7:0] y;         //values are uniformly distributed over this range
// 8 -bit unsigned integer w/ range 0 to 255; if unconstrained, this var shall be assigned any value in the range 0 to 255 w/ equal probability (1/256)

randc bit [1:0] y;        //randc = randomly cycle through all the values in a random permutation of their declared range
/*
  can take on values 0,1,2,3 (range 0-3) so..
  initial permutation: 0 -> 3 -> 2 -> 1
  next permutation: 2 -> 1 -> 3 -> 0
  next permutation: 2 -> 0 -> 1 -> 3
*/

// CONSTRAINT BLOCKS     
    
   // class declaration
      class XYPair;
        rand integer x, y; 
        constraint c;
      endclass
  // external constraint body declaration
      constraint XYPair::c { x < y; }
    
//SET MEMBERSHIP
  //equal probability of being chosen by the inside operator

  rand integer x, y, z;
  constraint c1 {x inside {3, 5, [9:15], [24:32], [y:2*y], z};}

  rand integer a, b, c;
  constraint c2 {a inside {b, c};}              //inside is bidirectional

  integer fives[0:3] = { 5, 10, 15, 20 };
  rand integer v;
  constraint c3 { v inside fives; }
    
//DISTRIBUTION
  






















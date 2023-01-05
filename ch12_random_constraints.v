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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

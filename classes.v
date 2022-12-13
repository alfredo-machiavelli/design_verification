/* 
  class data abstraction - allow objects to be dynamically created, deleted, assigned, and accessed via object handles
  class data = properties ; subroutines = methods
  defines a data type; object = instance of that class (using new function
*/

  class Packet ;
  //data or class properties
    bit [3:0] command;
    bit [40:0] address;
    bit [4:0] master_id;
    integer time_requested;
    integer time_issued;
    integer status;
   // initialization
    function new();                   //instance of the class
      command = IDLE;
      address = 41’b0;
      master_id = 5’bx;
    endfunction
   // methods
   // public access entry points
    task clean();
      command = 0; address = 0; master_id = 5’bx;
    endtask
    task issue_request( int delay );
      // send request to bus
    endtask
    function integer current_status();
      current_status = status;
    endfunction
  endclass

//DECLARATION AND INITIALIZATION

Packet p; // declare a variable of class Packet
p = new; // initialize variable to a new allocated object of the class Packet


//what happens if object is uninitialized? set by default w/ special value null

  class obj_example;
      ...
  endclass
  
  //this task checks if an obj_example is initialized
  task task1(integer a, obj_example myexample);
    if (myexample == null) myexample = new;
  endtask

  














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

/* accessing non-static members or virtual methods via a null object handle is illegal - cause error
   objects are referenced using an OBJECT HANDLE - comparable to a C pointer
   C pointers can be incremented; SysV handles cannot
*/

//OBJECT PROPERTIES

  Packet p = new;
  p.command = INIT; 
  p.address = $random;
  packet_time = p.time_requested;

//OBJECT METHODS

  Packet p = new;
  status = p.current_status();        //DO NOT DO: status = current_status(p);

//CONSTRUCTORS - good news.. there are no memory leaks
  
  //new object created
  Packet p = new;
  
  //this is the new function that is being called - new = CLASS CONSTRUCTOR
  //it is nonblocking; no return type specified but LHS will determine
  class Packet;
    
     integer command;
    
     function new()
       command = IDLE;
     endfunction
    
  endclass
  
  //you can pass arguments to the constructor - run-time customiztion of an object
  Packet p = new (STARTUP, $random, $time);
  
  //so new looks like this
  function new(int cmd = IDLE, bit[12:0] adrs = 0, int cmd_time );
    command = cmd;
    address = adrs; 
    time_requested = cmd_time;
  endfunction
  
  /* static class properties
     so in the previous example, we have only declared instance class properties
     each instance of the class (each object of type Packet) has its own copy of each of its 6 variables
     
     but sometimes only one version of a variable is required to be shared by all instances 
  */
    
  class Packet;
    static integer fileID = $fopen("data", "r");
  
  //fileId is only created an init once.. so here is how to access
  Packet p;
  c = $fgetc(p.fileID);
  
//STATIC METHODS
  /* behaves like a regular subroutine thast can be called outside the class - even with no class instantiation
     no access to non-static members (class properties or methods) 
  */
  
    class id;
      static int current = 0;
      static function int next_id();
        next_id = ++current;            //OK to access static class property
      endfunction
    endclass
    
  //static method vs method w/ static lifetime
     
     











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
    
    class TwoTasks;
      static task foo(); ..... endtask        //static class method with austomatic variable lifetime
      task static bar(); ..... endtask        //non-static class method with static variable lifetime
    endclass
  
 /* 'this' keyword */
    
    class Demo;
      integer x;
      
      function new (integer x)
        this.x = x;             //this.x refers to the integer x that was init outside of the function .. same as most OOP lang
      endfunction
      
    endclass
      
// ASSIGNMENT, RE-NAMING, AND COPYING
    
    
    //declaring class variable...
    Packet p1;
    
    //init val of p1 is null; object does not exist and p1 does not contain an actual handle until an instance is created
    
    //creating an instance...
    p1 = new;
    
    //ok so now we declare and assign another var from the old handle to the new one
    Packet p2;
    p2 = p1;
    
    //there is still only one object which can referred to w/ the name p1 or p2 bc 'new' was only executed once
    
    //..but what if we did this?
    Packet p1;
    Packet p2;
    p1 = new;
    p2 = new p1;
    
    //we just created a SHALLOW COPY; all properties and methods are copied into a new object but the actual object is not copied (just the handles)
    
    class A ;
      integer j = 5;
      endclass
    
    class B ;
      integer i = 1;
      A a = new;
    endclass
    
    function integer test;
      B b1 = new;                   // Create an object of class B
      B b2 = new b1;                // Create an object that is a copy of b1
      b2.i = 10;                    // i is changed in b2, but not in b1
      b2.a.j = 50;                  // change a.j, shared by both b1 and b2
      test = b1.i;                  // test is set to 1 (b1.i has not changed)
      test = b1.a.j;                // test is set to 50 (a.j has changed)
    endfunction
    
//INHERITANCE AND SUBCLASSES
    
    class LinkedPacket;
      
      Packet packet_c;
      LinkedPacket next;
      
      function LinkedPacket get_next();
        get_next = next;
      endfunction
      
    endclass
    
    //we don't actually need 'Packet packet_c' if we extend the class; this is called single inheritance
    
    class LinkedPacket extends Packet;
      
      LinkedPacket next;
      
      function LinkedPacket get_next();
        get_next = next;
      endfunction
      
    endclass
    
//OVERRIDDEN MEMBERS - subclass objects are also legal representatie objects of their parent classes - every linkedpacket is a legal packet
    
    //here we assign a packet var the handle of a LinkedPacket object
    LinkedPacket lp = new;
    Packet p = lp;
    
    //example
    class Packet;
      integer i = 1;
      function integer get();
        get = i;
      endfunction
    endclass
    
    class LinkedPacket extends Packet;
      integer i = 2;
      function integer get();
        get = -i;
      endfunction
    endclass
    
    //evaluate
    LinkedPacket lp = new;
    Packet p = lp;
    
    //even though the handle is LinkedPacket, the variable type overrides members
    j = p.i;              // j = 1, not 2
    j = p.get();          // j = 1, not -1 or –2
    
//SUPER  - used to access members of a parent class when those members are overriden by the derived class
    
    class Packet;                                 //PARENT CLASS
      integer value;
      function integer delay();
        delay = value * value;
      endfunction
    endclass
    
    class LinkedPacket extends Packet;           //DERIVED CLASS
      integer value;
      function integer delay();
        delay = super.delay() + value * super.value;
      endfunction
    endclass
    
//CASTING - assign a superclass handle to a subclass variable  
    
    task $cast( singular dest_handle, singular source_handle );
      
    function int $cast( singular dest_handle, singular source_handle );
      
//CHAINING CONSTRUCTORS    
    
      class EtherPacket extends Packet(5);            //we pass 5 to the new routine associated with Packet 
    
      //we can also do this
        
      function new();
        super.new(5);
      endfunction
        
//ABSTRACT CLASSES AND VIRTUAL METHODS
        
  /* 
     A set of classes can be created that can be viewed as all being derived from a common base class
     
     This base class will never be instantiated

     From the base class, a number of useful subclasses could be derived
  */
        
     virtual class BasePacket;        //virtual makes the class abstract
                                      //overrides a method in all the base classes
       
     virtual class BasePacket;       //prototype no implementation
        virtual function integer send(bit[31:0] data);
        endfunction
     endclass
       
     class EtherPacket extends BasePacket;              //class that can be instantiated
        function integer send(bit[31:0] data);
          // body of the function
        endfunction
     endclass
       
//POLYMORPHISM: dynamic method lookup; allows the use of a variable in the superclass to hold subclass objects
       
    BasePacket packets[100];   
       
       /*
         few things to look at: (1) BasePacket is abstract but it can still be used to declare a var 
                                (2) If all the data types were diff, it wouldn't have been able to be stored into an array, 
                                    but bc we used virtual methods, it was possible
       */
       
       EtherPacket ep = new; // extends BasePacket
       TokenPacket tp = new; // extends BasePacket
       GPSSPacket  gp = new; // extends EtherPacket
       packets[0] = ep;
       packets[1] = tp;
       packets[2] = gp;
       
// PARAMETERIZED CLASSES       
       
   //The normal Verilog parameter mechanism is used to parameterize a class:
      class vector #(int size = 1);
        bit [size-1:0] a;
      endclass    
       
  //Instances of this class can then be instantiated like modules or interfaces:
      vector #(10) vten; // object with vector of size 10
      vector #(.size(2)) vtwo; // object with vector of size 2
      typedef vector#(4) Vfour; // Class with vector of size 4
       
  //This feature is particularly useful when using types as parameters:
      class stack #(type T = int);
        local T items[];
        task push( T a ); ... endtask
        task pop( ref T a ); ... endtask
      endclass  
  //The above class defines a generic stack class that can be instantiated with any arbitrary type:
      stack is;               // default: a stack of int’s
      stack#(bit[1:10]) bs;   // a stack of 10-bit vector
      stack#(real) rs;        // a stack of real numbers
       
//TYPEDEF CLASS - when a class variable needs to be declared before the class itself has been declared
       
       typedef class C2; // C2 is declared to be of type class
       
            class C1;
              C2 c;
            endclass
       
            class C2;
              C1 c;
            endclass
       


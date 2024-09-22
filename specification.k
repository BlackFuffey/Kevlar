
/*
        Welcome to the Kevlar langauge specification!
        Kevlar is a high level programming langauge that
        aims to combine great flexibility while providing
        high performance and memory safety.
        
        Kevlar uses a runtime contentID-ownership memory management system to ensure memory 
        safety while keeping flexibility and performance.

        Anything stored in heap memory has an identifier used to validate access. 
        The owner of a memory block holds a special pointer for direct access, while copies 
        holds a copy pointer containing a pointer and an identifier. When a copy attempts to 
        access memory, it must first verify that its stored identifier matches the identifier 
        of the content. This check ensures that copies cannot access deallocated or invalid memory.

        Ownership can be transferred but never shared, and deallocation sets the content identifier to 
        an impossible value, preventing further access from any remaining copies. An increament-based 
        ID generator, optimized by the compiler, manages identifiers to minimize overhead while maintaining 
        memory safety.

        This document demonstrates all syntax in Kevlar.
*/

// This is a single line comment

/*
    This is a 
    multi-line comment
*/

/*
 *      This is an inline documentation
 *
 *      @param name<type> example parameter
 *      @return<type> example return
 *
*/

/*      IMPORTS       */

// import a kevlar file in project
use "@/path/to/file";            // absolute path
use "./path/to/file";            // relative path

// import a kevlar file in environment
use "kevlar/std";

// import as another name
use "path/to/kevlar" as Foo;

// import and destructure
use "path/to/kevlar" as { item1, item2, item3 };      // only keep specific items
use "path/to/kevlar" as { * };                        // destructure all

// kevlar/core is automaticly imported and destructured
//use "kevlar/core" as { * }


/*      VARIABLES       */
/*
    A variable is defined using one the following format
    type name = value;
    type name;

    for the second way, a default value will be used instead. every variable definiton in this part uses the default value
*/

// primary types

/*
    you can specify allocated size for numeric primary types like this
    
    type<size> name = value;
    
    If no size is specified, default values will be used instead which are shown below

    "auto" can be used to match operating system's architecture

    Automatic type conversion happens when the conversion is lossless (e.g. int to dec)
    Non-lossless conversions needs to be forced (e,g, int to bool)
*/

int<auto> integer = 0;
uint<auto> unsignedInt = 0;
dec<64b> decimal = 0.0;
bool boolean = false;
char character = 0!;        // explination mark forces type conversion, by default char stores the null character (unicode 0)
//char character = 0(char)  // you can also specify the type to convert to

/*
    "type" is a primary type used internally to identify different variable types.
    The code shown below is invalid as you cannot define a variable in "type",
    it is intended to be used for runtime type checking.
*/
//type typeId;

const int constant = 0;          

/*
    Global variables is available anywhere in the file
    regardless where you define it.
*/
glob int global = 0;

// referenced types
/*
    There are two kinds of constructor: Function and Literal
    Function constructor is a function that returns the constructed object
    Literal constructor allows you to use custom literals to define
    more complex objects while keeping good readability.

    See CLASS section for details

    If a referenced type is not assigned a value, it will default to null.

    All primary types have their referenced type counterpart.
    Boxing/Unboxing will be done automaticly
    Memory size is now passed as a parameter

    Referenced variables are by default de-referenced when used, except for a few cases:
    1. When assigning as value to another variable, this creates a copy pointer
    2. When assigned a new value, this will pass the pointer
    3. When passes as parameter, this creates a copy pointer
    4. When used on comparason operators, this will instead compare pointer instead.
       Comparing an owner pointer to copy pointer of the same heap memory returns true;
*/

Object func = new Object();   // function constructor
Object liter = Object{         // literals consturctor
    item1: ${item1},
    item2: ${item2},

    /*
        Custom literals means you can define your own syntax for constructing
        an object. It can be quite powerful if used right.
        Only syntax a literal consturctor needs to respect are comments and escapes( ${} ) 
        used to pass outside variables.
    */
}

// both double and single quotes can be used to define a string. They have different escapes.
String doubleQuoteStr = "abc";
String singleQuoteStr = 'abc';

// union typing
Type1 | Type2 | Type3 unionTypeVar;

/*      OPERATORS       */ 
/*
        Assignment operators
    Include all assignment operators in C++
    <-          Transfer memory ownership
    <~          Dereference and assign value
    drop        Delete variable
    ...         Spread operation
    \=          Swap values

        Arithmetic Operators
    Include all Arithmetic operators in C++
    **          Exponent
    _/          Root

        Comparason Operators
    Include all Comparason Operators in C++

        Logical Operators
    Include all Logical Operators in C++

        Bitwise Operators 
    Include all bitwise operators in c++

        Increment/Decrement Operators
    Same as C++

        Contional Operator
    Same as C++

        Type Operators
    <value>!    Force type conversion based on context
    (<type>)    Force type conversion to specified type

*/


/*      FLOW CONTROL    */
// Kevlar uses the same set of logic statements as C, here we will skip them to save space

/*
    Anonymous function is defined using this syntax:
    [$passByValue, @passByReference, auto](type param1, type param2)<returnType> => {
        // do something
        return someValue;
    }
    null can be used as a return type to indicate no return
    scope capture bracket is optional. If not specified, compiler will automaticly capture scope
    Auto-captured variables follow this rule: all primaries are pass by value, and any references 
    are pass by reference.
    auto can be specified in capturing bracket to allow implicit capturing
*/
(int param1, String param2)<int<32B>> => {
    // do something
    return 1;
}

/*
    Regular function is defined like this:
    function returnType name(type param1, type param2){
        // do something
    }
    A regular function only have access to global variables
*/
function null foo(int param1, Object param2){
    
}

// used for future testing
function null println(Object value){
    // implement print logic
}

/*      MEMORY MANAGEMENT     */
/*
    Kevlin uses a unique runtime contentID-ownership system as mentioned in the start
    Every heap memory content have an id and an owner.
    When you assign a variable to a referenced variable, a copy pointer is assigned.
    Copies have slight performance overhead when accessed
*/
Object funcCopy = func;

/*
    Owner variable is responsible for the lifetime of the heap memory.
    If owner no longer used, assigned a new value, or manually 
    deallocated, its memory is freed. After that, an attempt to use 
    any copy will result in crashing.
*/
drop func;      // this deletes the owner variable and therefore the heap memory
//foo(0, funcCopy);         // this will crash the program since funcCopy's owner is deallocated

/*
    You can skip copy pointer id checking for better performance
    THIS IS MEMORY UNSAFE, USE WITH CAUTION
*/
//foo(0, (!direct funcCopy));          // causes undefined behaviour

// ownership can also be transfered
String newStr <- doubleQuoteStr;                        // transfer ownership, original variable now holds a copy
String newSingleStr <- singleQuoteStr = "other value";  // transfer ownership and assign a new value
newStr <- drop singleQuoteStr;                          // transfer ownership and deletes variable

/*
    content identifiers will eventually run out, requiring a global reset.
    During the reset, performance is reduced. Because of this, we allow
    developers to indicate when will be the best time to do the global reset.

    If there are no indication, global reset will be delayed as far as possible,
    but it will happen inevitably. 
    
    Reusing already allocated memory space is encouraged, as creating new
    pointers consumes available IDs. When id pool reduces to a certain amount,
    a global reset will be performed to continue to ensure memory safety.

    However the exact notation isn't determined yet, check back later.
*/

// reuse memory space
newStr <~ "12345"

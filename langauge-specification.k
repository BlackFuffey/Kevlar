/*
        Welcome to Slime langauge specification!
        Slime is a high level programming langauge that
        aims to combine great flexibility while providing
        high performance.
        
        This document demonstrates all syntax in slime.
*/

/*
        Slime uses a special memory management system
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

/*      IMPORTING       */

// import a slime file in project
use "@/path/to/file"            // absolute path
use "./path/to/file"            // relative path

// import a slime file in environment
use "slime/std"

// import as another name
use "path/to/slime" as Foo

// import and destructure
use "path/to/slime" as { item1, item2, item3 }      // only keep specific items
use "path/to/slime" as { * }                        // destructure all

// slime/core is automaticly imported and destructured
//use "slime/core" as { * }


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
    
    If no size is used, default values will be used instead which are shown below
    "auto" can be used to match operating system's architecture
*/
int<auto> integer = 0;
uint<auto> unsignedInt = 0;
dec<64b> decimal = 0.0;



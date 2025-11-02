# Arolyme
A flexible, memory safe, and performant high level programming langauge \
(Still work in progress) \
\
This repository soly consist of documentation for Arolyme's syntax and standard library (not here yet) \
For compiler, see [Polymerizer](https://github.com/BlackFuffey/Polymerizer)

Please note this is highly incomplete and some design decisions may change.

## Why Arolyme?
 - **Ease of use**: Arolyme is designed to be declarative, clear, and flexible. You can take advantage of the high-level
                    functionalities to make performant prototypes, or express low level logic with clear syntax.  
 - **Memory safe**: Arolyme ensures memory safety through a content ID memory management system. This allows the langauge to
                    abstract away memory management while keeping good performance.

I created Arolyme because I am unhappy about multiple things in existing langauges, and I have some interesting ideas. \
\
Existing languages have a "Pick-two" trade off regarding: Memory safety, performance, and ease of use. \
Currently no langauge satisfy all 3: 
- Rust is memory safe and performant, but is not easy to use due to it's ownership system.
- JIT/Intepreted langauges is memory safe and (mostly) easy to use, but they are not suitable for performance crucial things. 
- Swift is one of the very few langauges that nearly fullfills all 3. However reference counting still needs weak pointer to prevent deadlock, and therefore may not 100% memory safe and can be hard to use in some cases. Swift also has limited support on non Apple platforms

Arolyme aims to solve this using it's own unique memory management system: Content ID. For details, see specification.kev

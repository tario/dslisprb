dslisprb (dseminara 'lisp) 
http://github.com/tario/dslisprb
Dario Seminara (http://tario-project.blogspot.com.ar/)

== DESCRIPTION ==

dseminara 'lisp is my own implementation of lisp on ruby, created as an excercise in preparation for finals

dslisprb try to be minimalist (only 200 lines of ruby code including parser, default 
functions and macros and about 30 lines for the repl) by using ruby code generation where possible

For example, lisp lambdas are represented as ruby lambdas defined with the code translated from lisp to ruby
and lisp variables (including those where default functions/lambda are stored) are translated as ruby variables
allowing reuse of the ruby stack instead of reimplement it 

== FEATURES ==
  
* dslisprb executable with readline
* Basic common lisp functions

== TODO ==

* MAPCAR
* Defined functions and variable persistent between multiple evaluate calls
* caaaar, cdadar, cddra, etc...

== SYNOPSIS ==

See 'dslisprb --help' for usage information.

== REQUIREMENTS ==

* Ruby

== INSTALL ==

* gem install dslisprb

== LICENSE ==

(The MIT License)

Copyright (c) 2012 Dario Seminara

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


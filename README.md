Bitset.lua
==========

Bitsets (aka bitstrings or bitmaps) implemented in pure Lua.
Requires LuaJIT or Lua 5.1/5.2 with [BitOp](http://bitop.luajit.org/).

Examples
--------

    ---------------------------
    -- Basics
    ---------------------------

    -- Load the library
    local bslib = require 'bitset'

    -- Initialize a new bitset
    local set_a = bslib:new()

    -- Set bits
    set_a:set(10)
    set_a:set(12, 14, 16, 17, 18)

    -- Clear bits
    set_a:clear(17)

    -- Read bits
    set_a:get(10)
    ---> true
    set_a:get(11, 12, 13)
    ---> {false, true, false}

    ---------------------------
    -- Common set operations
    ---------------------------

    local set_b = bslib:new():set(14, 15, 16, 17)

    set_a:inter(set_b)
    ---> bitset: {14, 16}

    set_a:union(set_b)
    ---> bitset: {10, 12, 14, 15, 16, 17, 18}

    set_a:diff(set_b)
    ---> bitset: {10, 12, 18}

Testing
-------

You need telescope >= 0.5 to run tests, install it via:

    $ sudo luarocks install telescope

Run tests via:

    $ make test

To run benchmarks, try:

    $ make benchmark

Licence
-------

    Copyright (c) 2013 Black Square Media Ltd

    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

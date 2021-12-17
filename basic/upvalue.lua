#!/usr/local/bin/lua

function Create(n) 
    local function foo1() 
      print(n) 
    end
    local function foo2() 
      n = n + 10 
    end
    return foo1,foo2
  end

n = 100;
f1,f2 = Create(n)
f1() -- 打印1979
f2() f1() -- 打印1989
f2() f1() -- 打印1999
print(n);
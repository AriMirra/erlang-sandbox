-module(records).
-compile(export_all).

-record(person, { name, age }).

first_person() ->
  #person{name = "Juan", age = 25}.

edad(#person{age = 0}) -> "recién nacido";
edad(#person{age = A}) -> A.

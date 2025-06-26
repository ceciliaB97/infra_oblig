with Ada.Text_IO; use Ada.Text_IO;
procedure Main is
Task patio is
entry pedir;
entry devolver;
End patio;
Task body patio is
en_el_patio:Integer := 0;
begin
loop
select when en_el_patio < 2 => accept pedir;
en_el_patio := en_el_patio + 1;
or
accept devolver;
en_el_patio := en_el_patio - 1;
end select;
end loop;
end patio;
Task Alice is
end Alice;
Task body Alice is
begin
loop
patio.pedir;
Put_Line ("Empieza A");
delay 3.0;
Put_Line ("Finaliza A");
patio.devolver;
end loop;
end Alice;
Task Bob is
end Bob;
Task body Bob is
begin
      loop
         begin
loop
patio.pedir;
Put_Line ("Empieza B");
delay 2.0;
Put_Line ("Finaliza B");
patio.devolver;
end loop;
end Bob;
Task Charlie is
end Charlie;
Task body Charlie is
begin
loop
patio.pedir;
Put_Line ("Empieza C");
delay 1.0;
Put_Line ("Finaliza C");
patio.devolver;
end loop;
end Charlie;
Task Darla is
end Darla;
Task body Darla is
begin
loop
patio.pedir;
Put_Line ("Empieza D");
Put_Line ("Finaliza D");
patio.devolver;
end loop;
end Darla;
begin
null;
end Main;

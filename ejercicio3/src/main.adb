with Ada.Text_IO;
use Ada.Text_IO;

procedure Main is

   -- Definimos constantes
   Max_Cajas : constant Integer := 4;
   Max_Cola  : constant Integer := 10;

   -- Task type para definir el comportamiento de cada caja
   task type Caja is
      entry Atender_Cliente(Id : Integer; Num_Caja : Integer);
   end Caja;

   task body Caja is
      Ocupada : Boolean := False;
   begin
      loop
         select
            accept Atender_Cliente(Id : Integer; Num_Caja : Integer) do
               if not Ocupada then
                  Ocupada := True;
                  Put_Line("Persona " & Integer'Image(Id) & " ingresó a la caja " & Integer'Image(Num_Caja));
                  delay 2.0 + Standard.Duration(Id mod 4); -- Simula tiempo aleatorio entre 2 y 5 segundos
                  Put_Line("Persona " & Integer'Image(Id) & " saliendo de la caja " & Integer'Image(Num_Caja));
                  Ocupada := False;
               end if;
            end Atender_Cliente;
         or
            terminate;
         end select;
      end loop;
   end Caja;

   -- Instancias de las 4 cajas
   Cajas : array(1..Max_Cajas) of Caja;

   -- Task para la cola de espera y generación de personas
   task Cola is
      entry Agregar_Cliente(Id : Integer);
      entry Retirar_Cliente(Id : out Integer);
   end Cola;

   task body Cola is
      Num_Clientes : Integer := 0;
      Lista_Clientes : array(1..Max_Cola) of Integer;
   begin
      loop
         select
            accept Agregar_Cliente(Id : Integer) do
               if Num_Clientes < Max_Cola then
                  Num_Clientes := Num_Clientes + 1;
                  Lista_Clientes(Num_Clientes) := Id;
                  Put_Line("Usuario " & Integer'Image(Id) & " entra a la cola de espera.");
               else
                  Put_Line("Cola llena, no se permiten más usuarios.");
                  delay Standard.Duration(Id mod 3); -- Espera aleatoria antes de intentar ingresar de nuevo
               end if;
            end Agregar_Cliente;
         or
            accept Retirar_Cliente(Id : out Integer) do
               if Num_Clientes > 0 then
                  Id := Lista_Clientes(1);
                  for I in 1..Num_Clientes - 1 loop
                     Lista_Clientes(I) := Lista_Clientes(I + 1);
                  end loop;
                  Num_Clientes := Num_Clientes - 1;
                  Put_Line("Usuario " & Integer'Image(Id) & " sale de la cola de espera.");
               end if;
            end Retirar_Cliente;
         end select;
      end loop;
   end Cola;

   -- Task para simular la llegada de personas
   task type Persona is
      entry Ingresar(Id : Integer);
   end Persona;

   task body Persona is
   begin
      accept Ingresar(Id : Integer) do
         Cola.Agregar_Cliente(Id);
      end Ingresar;
   end Persona;


--begin Main
begin
   Put("Ingrese la cantidad de personas a crear: ");
   declare
      Num_Personas : Integer;
   begin
      Num_Personas := Integer'Value(Get_Line);
      --Get(Num_Personas);

      for Id in 1..Num_Personas loop
         declare
         begin
            --Persona'(Ingresar(Id));
            --Persona.Ingresar(Id);
            Cola.Agregar_Cliente(Id);
         end;
         delay 2.0 + Standard.Duration(Id mod 3); -- Simulación de llegada aleatoria
      end loop;

      for Id in 1..Num_Personas loop
         declare
            Cliente : Integer;
            Num_Caja : Integer;
         begin
            Cola.Retirar_Cliente(Cliente);
            Num_Caja := (Cliente mod Max_Cajas) + 1;
            Cajas(Num_Caja).Atender_Cliente(Cliente, Num_Caja);
         end;
         delay 2.0 + Standard.Duration(Id mod 3); -- Simulación de llegada aleatoria
      end loop;
   end;

end Main;

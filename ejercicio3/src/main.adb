
with Ada.Text_IO;
use Ada.Text_IO;

procedure Main is

   -- Definimos constantes
   Max_Cajas : constant Integer := 4;
   Max_Cola  : constant Integer := 10;

   -- Task type para definir el comportamiento de cada caja
   task type Caja is
      entry Atender_Cliente(Id : Integer; Num_Caja : Integer);
      entry Despachar_Cliente(Id : out Integer; Num_Caja : out Integer);
   end Caja;

   task body Caja is
      Ocupada : Boolean := False;
      Id_Cliente, Num_Caja_Actual : Integer := 0;
   begin
      loop
         select when not Ocupada =>
               accept Atender_Cliente (Id : Integer; Num_Caja : Integer) do
                  Ocupada := True;
                  Id_Cliente := Id;
                  Num_Caja_Actual := Num_Caja;
                  Put_Line("Persona " & Integer'Image(Id) & " ingresó a la caja " & Integer'Image(Num_Caja));
                  delay 2.0 + Standard.Duration(Id mod 4); -- Simula tiempo aleatorio entre 2 y 5 segundos
                  --Put_Line("Persona " & Integer'Image(Id) & " saliendo de la caja " & Integer'Image(Num_Caja));
                  --Ocupada := False;
            end Atender_Cliente;
         or
              when Ocupada =>
              accept Despachar_Cliente(Id : out Integer; Num_Caja : out Integer) do
                  --Ocupada := True;
                  --Put_Line("Persona " & Integer'Image(Id) & " ingresó a la caja " & Integer'Image(Num_Caja));
                  --delay 2.0 + Standard.Duration(Id mod 4); -- Simula tiempo aleatorio entre 2 y 5 segundos
                  Id := Id_Cliente;
                  Num_Caja := Num_Caja_Actual;
                  Put_Line("Persona " & Integer'Image(Id) & " saliendo de la caja " & Integer'Image(Num_Caja));
                  --Ocupada := False;
            end Despachar_Cliente;
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
      Tamanio, Frente, Fondo : Integer := 0;
      Lista_Clientes : array(1..Max_Cola) of Integer;
   begin
      loop
         select when Tamanio < Max_Cola =>
               accept Agregar_Cliente(Id : Integer) do
                  Fondo := (Fondo mod Max_Cola) + 1;
                  Lista_Clientes(Fondo) := Id;
                  Tamanio := Tamanio + 1;
                  Put_Line("Usuario " & Integer'Image(Id) & " entra a la cola de espera.");
            end Agregar_Cliente;
         or
            when Tamanio > 0 =>
               accept Retirar_Cliente(Id : out Integer) do
                  Frente := (Frente mod Max_Cola) + 1;
                  Id := Lista_Clientes(Frente);
                  Tamanio := Tamanio - 1;
                  Put_Line("Usuario " & Integer'Image(Id) & " sale de la cola de espera.");
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
         delay 2.0 + Standard.Duration(Id mod 3); -- Simulación de llegada aleatoria
      end Ingresar;
   end Persona;

--begin Main
begin
   Put("Ingrese la cantidad de personas a crear: ");
   declare
      Num_Personas : Integer;
   begin
      Num_Personas := Integer'Value(Get_Line);

      -- Llenar la cola primero antes de empezar el proceso
      for I in 1..Max_Cola loop
         declare
            P : Persona;
         begin
            P.Ingresar(I);
         end;
      end loop;

      Put_Line("Cola de espera llena, comenzando asignación a cajas...");

      -- Asignación a cajas en paralelo
      for I in 1..Num_Personas loop
         declare
            Cliente : Integer;
         begin
            Cola.Retirar_Cliente(Cliente);
            Cajas((Cliente mod Max_Cajas) + 1).Atender_Cliente(Cliente, (Cliente mod Max_Cajas) + 1);
         end;
      end loop;

      -- Despacho distribuido de clientes, asegurando que otros clientes salgan primero
      loop
         delay 2.0;
         for I in 1..Max_Cola loop
            declare
               Cliente : Integer;
               Num_Caja : Integer;
            begin
               delay 1.5; -- Evita que el cliente salga enseguida
               Num_Caja := (I mod Max_Cajas) + 1;
               Cajas((I mod Max_Cajas) + 1).Despachar_Cliente(Cliente, Num_Caja);
            end;
         end loop;
      end loop;

   end;
end Main;

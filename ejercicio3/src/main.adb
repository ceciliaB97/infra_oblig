with Ada.Text_IO;
use Ada.Text_IO;

procedure Main is

   -- Definimos constantes
   Max_Cajas : constant Integer := 4;
   Max_Cola  : constant Integer := 10;
   type Persona_ID is new Integer;


   -- Task para la cola de espera y generación de personas
   task Cola is
      entry Agregar_Cliente(Id : Persona_ID; Ya_Entro : out Boolean);
      entry Retirar_Cliente(Id : out Persona_ID);
   end Cola;

   -- Task type para definir el comportamiento de cada caja
   task type Caja is
      entry Atender_Cliente(Id : Persona_ID; Num_Caja : Integer);
      entry Despachar_Cliente(Id : out Persona_ID; Num_Caja : out Integer);
   end Caja;

   -- Task para simular la llegada de personas
   task type Persona(Id: Persona_ID) is
      entry Ingresar(Id : Persona_ID);
   end Persona;

   task body Caja is
      Ocupada : Boolean := False;
      Id_Cliente : Persona_ID := 0;
      Num_Caja_Actual : Integer := 0;

   begin
      loop
         select when not Ocupada =>
               accept Atender_Cliente (Id : Persona_ID; Num_Caja : Integer) do
                  Put_Line("Usuario " & Persona_ID'Image(Id) & " sale de la cola de espera.");
                  Id_Cliente := Id;
                  Cola.Retirar_Cliente(Id_Cliente);
                  Ocupada := True;
                  Num_Caja_Actual := Num_Caja;
                  Put_Line("Persona " & Persona_ID'Image(Id) & " ingresó a la caja " & Integer'Image(Num_Caja));

                  delay 2.0 + Standard.Duration(Id mod 4); -- Simula tiempo aleatorio entre 2 y 5 segundos
                  --Put_Line("Persona " & Integer'Image(Id) & " saliendo de la caja " & Integer'Image(Num_Caja));
                  --Ocupada := False;
            end Atender_Cliente;
         or
              when Ocupada =>
              accept Despachar_Cliente(Id : out Persona_ID; Num_Caja : out Integer) do

                  --Ocupada := True;
                  --Put_Line("Persona " & Integer'Image(Id) & " ingresó a la caja " & Integer'Image(Num_Caja));
                  --delay 2.0 + Standard.Duration(Id mod 4); -- Simula tiempo aleatorio entre 2 y 5 segundos
                  Id := Id_Cliente;
                  Num_Caja := Num_Caja_Actual;
                  Put_Line("Persona " & Persona_ID'Image(Id) & " saliendo de la caja " & Integer'Image(Num_Caja));

                  --Ocupada := False;
            end Despachar_Cliente;
         or
            terminate;
         end select;
      end loop;
   end Caja;

   -- Instancias de las 4 cajas
   Cajas : array(1..Max_Cajas) of Caja;


   task body Cola is
      Tamanio, Frente, FrenteCajas, Fondo : Integer := 0;
      Lista_Clientes : array(1..Max_Cola) of Persona_ID;
   begin
      loop
         if Tamanio < Max_Cola then
         --select when Tamanio < Max_Cola =>
           accept Agregar_Cliente(Id : Persona_ID; Ya_Entro : out Boolean) do
                  Fondo := (Fondo mod Max_Cola) + 1;
                  Lista_Clientes(Fondo) := Id;
                  Tamanio := Tamanio + 1;
                  Ya_Entro := True;
                  Put_Line("Usuario " & Persona_ID'Image(Id) & " entra a la cola de espera.");
                  --if Tamanio = Max_Cola then
                     --FrenteCajas := (FrenteCajas mod Max_Cajas);
                     --Cajas(1).Atender_Cliente(Id, 1);
                  --end if;
            end Agregar_Cliente;
         else
        -- or
        --when Tamanio > 0 or Tamanio = Max_Cola =>
        --or
            accept Retirar_Cliente(Id : out Persona_ID) do
                  Put_Line("accept retirar cliente");
                  Id := Lista_Clientes(Frente);
                  FrenteCajas := (FrenteCajas mod Max_Cajas);
                  Cajas(FrenteCajas).Atender_Cliente(Id, FrenteCajas);
                  Frente := (Frente mod Max_Cola) + 1;
                  Tamanio := Tamanio - 1;

            end Retirar_Cliente;
            --end select;
            end if;
      end loop;
   end Cola;

   -- Task para simular la llegada de personas
   task type Persona(Id: Persona_ID) is
      entry Ingresar(Id : Persona_ID);
   end Persona;

   task body Persona is
      Ya_Entro : Boolean := False;
   begin
         accept Ingresar(Id : Persona_ID) do
            loop
            Cola.Agregar_Cliente(Id, Ya_Entro);
            exit when Ya_Entro;

               delay 2.0 + Standard.Duration(Id mod 3); -- Simulación de llegada aleatoria
            end loop;
      end Ingresar;
   end Persona;

      --begin Main
      Num_Personas : Integer;
begin
   Put("Ingrese la cantidad de personas a crear: ");
   Num_Personas := Integer'Value(Get_Line);
   declare
   begin
      -- Llenar la cola primero antes de empezar el proceso
      for I in 1..Num_Personas loop
         declare
            P : Persona(Persona_ID(I));
         begin
            P.Ingresar(Persona_ID(I));
            delay 1.0;
         end;
      end loop;
   end;
end Main;

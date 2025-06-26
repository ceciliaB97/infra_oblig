with Ada.Text_IO;
use Ada.Text_IO;

procedure Main is

   -- Definimos constantes
   Max_Cajas : constant Integer := 4;
   Max_Cola  : constant Integer := 10;
   type Persona_ID is new Integer;

   Cant_Total_Personas_Ingresadas : Integer := 0;
   Cant_Total_Personas_Programa : Integer := 0;

   -- Task para la cola de espera y generación de personas
   task Cola is
      entry Agregar_Cliente(Id : Persona_ID; Ya_Entro : out Boolean; Id_Salida : out Persona_ID);
      --entry Retirar_Cliente(Id : out Persona_ID);
   end Cola;

   -- Task type para definir el comportamiento de cada caja
   task type Caja is
      entry Atender_Cliente(Id : Persona_ID; Num_Caja : Integer; Id_Salida : out Persona_ID; Num_Caja_Salida : out Integer);
      --entry Despachar_Cliente(Id : out Persona_ID; Num_Caja : out Integer);
   end Caja;

   -- Task para simular la llegada de personas
   task type Persona(Id: Persona_ID) is
      entry Ingresar(Id : Persona_ID);
   end Persona;

   task body Caja is
      Ocupada : Boolean := False;
      Id_Cliente, Id_Salida : Persona_ID := 0;
      Num_Caja_Actual : Integer := 0;
      Ya_Entro : Boolean := True;

   begin
      loop
         accept Atender_Cliente (Id : Persona_ID; Num_Caja : Integer; Id_Salida : out Persona_ID; Num_Caja_Salida : out Integer) do
            if not Ocupada then
               if Integer(Id) > 0 then
                  Put_Line("Usuario " & Persona_ID'Image(Id) & " sale de la cola de espera.");
                  Id_Cliente := Id;
                  Id_Salida := Persona_Id(Id);
                  Ocupada := True;
                  Num_Caja_Actual := Num_Caja;
                  Put_Line("Persona " & Persona_ID'Image(Id) & " ingresó a la caja " & Integer'Image(Num_Caja));
                  delay 2.0 + Standard.Duration(Id mod 4); -- Simula tiempo aleatorio entre 2 y 5 segundos
                 end if;
            else
                  Id_Salida := Id_Cliente;
                  Num_Caja_Salida := Num_Caja_Actual;
                  Put_Line("Persona " & Persona_ID'Image(Id_Salida) & " saliendo de la caja " & Integer'Image(Num_Caja_Salida));
                  Ocupada := False;
            end if;
            end Atender_Cliente;

      end loop;
   end Caja;

   -- Instancias de las 4 cajas
   Cajas : array(1..Max_Cajas) of Caja;


   task body Cola is
      Tamanio, Frente, FrenteCajas, Fondo, Num_Caja_Salida : Integer := 0;
      Lista_Clientes : array(1..Max_Cola) of Persona_ID;
   begin
      loop
         accept Agregar_Cliente(Id : Persona_ID; Ya_Entro : out Boolean; Id_Salida : out Persona_ID) do
            --Put_Line("Cant_Total_Personas_Ingresadas: " & Integer'Image(Cant_Total_Personas_Ingresadas));
            if Tamanio < Max_Cola and (Cant_Total_Personas_Ingresadas /= Cant_Total_Personas_Programa) then
                  Fondo := (Fondo mod Max_Cola) + 1;
                  Lista_Clientes(Fondo) := Id;
                  Fondo := Fondo;
                  Tamanio := Tamanio + 1;
                  Ya_Entro := True;
                  Put_Line("Usuario " & Persona_ID'Image(Id) & " entra a la cola de espera.");
            else
               if Tamanio = Max_Cola then
                  Put_Line("Cola de espera llena, no se permiten más personas por ahora. ");
               end if;
                  Frente := Frente + 1;
                  Id_Salida := Persona_ID(Lista_Clientes(Frente));
                  FrenteCajas := (FrenteCajas mod Max_Cajas) + 1;
                  Cajas(FrenteCajas).Atender_Cliente(Lista_Clientes(Frente), FrenteCajas, Id_Salida, Num_Caja_Salida);
                  Tamanio := Tamanio - 1;
               end if;
            end Agregar_Cliente;
      end loop;
   end Cola;


   task body Persona is
      Ya_Entro : Boolean := False;
      Id_Salida : Persona_ID := 0;
   begin
         accept Ingresar(Id : Persona_ID) do
         loop
            Id_Salida := Id;
            Cola.Agregar_Cliente(Id, Ya_Entro, Id_Salida);
            exit when Ya_Entro;
            delay 2.0 + Standard.Duration(Id mod 3); -- SimulaciÃ³n de llegada aleatoria
         end loop;
      end Ingresar;
   end Persona;

      --begin Main
      Num_Personas : Integer;
begin
   Put("Ingrese la cantidad de personas a crear: ");
   Num_Personas := Integer'Value(Get_Line);
   Cant_Total_Personas_Programa := Num_Personas;
   declare
   begin
      -- Llenar la cola primero antes de empezar el proceso
      for I in 1..Num_Personas loop
         declare
            P : Persona(Persona_ID(I));
         begin
            Cant_Total_Personas_Ingresadas := Cant_Total_Personas_Ingresadas + 1;
            P.Ingresar(Persona_ID(I));
            delay 1.0;
         end;
      end loop;
   end;
end Main;

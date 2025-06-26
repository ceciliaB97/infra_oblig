with Ada.Text_IO;
use Ada.Text_IO;

procedure Main is

   -- Definimos constantes
   Max_Cajas : constant Integer := 4;
   Max_Cola  : constant Integer := 10;
   type Persona_ID is new Integer;


   -- Task para la cola de espera y generación de personas
   task Cola is
      entry Agregar_Cliente(Id : Persona_ID; Ya_Entro : out Boolean; Id_Salida : out Persona_ID);
      --entry Retirar_Cliente(Id : out Persona_ID);
   end Cola;

   task Cajas is
      entry Entrar_A_Cajas;
      entry Salir_De_Cajas;
   end Cajas;

   -- Task para simular la llegada de personas
   task type Persona(Id: Persona_ID) is
      entry Ingresar(Id : Persona_ID);
   end Persona;

   task body Cajas is
      En_Una_Caja : Integer := 0;
      Id_Cliente, Id_Salida : Persona_ID := 0;
      Num_Caja_Actual : Integer := 0;
      Ya_Entro : Boolean := True;

   begin
      loop
         select when En_Una_Caja < 4 => accept Entrar_A_Cajas (Id : Persona_ID; Num_Caja : Integer; Id_Salida : out Persona_ID; Num_Caja_Salida : out Integer) do
            En_Una_Caja := En_Una_Caja + 1;

            Put_Line("Usuario " & Persona_ID'Image(Id) & " sale de la cola de espera y va hacia una caja.");
            Id_Cliente := Id;
            Id_Salida := Persona_Id(Id);
            Ocupada := True;
            Num_Caja_Actual := Num_Caja;
            Put_Line("Persona " & Persona_ID'Image(Id) & " ingresó a la caja " & Integer'Image(Num_Caja));

            delay 2.0 + Standard.Duration(Id mod 4); -- Simula tiempo aleatorio entre 2 y 5 segundos
         Or accept Salir_De_Cajas;

            En_Una_Caja := En_Una_Caja - 1;
            Id_Salida := Id_Cliente;
            Num_Caja_Salida := Num_Caja_Actual;
            Put_Line("Persona " & Persona_ID'Image(Id_Salida) & " saliendo de la caja " & Integer'Image(Num_Caja_Salida));
               end Entrar_A_Cajas;
               or terminate;
         end select;
      end loop;
   end Cajas;


   task body Cola is
      Tamanio, Frente, FrenteCajas, Fondo, Num_Caja_Salida : Integer := 0;
      Lista_Clientes : array(1..Max_Cola) of Persona_ID;
   begin
      loop
         accept Agregar_Cliente(Id : Persona_ID; Ya_Entro : out Boolean; Id_Salida : out Persona_ID) do
            Put_Line("Tamanio de cola" & Integer'Image(Tamanio));

                  Fondo := (Fondo mod Max_Cola) + 1;
                  Lista_Clientes(Fondo) := Id;
                  Fondo := Fondo;
                  Tamanio := Tamanio + 1;
                  Ya_Entro := True;
                  Put_Line("Usuario " & Persona_ID'Image(Id) & " entra a la cola de espera.");

               --delay 2.0 + Standard.Duration(Id mod 3); -- SimulaciÃ³n de llegada aleatoria

               if Tamanio = Max_Cola then
                  Put_Line("Cola de espera llena, no se permiten más personas por ahora. ");
               end if;

                  Frente := Frente + 1;
                  Id_Salida := Persona_ID(Lista_Clientes(Frente));
                  FrenteCajas := (FrenteCajas mod Max_Cajas) + 1;
                  Cajas.Entrar_A_Cajas(Lista_Clientes(Frente), FrenteCajas, Id_Salida, Num_Caja_Salida);
               Tamanio := Tamanio - 1;
               delay 2.0 + Standard.Duration(Id mod 3);
               Cajas.Salir_De_Cajas;


            end Agregar_Cliente;
            --end select;
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

               -- aca no va delay 2.0 + Standard.Duration(Id mod 3); -- SimulaciÃ³n de llegada aleatoria
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

with Ada.Text_IO;
use Ada.Text_IO;

procedure Main is

   -- Definimos constantes
   Max_Cajas : constant Integer := 4;
   Max_Cola  : constant Integer := 10;
   type Persona_ID is new Integer;

   Aun_Hay_Personas_A_Procesar : Boolean := True;
   Entro_Ultima_Persona_En_Cola : Boolean := True;
   Cant_Cajas_En_Uso : Integer := 0;
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
                  Cant_Cajas_En_Uso := Cant_Cajas_En_Uso + 1;
                  delay 2.0 + Standard.Duration(Id mod 4); -- Simula tiempo aleatorio entre 2 y 5 segundos
                 end if;
            else
                  Id_Salida := Id_Cliente;
                  Num_Caja_Salida := Num_Caja_Actual;
                  Put_Line("Persona " & Persona_ID'Image(Id_Salida) & " saliendo de la caja " & Integer'Image(Num_Caja_Salida));
                  Ocupada := False;
                  Cant_Cajas_En_Uso := Cant_Cajas_En_Uso - 1;
                  If Integer(Id_Salida) = Cant_Total_Personas_Programa then
                      Aun_Hay_Personas_A_Procesar := True;
                  end if;
            end if;
            Put_Line("****Cant_Cajas_En_Uso: " & Integer'Image(Cant_Cajas_En_Uso));

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
            --(Cant_Total_Personas_Ingresadas /= Cant_Total_Personas_Programa)
            Put_Line("****Cant_Total_Personas_Ingresadas: " & Integer'Image(Cant_Total_Personas_Ingresadas)
                     & ", Aun_Hay_Personas_A_Ingresar: " & Boolean'Image(Aun_Hay_Personas_A_Procesar));
            if Tamanio < Max_Cola and not Entro_Ultima_Persona_En_Cola then
                  Fondo := (Fondo mod Max_Cola) + 1;
                  Lista_Clientes(Fondo) := Id;
                  Fondo := Fondo;
                  Tamanio := Tamanio + 1;
                  Ya_Entro := True;
               Put_Line("Usuario " & Persona_ID'Image(Id) & " entra a la cola de espera.");
               if Integer(Id) <= Cant_Total_Personas_Programa then
                  Entro_Ultima_Persona_En_Cola := True;
                  end if;
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
      Put_Line("****cant total de personas a ingresar es: " & Integer'Image(Cant_Total_Personas_Programa));
      -- Llenar la cola primero antes de empezar el proceso
      --for I in 1..Num_Personas loop
      loop
         declare
            --P : Persona(Persona_ID(I));
            P : Persona(Persona_ID(Cant_Total_Personas_Ingresadas));
         begin
            Cant_Total_Personas_Ingresadas := Cant_Total_Personas_Ingresadas + 1;
            --If Cant_Total_Personas_Ingresadas = Cant_Total_Personas_Programa then
               --Aun_Hay_Personas_A_Ingresar := False;
            --end if;
            if not Aun_Hay_Personas_A_Procesar and (Cant_Cajas_En_Uso = 0) and Entro_Ultima_Persona_En_Cola then
               Put_Line("****Ya no hay más personas para procesar, se termió el programa");
               exit;
            end if;
            --P.Ingresar(Persona_ID(I));
            P.Ingresar(Persona_ID(Cant_Total_Personas_Ingresadas));
            delay 1.0;
         end;
      end loop;
   end;
end Main;

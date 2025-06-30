with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is

   Max_Cola  : constant Integer := 10;
   Max_Cajas : constant Integer := 4;

   type Persona_ID is new Integer;
   type Estado_Cajas is array (1 .. Max_Cajas) of Boolean;

   Turno_Actual : Integer := 1;
   -- Monitor Cola

   protected Cola is
      entry Entrar(Id : Persona_ID);
      entry Salir(Id : Persona_ID);
      function Cuantos return Integer;
   private
      En_Cola : Integer := 0;
   end Cola;

   protected body Cola is
      entry Entrar(Id : Persona_ID) when En_Cola < Max_Cola is
      begin
         if En_Cola > 0 then
            Put_Line("[Cola] Hay " & Integer'Image(En_Cola) & " personas esperando.");
         end if;
         En_Cola := En_Cola + 1;
         Put_Line("Persona" & Integer'Image(Integer(Id)) & " entra a la cola de espera.");
      end Entrar;

      entry Salir(Id : Persona_ID) when En_Cola > 0 is
      begin
         En_Cola := En_Cola - 1;
         Put_Line("Persona" & Integer'Image(Integer(Id)) & " sale de la cola de espera.");
      end Salir;

      function Cuantos return Integer is
      begin
         return En_Cola;
      end Cuantos;
   end Cola;

   -- Monitor Cajas

   protected Cajas is
      entry Entrar(Numero_Caja : out Integer);
      entry Salir(Numero_Caja : Integer);
   private
      Ocupadas : Estado_Cajas := (others => False);
   end Cajas;

   protected body Cajas is
      entry Entrar(Numero_Caja : out Integer)
        when (for some I in Ocupadas'Range => not Ocupadas(I)) is
      begin
         for I in Ocupadas'Range loop
            if not Ocupadas(I) then
               Ocupadas(I) := True;
               Numero_Caja := I;
               return;
            end if;
         end loop;
      end Entrar;

      entry Salir(Numero_Caja : Integer) when true is
      begin
         if Ocupadas(Numero_Caja) then
            Ocupadas(Numero_Caja) := False;
         end if;
      end Salir;
   end Cajas;

   -- Tarea Persona

   task type Persona(Id : Persona_ID);

   task body Persona is
      Caja_Num : Integer;
   begin
      delay Duration(Id);

      loop
         if Cola.Cuantos < Max_Cola then
            Cola.Entrar(Id);
            exit;
         else
            Put_Line("Cola de espera llena, no se permiten más personas por ahora.");
            delay 2.0 + Duration(Id mod 2);
         end if;
      end loop;

      delay 5.0 + Duration(Id mod 3);

      loop
         exit when Integer(Id) = Turno_Actual;
         delay 0.1;
      end loop;

      Cajas.Entrar(Caja_Num);
      Cola.Salir(Id);
      Put_Line("Persona" & Integer'Image(Integer(Id)) & " ingresó a la caja " & Integer'Image(Caja_Num));

      Turno_Actual := Turno_Actual + 1;

      delay 3.0 + Duration(Id mod 3);

      Put_Line("Persona" & Integer'Image(Integer(Id)) & " saliendo de la caja " & Integer'Image(Caja_Num));
      Cajas.Salir(Caja_Num);

   end Persona;

   -- Main

   Num_Personas : Integer;
begin
   Put("Ingrese la cantidad de personas a crear: ");
   Get(Num_Personas);
   New_Line;

   declare
      type Persona_Ptr is access Persona;
      Personas : array(1 .. Num_Personas) of Persona_Ptr;
   begin
      for I in 1 .. Num_Personas loop
         Personas(I) := new Persona(Persona_ID(I));
         delay 1.0;
      end loop;

      delay 40.0;
   end;

   Put_Line("Simulación terminada");
end Main;

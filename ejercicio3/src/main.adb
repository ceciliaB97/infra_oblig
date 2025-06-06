with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
   LargoCajas : constant Integer := 4;
   LargoCola  : constant Integer := 10;
   CantidadPersonas : constant Integer := 15;

   -----------------------------------------
   -- Task de caja genérica
   -----------------------------------------
   task type Caja is
      entry AtenderCliente(IdPersona : Integer; IdCaja : Integer);
   end Caja;

   task body Caja is
      Ocupada : Boolean := False;
   begin
      loop
         select
            accept AtenderCliente(IdPersona : Integer; IdCaja : Integer) do
               if not Ocupada then
                  Ocupada := True;
                  Put_Line("Persona" & Integer'Image(IdPersona) &
                           " ingresó a la caja" & Integer'Image(IdCaja));
                  delay 2.0 + Float(IdPersona mod 4);
                  Put_Line("Persona" & Integer'Image(IdPersona) &
                           " saliendo de la caja" & Integer'Image(IdCaja));
                  Ocupada := False;
               end if;
            end AtenderCliente;
         or
            terminate;
         end select;
      end loop;
   end Caja;

   -------------------------------
   -- Crear las 4 cajas
   -------------------------------
   Cajas : array(1 .. LargoCajas) of Caja;

   -------------------------------
   -- Task Cola de espera
   -------------------------------
   task Cola is
      entry encolarCliente(IdPersona : Integer);
      entry desencolarCliente(IdPersona : out Integer);
   end Cola;

   task body Cola is
      lugaresOcupados : Integer := 0;
      clientesActuales : array(1 .. LargoCola) of Integer := (others => 0);
   begin
      loop
         select
            accept encolarCliente(IdPersona : Integer) do
               if lugaresOcupados < LargoCola then
                  lugaresOcupados := lugaresOcupados + 1;
                  clientesActuales(lugaresOcupados) := IdPersona;
                  Put_Line("Usuario" & Integer'Image(IdPersona) & " entró a la cola.");
               else
                  Put_Line("Cola llena. Usuario" & Integer'Image(IdPersona) & " no pudo entrar.");
               end if;
            end encolarCliente;
         or
            accept desencolarCliente(IdPersona : out Integer) do
               if lugaresOcupados > 0 then
                  IdPersona := clientesActuales(1);
                  for I in 1 .. lugaresOcupados - 1 loop
                     clientesActuales(I) := clientesActuales(I + 1);
                  end loop;
                  lugaresOcupados := lugaresOcupados - 1;
                  Put_Line("Usuario" & Integer'Image(IdPersona) & " sale de la cola.");
               end if;
            end desencolarCliente;
         end select;
      end loop;
   end Cola;

   -------------------------------
   -- Instancia de Cola
   -------------------------------
   ColaInstancia : Cola;

   -------------------------------
   -- Task Persona
   -------------------------------
   task type Persona is
      entry Ingresar(Id : Integer);
   end Persona;

   task body Persona is
      IdPersona : Integer;
   begin
      accept Ingresar(Id : Integer) do
         IdPersona := Id;
      end Ingresar;

      loop
         select
            ColaInstancia.encolarCliente(IdPersona);
            exit;
         or
            delay Float(IdPersona mod 4);
         end select;
      end loop;
   end Persona;

   ---------------------------------
   -- Instanciar Personas
   ---------------------------------
   Personas : array(1 .. CantidadPersonas) of Persona;

   ---------------------------------
   -- Task Despachador
   ---------------------------------
   task Despachador;

   task body Despachador is
      IdPersona : Integer;
   begin
      loop
         ColaInstancia.desencolarCliente(IdPersona);
         declare
            Asignado : Boolean := False;
         begin
            for I in Cajas'Range loop
               select
                  Cajas(I).AtenderCliente(IdPersona, I);
                  Asignado := True;
                  exit;
               or
                  delay 0.01;
               end select;
               exit when Asignado;
            end loop;
         end;
      end loop;
   end Despachador;

begin
   -- Llamar a cada persona
   for I in Personas'Range loop
      Personas(I).Ingresar(I);
   end loop;

   -- Dejar correr la simulación por 30 segundos
   delay 30.0;
   Put_Line("Fin de la simulación.");
end Main;

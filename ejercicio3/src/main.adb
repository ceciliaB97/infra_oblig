procedure Main is
   LargoCajas : Integer := 4;
   LargoCola : Integer := 10;

    -- Task de caja generica
   task type Caja is
      entry AtenderCliente(IdPersona : Integer, IdCaja : Integer);
   end Caja;

   task body Caja is
      Ocupada : Boolean := False;
   begin
      loop
         select
            accept AtenderCliente(IdPersona : Integer, IdCaja : Integer) do
               if not Ocupada then
                  Ocupada := True;
                  Put_Line("Persona " & Integer'Image(IdPersona) & " ingresï¿½ a la caja " & Integer'Image(IdCaja));
                  delay 2.0 + Float(IdPersona mod 4) --la funcion float devuelve entre 0..3 + 2 el maximo es 5
                    Put_Line("Persona " & Integer'Image(IdPersona) & " saliendo de la caja " & Integer'Image(IdCaja));
                  Ocupada := False;
               end if;
            end AtenderCliente;
         or
            terminate;
         end select;
      end loop;
   end Caja;

   -- Crear las 4 cajas a partir de caja generica
   Cajas : array(1..LargoCajas) of Caja;

   task Cola is
      entry encolarCliente(IdPersona : Integer);
      entry desencolarCliente(IdPersona : out Integer);
   end Cola;

   task body Cola is
      lugaresOcupados : Integer := 0;
      clientesActuales : array(1...LargoCola) of Integer;
   begin
      loop
         select
            accept encolarCliente(IdPersona : Integer) do
               if lugaresOcupados < LargoCola then
                  lugaresOcupados := lugaresOcupados + 1;
                  clientesActuales(lugaresOcupados) := IdPersona;
                  Put_Line("Usuario " & Integer'Image(IdPersona) & " entrï¿½ a la cola de espera.");
               else
                  Put_Line("Cola de espera llena, no se permiten mï¿½s personas por ahora.");

               end if;
            end encolarCliente;
         or
            accept desencolarCliente(IdPersona : out Integer) do
               if lugaresOcupados > 0 then
                  IdPersona := clientesActuales(1);
                  for I in 1..LargoCola - 1 loop
                     clientesActuales(I) := clientesActuales(I + 1);
                  end loop;
                  lugaresOcupados := lugaresOcupados - 1;
                  Put_Line("Usuario " & Integer'Image(Id) & " sale de la cola de espera.");
               end if;
            end desencolarCliente;
         end select;
      end loop;
   end Cola;

  task type Persona is
      entry Ingresar(Id : Integer);
   end Persona;

   task body Persona is
      IdPersona : Integer;
      Intento : Boolean := False;
   begin
      accept Ingresar(IdPersona : Integer) do
         loop
            select
               encolarCliente(IdPersona);
               exit;
            or
               delay Float(Id mod 4)
            end select;
         end loop;
      end Ingresar;
   end Persona;

   task Despachador;

   task body Despachador is
      IdPersona : Integer;
   begin
      loop
         ColaInstancia.desencolarCliente(IdPersona);
         declare
            Asignado : Boolean := False;
         begin
            -- Intentamos asignar a una caja (round-robin simple)
            for I in Cajas'Range loop
               select
                  Cajas(I).AtenderCliente(IdPersona, I);
                  Asignado := True;
                  exit;
               or
                  delay 0.01; -- Espera mínima para que no quede colgado
               end select;
               exit when Asignado;
            end loop;
         end;
      end loop;
   end Despachador;

begin
   -- Ingresan personas
   for I in Personas'Range loop
      Personas(I).Ingresar(I);
   end loop;

   -- Dejar correr el sistema un rato
   delay 30.0;
   Put_Line("Fin de la simulación.");
end Main;

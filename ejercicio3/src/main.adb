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
                  Put_Line("Persona " & Integer'Image(IdPersona) & " ingresó a la caja " & Integer'Image(IdCaja));
                  delay 2.0 + Float(Id mod 4) --la funcion float devuelve entre 0..3 + 2 el maximo es 5
                    Put_Line("Persona " & Integer'Image(IdPersona) & " saliendo de la caja " & Integer'Image(IdCaja));
                  Ocupada := False;
               end if;
            end AtenderCliente;
         or
            terminate;
         end select;
      end loop;
   end Caja;

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
                  Put_Line("Usuario " & Integer'Image(IdPersona) & " entró a la cola de espera.");
               else
                  Put_Line("Cola de espera llena, no se permiten más personas por ahora.");

               end if;
            end encolarCliente;
         end select;
      end loop;
   end Cola;
begin

end Main;

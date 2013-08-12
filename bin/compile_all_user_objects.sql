set serveroutput on

declare
  procedure compile_user_objects_of_type(  
    p_object_type USER_OBJECTS.OBJECT_TYPE%type
  ) as
    v_object_type USER_OBJECTS.OBJECT_TYPE%type := upper(p_object_type);
    dbms_output.put_line('# ' ||  v_object_type );
    cursor c1 is
      select OBJECT_NAME from USER_OBJECTS
      where OBJECT_TYPE = v_object_type;
    v_row c1%rowtype;
    v_sql varchar2(100);
  begin
    open c1;
    loop
      fetch c1 into v_row;
      exit when c1%notfound;

      -- ALTER FUNCTION name COMPILE;
      -- ALTER PROCEDURE name COMPILE;
      -- ALTER PACKAGE name COMPILE;
      -- ALTER SYNONYM name COMPILE;
      -- ALTER TRIGGER name COMPILE;
      -- ALTER TYPE name COMPILE;
      v_sql := 'ALTER ' || v_object_type || ' ' || v_row.object_name || ' COMPILE';
      -- dbms_output.put_line(v_sql);
      begin
        dbms_output.put_line('## Compile ' || v_row.object_name);
        execute immediate v_sql;
      exception
        when others then
          dbms_output.put_line('!! Compilation error ' || v_row.object_name);
      end;
    end loop;
    close c1;
  end compile_user_objects_of_type;
begin
  compile_user_objects_of_type('TYPE');
  compile_user_objects_of_type('SYNONYM');
  compile_user_objects_of_type('TRIGGER');
  compile_user_objects_of_type('FUNCTION');
  compile_user_objects_of_type('PROCEDURE');
  compile_user_objects_of_type('PACKAGE');
end;
/

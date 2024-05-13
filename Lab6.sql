CREATE OR REPLACE PROCEDURE Get_Fact(n INTEGER) AS
factorial INTEGER := 1;

BEGIN
    FOR i IN REVERSE 1..n LOOP
        factorial := factorial * i;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(n || '! = ' || factorial);
END;
/

CREATE OR REPLACE PROCEDURE Calculate_Salary (empID employee.employee_id%type) AS

emp employee%rowtype;
newSalary employee.salary%type;
yearsWorked INTEGER;

BEGIN
    SELECT * INTO emp
    FROM employee
    WHERE employee_id = empID;
    
    newSalary := emp.salary;
    yearsWorked := trunc(MONTHS_BETWEEN(SYSDATE, emp.hire_date) / 12); 
    FOR year IN 2..yearsWorked LOOP
        newSalary := newSalary * 1.05;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('First Name: ' || emp.first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name: ' || emp.last_name);
    DBMS_OUTPUT.PUT_LINE('Annual Salary: ' || TO_CHAR(newSalary, '$99,999'));
    
    EXCEPTION WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee (ID: ' || empID || ') does not exist.');

END;
/

CREATE OR REPLACE PROCEDURE Find_Prod_Price(
    productId IN products.product_id%TYPE,
    description OUT VARCHAR2,
    note OUT VARCHAR2
) AS
    productPrice products.list_price%TYPE;
BEGIN
    SELECT description, list_price INTO description, productPrice 
    FROM products 
    WHERE product_id = productId;

    IF (productPrice < 200) THEN
        note := 'Cheap';
    ELSIF (productPrice >= 200 AND productPrice < 500) THEN
        note := 'Not Expensive';
    ELSE
        note := 'Expensive';
    END IF;

    DBMS_OUTPUT.PUT_LINE(description || ' is ' || note);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Invalid Product ID: ' || productId);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/


CREATE OR REPLACE PROCEDURE Warehouses_Report AS
BEGIN
    FOR i IN 1..9 LOOP
        DECLARE
            v_warehouse_id warehouses.warehouse_id%TYPE;
            v_warehouse_name warehouses.warehouse_name%TYPE;
            v_city locations.city%TYPE;
            v_state locations.state%TYPE;
        BEGIN
            SELECT w.warehouse_id, w.warehouse_name, l.city, NVL(l.state, 'no state')
            INTO v_warehouse_id, v_warehouse_name, v_city, v_state
            FROM warehouses w
            JOIN locations l ON w.location_id = l.location_id
            WHERE w.warehouse_id = i;


            DBMS_OUTPUT.PUT_LINE('Warehouse ID: ' || v_warehouse_id);
            DBMS_OUTPUT.PUT_LINE('Warehouse name: ' || v_warehouse_name);
            DBMS_OUTPUT.PUT_LINE('City: ' || v_city);
            DBMS_OUTPUT.PUT_LINE('State: ' || v_state);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        END;
    END LOOP;
END;
/

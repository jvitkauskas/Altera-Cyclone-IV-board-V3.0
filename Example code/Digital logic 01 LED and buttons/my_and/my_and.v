module my_and(s1,s2,led1);
input s1; // Location: PIN_88, I/O Standard: 3.3-V LVTTL, Current Strength: 8mA
input s2; // Location: PIN_89, I/O Standard: 3.3-V LVTTL, Current Strength: 8mA
output led1; // Location: PIN_87, I/O Standard: 3.3-V LVTTL, Current Strength: 8mA
assign led1 = s1 | s2;
endmodule
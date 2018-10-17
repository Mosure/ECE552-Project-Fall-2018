@ECHO OFF

echo Building ALU...
iverilog -o ./bin/alu ./src/shifter.v ./src/alu.v
iverilog -o ./bin/test/alu_tb2 ./src/shifter.v ./src/alu.v ./src/test/alu_tb.v
echo.

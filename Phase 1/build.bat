@ECHO OFF

echo Building shifter...
iverilog -o ./bin/shifter ./src/shifter.v
iverilog -o ./bin/test/shifter_tb ./src/shifter.v ./src/test/shifter_tb.v

echo Building sign extender...
iverilog -o ./bin/sign_ext ./src/shifter.v ./src/sign_ext.v
iverilog -o ./bin/test/sign_ext_tb ./src/shifter.v ./src/sign_ext.v ./src/test/sign_ext_tb.v

echo Done.

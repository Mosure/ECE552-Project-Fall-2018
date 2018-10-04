@ECHO OFF

echo Building shifter...
iverilog -o ./bin/shifter ./src/shifter.v
iverilog -o ./bin/test/shifter_tb ./src/shifter.v ./src/test/shifter_tb.v

echo Done.
@ECHO OFF

echo Building shifter...
iverilog -o ./bin/shifter ./src/shifter.v
iverilog -o ./bin/test/shifter_tb ./src/shifter.v ./src/test/shifter_tb.v

echo Building sign extender...
iverilog -o ./bin/sign_ext ./src/shifter.v ./src/sign_ext.v
iverilog -o ./bin/test/sign_ext_tb ./src/shifter.v ./src/sign_ext.v ./src/test/sign_ext_tb.v

echo Building ALU...
iverilog -o ./bin/alu ./src/shifter.v ./src/alu.v
iverilog -o ./bin/test/alu_tb ./src/shifter.v ./src/alu.v ./src/test/alu_testbench.v

echo Building Register File...
iverilog -o ./bin/register_file ./src/ReadDecoder_4_16.v ./src/WriteDecoder_4_16.v ./src/D-Flip-Flop.v ./src/BitCell.v ./src/Register.v ./src/RegisterFile.v

echo Building Memory...
iverilog -o ./bin/memory ./src/memory.v

echo Building Control...
iverilog -o ./bin/control ./src/Control.v

echo Building PC Control...
iverilog -o ./bin/pc_control ./src/PC_control.v
iverilog -o ./bin/test/pc_control_tb ./src/PC_control.v ./src/test/PC_Control_tb.v

echo Building CPU...
iverilog -o ./bin/cpu ./src/ReadDecoder_4_16.v ./src/WriteDecoder_4_16.v ./src/D-Flip-Flop.v ./src/BitCell.v ./src/Register.v^
            ./src/Control.v ./src/PC_control.v ./src/RegisterFile.v ./src/shifter.v ./src/alu.v ./src/memory.v ./src/cpu.v

echo Done.

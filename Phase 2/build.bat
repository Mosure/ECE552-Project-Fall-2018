@ECHO OFF

echo Building Phase 2 Testbench...
iverilog -o ./project-phase2-testbench/phase2_tb^
            "./src/ALU Components/cla_4bit.v" "./src/ALU Components/cla_16bit.v" "./src/ALU Components/paddsb_4bit.v" "./src/ALU Components/Red_adder.v" "./src/ALU Components/AddSub_16bit.v" "./src/ALU Components/shifter.v"^
            ./src/reg_2bit.v ./src/reg_4bit.v ./src/reg_8bit.v ./src/reg_16bit.v ./src/D_X_register.v ./src/F_D_register.v ./src/Forwarding_Unit.v ./src/Hazard_Detection.v ./src/M_W_register.v ./src/X_M_register.v^
            ./src/ReadDecoder_4_16.v ./src/WriteDecoder_4_16.v ./src/D-Flip-Flop.v ./src/BitCell.v ./src/Register.v ./src/BranchControl.v^
            ./src/Control.v ./src/PC_control.v ./src/RegisterFile.v ./src/PCregister.v ./src/FlagRegisters.v ./src/alu.v ./src/memory.v ./src/cpu.v ./project-phase2-testbench/project-phase2-testbench.v
echo.

echo Done.

@ECHO OFF
for %%f in (./bin/test/*) do (
    echo "Running: %%f"
    vvp ./bin/test/%%f
    echo.
)

echo.
echo Running test1.list...
perl ../WISC-assembler/assembler.pl ./project-phase1-testcases/test1.list > ./project-phase1-testcases/loadfile_all.img
vvp ./project-phase1-testbench/phase1_tb
type "./project-phase1-testbench/verilogsim.trace"
type "./project-phase1-testbench/verilogsim.log"

echo.
echo Running test2.list...
perl ../WISC-assembler/assembler.pl ./project-phase1-testcases/test2.list > ./project-phase1-testcases/loadfile_all.img
vvp ./project-phase1-testbench/phase1_tb
type "./project-phase1-testbench/verilogsim.trace"
type "./project-phase1-testbench/verilogsim.log"

echo.
echo Running test3.list...
perl ../WISC-assembler/assembler.pl ./project-phase1-testcases/test3.list > ./project-phase1-testcases/loadfile_all.img
vvp ./project-phase1-testbench/phase1_tb
type "./project-phase1-testbench/verilogsim.trace"
type "./project-phase1-testbench/verilogsim.log"

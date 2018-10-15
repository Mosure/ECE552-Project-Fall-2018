@ECHO OFF
for %%f in (./bin/test/*) do (
    echo "Running: %%f"
    vvp ./bin/test/%%f
    echo.
)


echo Running test1.list...
perl ../WISC-assembler/assembler.pl ./project-phase1-testcases/test1.list > ./project-phase1-testcases/loadfile_all.img
vvp ./project-phase1-testbench/phase1_tb
type "./verilogsim.trace"
type "./verilogsim.log"

del /f "./verilogsim1.trace"
del /f "./verilogsim1.log"

ren "./verilogsim.trace" "./verilogsim1.trace"
ren "./verilogsim.log" "./verilogsim1.log"

cd "./project-phase1-testcases"

del /f "./loadfile_all1.img"
ren "./loadfile_all.img" "./loadfile_all1.img"

cd "../"
echo.

echo Running test2.list...
perl ../WISC-assembler/assembler.pl ./project-phase1-testcases/test2.list > ./project-phase1-testcases/loadfile_all.img
vvp ./project-phase1-testbench/phase1_tb
type "./verilogsim.trace"
type "./verilogsim.log"

del /f "./verilogsim2.trace"
del /f "./verilogsim2.log"

ren "./verilogsim.trace" "./verilogsim2.trace"
ren "./verilogsim.log" "./verilogsim2.log"

cd "./project-phase1-testcases"

del /f "./loadfile_all2.img"
ren "./loadfile_all.img" "./loadfile_all2.img"

cd "../"

echo.

echo Running test3.list...
perl ../WISC-assembler/assembler.pl ./project-phase1-testcases/test3.list > ./project-phase1-testcases/loadfile_all.img
vvp ./project-phase1-testbench/phase1_tb
type "./verilogsim.trace"
type "./verilogsim.log"

del /f "./verilogsim3.trace"
del /f "./verilogsim3.log"

ren "./verilogsim.trace" "./verilogsim3.trace"
ren "./verilogsim.log" "./verilogsim3.log"

cd "./project-phase1-testcases"

del /f "./loadfile_all3.img"
ren "./loadfile_all.img" "./loadfile_all3.img"

cd "../"

echo.

echo Done.
@ECHO OFF

echo Running test1.list...
perl ../WISC-assembler/assembler.pl ./project-phase2-testcases/test1.list > ./project-phase2-testcases/loadfile_all.img
vvp ./project-phase2-testbench/phase2_tb
type "./verilogsim.ptrace"
type "./verilogsim.plog"

del /f "./verilogsim1.ptrace"
del /f "./verilogsim1.plog"

ren "./verilogsim.ptrace" "./verilogsim1.ptrace"
ren "./verilogsim.plog" "./verilogsim1.plog"

cd "./project-phase2-testcases"

del /f "./loadfile_all1.img"
ren "./loadfile_all.img" "./loadfile_all1.img"

cd "../"
echo.

echo Running test2.list...
perl ../WISC-assembler/assembler.pl ./project-phase2-testcases/test2.list > ./project-phase2-testcases/loadfile_all.img
vvp ./project-phase2-testbench/phase2_tb
type "./verilogsim.ptrace"
type "./verilogsim.plog"

del /f "./verilogsim2.ptrace"
del /f "./verilogsim2.plog"

ren "./verilogsim.ptrace" "./verilogsim2.ptrace"
ren "./verilogsim.plog" "./verilogsim2.plog"

cd "./project-phase2-testcases"

del /f "./loadfile_all2.img"
ren "./loadfile_all.img" "./loadfile_all2.img"

cd "../"

echo.

echo Running test3.list...
perl ../WISC-assembler/assembler.pl ./project-phase2-testcases/test3.list > ./project-phase2-testcases/loadfile_all.img
vvp ./project-phase2-testbench/phase2_tb
type "./verilogsim.ptrace"
type "./verilogsim.plog"

del /f "./verilogsim3.ptrace"
del /f "./verilogsim3.plog"

ren "./verilogsim.ptrace" "./verilogsim3.ptrace"
ren "./verilogsim.plog" "./verilogsim3.plog"

cd "./project-phase2-testcases"

del /f "./loadfile_all3.img"
ren "./loadfile_all.img" "./loadfile_all3.img"

cd "../"

echo.

echo Done.
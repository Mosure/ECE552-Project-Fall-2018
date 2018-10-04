@ECHO OFF
for %%f in (./bin/test/*) do (
    echo "Running: %%f"
    vvp ./bin/test/%%f
)

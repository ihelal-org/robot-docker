# Load env config
set dotenv-load

robot-setup:
    bash scripts/setup.sh

robot-build:
    bash scripts/build.sh

robot-start:
    bash scripts/start.sh

robot-shell:
    bash scripts/shell.sh

robot-stop:
    bash scripts/stop.sh

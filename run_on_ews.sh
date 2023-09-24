#!/bin/bash

#------------------------------------------------------------------------
# run_on_ews.sh: rsync's the current directory with a server that has
#                the Synopsys toolchain installed, runs code there, then
#                copies back the artifacts.
#                I find this slightly easier than using Emacs TRAMP,
#                especially for viewing waves (X forwarding/VNC is slow).
#------------------------------------------------------------------------

remote_server="netid@linux.ews.illinois.edu"
remote_directory="~/sigarch"
current_project="hello-world"
output_directory="./ews_run_artifacts"

mkdir -p $output_directory

rsync -avz "./$current_project" "$remote_server:$remote_directory" --exclude doc --exclude ews_run_artifacts --exclude .git
ssh "$remote_server" ". /etc/profile && source ~/setup_synopsys_toolchain.sh && cd $remote_directory/$current_project && make run"
rsync -avz "$remote_server:$remote_directory/$current_project/sim/dump.vcd" "$output_directory"
rsync -avz "$remote_server:$remote_directory/$current_project/sim/compile.log" "$output_directory"
rsync -avz "$remote_server:$remote_directory/$current_project/sim/simulation.log" "$output_directory"

echo "run_on_ews.sh: exiting"

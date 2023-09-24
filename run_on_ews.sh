#!/bin/bash

#------------------------------------------------------------------------
# run_on_ews.sh: rsync's the current directory with a server that has
#                the Synopsys toolchain installed, runs code there, then
#                copies back the artifacts.
#                I find this slightly easier than using Emacs TRAMP,
#                especially for viewing waves (X forwarding/VNC is slow).
#------------------------------------------------------------------------

remote_server="netid@linux.ews.illinois.edu"
remote_directory="~/sigarch_blank_rtl_project/hello-world"
output_directory="./ews_run_artifacts"

mkdir -p $output_directory

rsync -avz . "$remote_server:$remote_directory" --exclude doc --exclude ews_run_artifacts --exclude .git
ssh "$remote_server" "source ~/setup_synopsys_toolchain.sh && cd $remote_directory && make run"
rsync -avz "$remote_server:$remote_directory/sim/dump.vcd" "$output_directory"
rsync -avz "$remote_server:$remote_directory/sim/compile.log" "$output_directory"
rsync -avz "$remote_server:$remote_directory/sim/simulation.log" "$output_directory"

echo "run_on_ews.sh: exiting"

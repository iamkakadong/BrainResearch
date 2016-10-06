##------------------------------------------ Start of Example #1 --------------------------------------------------
 
## Specify the shell for PBS ? required.
## Notice the double # for comments.
## You can also use /bin/csh.
 # /usr/math/bin/uinit
 
 #PBS -S /bin/sh
 
 ## Merge stderr to stdout (optional, otherwise they're in separate files)
 ##PBS -j oe
 
 ##Specify the output filename explicitly (optional; the default is named
 ## from the job ID, in the directory where qsub was run.)
 ##PBS -o /path/to/output/directory/testjob.out
 
 ##Requests 1 node to run 1 process in the queue.
 #PBS -l nodes=4:ppn=7,pmem=48000mb,walltime=8:00:00
 
 
 ## Request mail when job ends, or is aborted (optional, default is "a" only)
 #PBS -m a

 #PBS -M tren@andrew.cmu.edu

 # To start in a certain directory; you probably need to change.

 cd /home/tren/BrainResearch/Scripts
 

 ## Below are the actual commands to be executed (i.e. to do the work).
 echo "Test job starting at `date`"
 matlab /r "subset=[1,4];elas_net_main"
 matlab /r "subset=[5,8];elas_net_main"
 matlab /r "subset=[9,12];elas_net_main"
 matlab /r "subset=[13,16];elas_net_main"
 matlab /r "subset=[17,20];elas_net_main"
 matlab /r "subset=[21,24];elas_net_main"
 matlab /r "subset=[25,28];elas_net_main"
 echo "Test job finished at `date`"
 #PBS -N elastic_net_cv

##------------------------------------------ End of Example #1--------------------------------------------------

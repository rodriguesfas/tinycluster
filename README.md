# Vagrant Cluster HPC

This is a Vagrantfile (to be used with HashiCorp's [Vagrant](https://app.vagrantup.com/boxes/search) tool) for automatically bringing up a cluster suitable for testing MPI loads.

Practically, all this involves is bringing up several VMs on a private network, setting up SSH key-based authentication between them, and installing OpenMPI.

Currently only works with the VirtualBox provider.

## Requeriment System
- [Ubuntu](https://ubuntu.com/) 19.04
- [VirtualBox](https://www.virtualbox.org/) 6.0
- [Vagrant](https://app.vagrantup.com/boxes/search) 2.2.3

## Config Virtual Machine
By default, the cluster will be made of 3 VMs. 
If you want more, change ```N_VMS``` in the ```Vagrantfile```.

- Choose how many machines the cluster will contain.
    ```N_VMS = 3```

- Give network id to each node.
    ```NETWORK_ID = "192.168.55"```

- Choose disksize.
    ```config.disksize.size = '500GB'```

- Use a minimal amount of RAM for each ```node``` to avoid overwhelming the host.
    
    ```v.memory = 512```

	```v.cpus = 1```


## Create Cluster

    $ vagrant up

##  Check Status Machine Vagrant

    $ vagrant global-status
    $ vagrant global-status --prune


## Used Cluster

The VMs will be named ```node1``` through ```node<n>```. To SSH to, say, ```node1```:

    $ vagrant ssh node1
    $ vagrant ssh node2
    $ vagrant ssh node3

#### Check networks nodes.

    $ cat /etc/hosts
    
    192.168.55.101 node1
    192.168.55.102 node2
    192.168.55.103 node3


#### Create program test.

    vagrant@node1:~$ touch mpi_hello_world.py
    vagrant@node1:~$ nano mpi_hello_world.py

Add block code and save file.

    #!/usr/bin/env python
    print "Hello!"

#### Share the program to the other nodes.

    vagrant@node1:~$ scp ~/mpi_hello_world.py node2:~
    vagrant@node1:~$ scp ~/mpi_hello_world.py node3:~

#### Run
As a simple sanity check, try running hostname on each machine in the cluster:

    vagrant@node1:~$ mpirun -np 3 --host node1,node2,node3 python mpi_hello_world.py

    Hello!
    Hello!
    Hello!

#### Clean-up
Execute the following command to remove the virtual machines created for the cluster.

    $ vagrant destroy -f
    $ vagrant destroy [id]

# Credits

[William Domingues](#)

[MPI Cluster Vagrantfile](https://github.com/mrahtz/mpi-vagrant)




# Liberando portas no firewall iptables do Ubuntu

    $ sudo iptables -A INPUT -p tcp --dport 60000 -j ACCEPT

    $ telnet localhost 60000

# 

    $ wget https://www.parallelpython.com/downloads/pp/pp-1.6.6.tar.gz
    
    $ tar -vzxf pp-1.6.6.tar.gz


    $ sudo iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 60000 -j ACCEPT
# DeepNLPF Cluster Local

# Prepared
Config file Vagrant: ```ip_host```, ```ip_rede```, ```cpu```, ```memory```, others paramets.

# Create the Cluster
    vagrant up

# Access nodes
    user@computer:~/tinycluster$ vagrant ssh manager
    user@computer:~/tinycluster$ vagrant ssh worker01
    user@computer:~/tinycluster$ vagrant ssh worker02

# Join nodes
    vagrant@manager:~$ sudo docker service create --name my_web --replicas 7 --publish published=9090,target=90 nginx
    
    vbeifwzw8hwkkql9qr5eua1xa
    overall progress: 7 out of 7 tasks 
    1/7: running   [==================================================>] 
    2/7: running   [==================================================>] 
    3/7: running   [==================================================>] 
    4/7: running   [==================================================>] 
    5/7: running   [==================================================>] 
    6/7: running   [==================================================>] 
    7/7: running   [==================================================>] 
    verify: Service converged

# Check join in all nodes
    vagrant@manager:~$  sudo docker container ls
    vagrant@worker01:~$ sudo docker container ls
    vagrant@worker02:~$ sudo docker container ls

# Add nodes in manager
    vagrant@manager:~$ echo "10.100.199.201 worker01 worker01" >> /etc/hosts
    vagrant@manager:~$ echo "10.100.199.202 worker02 worker02" >> /etc/hosts

# Generated keys
    vagrant@manager:~$ ssh-keygen -b 2048

    SHA256:OfYbAEqudE0naga1rzQ1GzGVvdDEVM8JelxxSNckhhE vagrant@k8s-head
    
# Shared keys with workers
    vagrant@manager:~$ cp .ssh/id_rsa.pub .ssh/authorized_keys
    vagrant@manager:~$ sudo scp .ssh/id_rsa .ssh/id_rsa.pub .ssh/authorized_keys vagrant@worker01:~/.ssh/
    vagrant@manager:~$ sudo scp .ssh/id_rsa .ssh/id_rsa.pub .ssh/authorized_keys vagrant@worker01:~/.ssh/

# Install Ray all nodes

    pip3 install -U ray

# Start Ray Hader

    vagrant@manager:~$ ray start --head --redis-port=6379

    2020-05-28 20:04:43,049	INFO scripts.py:357 -- Using IP address 10.0.2.15 for this node.
    2020-05-28 20:04:43,052	INFO resource_spec.py:212 -- Starting Ray with 1.03 GiB memory available for workers and up to 0.52 GiB for objects. You can adjust these settings with ray.init(memory=<bytes>, object_store_memory=<bytes>).
    2020-05-28 20:04:43,504	INFO services.py:1170 -- View the Ray dashboard at localhost:8265
    2020-05-28 20:04:43,579	INFO scripts.py:387 -- 
    Started Ray on this node. You can add additional nodes to the cluster by calling

        ray start --address='10.0.2.15:6379' --redis-password='5241590000000000'

    from the node you wish to add. You can connect a driver to the cluster from Python by running

        import ray
        ray.init(address='auto', redis_password='5241590000000000')

    If you have trouble connecting from a different machine, check that your firewall is configured properly. If you wish to terminate the processes that have been started, run

        ray stop

# Run Ray all worker

    vagrant@worker01:~$ ray start --address=10.100.199.200:6379

    2020-05-28 20:09:45,232	INFO scripts.py:429 -- Using IP address 10.100.199.201 for this node.
    2020-05-28 20:09:45,244	INFO resource_spec.py:212 -- Starting Ray with 1.22 GiB memory available for workers and up to 0.53 GiB for objects. You can adjust these settings with ray.init(memory=<bytes>, object_store_memory=<bytes>).
    2020-05-28 20:09:45,285	INFO scripts.py:438 -- 
    Started Ray on this node. If you wish to terminate the processes that have been started, run

        ray stop

    vagrant@worker02:~$ ray start --address=10.100.199.200:6379
    ...

# Start Ray auto

    vagrant@manager:~$ sudo apt install pssh

    vagrant@manager:~$ nano cluster.yaml

```yaml
---
cluster_name: ClusterDeepNLPF
min_workers: 3
initial_workers: 3
max_workers: 3
autoscaling_mode: default
target_utilization_fraction: 0.8
idle_timeout_minutes: 5
docker:
image: ""
container_name: ""
pull_before_run: True
run_options: []
provider:
type: local
head_ip: 10.100.199.200
worker_ips: [10.100.199.201, 10.100.199.202]
auth:
ssh_user: vagrant
ssh_private_key: ~/.ssh/id_rsa
head_node: {}
worker_nodes: {}
file_mounts: {
# "/path1/on/remote/machine": "/path1/on/local/machine",
# "/path2/on/remote/machine": "/path2/on/local/machine",
}
initialization_commands: []
setup_commands:
- pip3 install -U ray
head_setup_commands: []
worker_setup_commands: []
head_start_ray_commands:
- ray stop
- ray start –head –redis-port=6379 --autoscaling-config=/home/vagrant/cluster.yaml --webui-host 0.0.0.0
worker_start_ray_commands:
- ray stop
- ray start --address=10.100.199.200:6379
```

    vagrant@manager:~$ ray up ./cluster.yaml -y

    vagrant@manager:~$ 

# Credits

- [Docker Swarm Cluster Setup With Vagrant](https://medium.com/@gauravtalele/docker-swarm-cluster-setup-with-vagrant-bca5ddb7a672)

- [Willian](#)




10.0.2.15:50356
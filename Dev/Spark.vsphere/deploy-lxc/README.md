# Ansible Roles for Hadoop and HBase

## Features

- Can install HDFS, YARN, MapReduce, HBase and Phoenix services.
- Multiple clusters can be managed from the same Ansible inventory.
- All services are running under systemd and logging through journald.
- Tested on Ubuntu 15.04. (Might work on Debian Jessie, but that doesn't run properly in containers.)

## All-in-one HBase machine using Vagrant

```sh
vagrant up
vagrant ssh
sudo -i -u hadoop
hbase shell
```

## Complete Hadoop cluster using LXC containers

For this example, you will need a working LXC host machine. We will create a number of containers:

- `hdfs-name` - HDFS NameNode and Secondary NameNode
- `hdfs-data{1,2}` - HDFS DataNode, YARN NodeManager and HBase RegionServer
- `mr` - YARN ResourceManager and MapReduce JobHistory Server
- `hbase` - HBase Master, HBase Thrift/REST Gateways, Phoenix QueryServer and ZooKeeper

Setting up:

```sh
./create-instances.sh hdfs-name hdfs-data{1,2} mr hbase
ansible-playbook -i hosts -u root -l cluster1 hadoop.yml
```

Testing MapReduce on YARN:

```sh
ssh root@mr.lxc
sudo -i -u hadoop
echo 'this is a test' >test.txt
hdfs dfs -mkdir -p /user/hadoop/test1/in
hdfs dfs -moveFromLocal test.txt /user/hadoop/test1/in
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-2.7.0.jar -input test1/in -output test1/out -mapper /bin/cat -reducer /usr/bin/wc
hdfs dfs -ls /user/hadoop/test1/out
hdfs dfs -cat /user/hadoop/test1/out/part-00000
```

You can see the job on the MR JobHistory server at http://mr.lxc:19888/ and
the YARN ResourceManager server at http://mr.lxc:8088/. Additionally, you can
browse the results on the HDFS NameNode web server
at http://hdfs-name.lxc:50070/explorer.html#/user/hadoop/test1.

Testing HBase shell:

```sh
ssh root@hbase.lxc
sudo -i -u hadoop
hbase shell
create 't1', 'f1'
put 't1', 'id1', 'f1:c1', 'value1'
scan 't1'
```

Testing HBase Thrift interface using Python:

```sh
virtualenv e
. e/bin/activate
pip install happybase
python -c 'import happybase; c = happybase.Connection("hbase.lxc"); t = c.table("t1"); print t.row("id1")'
```

Testing Phoenix command-line client:

```sh
ssh root@hbase.lxc
sudo -i -u hadoop
cd phoenix-*-bin
./bin/sqlline.py hbase.lxc
create table t2 (a integer primary key, b varchar);
upsert into t2 values (1, 'a');
select * from t2;
```

## Configuration

- `jave_package` - which Java package to install (required)
- `jave_home` - path to the Java package's home directory (required)
- `hadoop_cluster` - Ansible group which contains all hosts in this cluster (required)
- `hadoop_version`, `hbase_version`, `phoenix_version` - which versions to install
- `hadoop_keep_etc_hosts` - the hadoop role will remove 127.0.1.1 entry from /etc/hosts by default, this tells it to not do that
- `hadoop_hostname` - per-host variable to use in configuration files to refer to a host
- `hdfs_replication` - how many node should one data block be replicated to
- `hdfs_namenode_name_dir` - where to keep HDFS NameNode data
- `hdfs_namenode_checkpoint_dir` - where to keep HDFS Secondary NameNode data
- `hdfs_datanode_data_dir` - where to keep HDFS DataNode data
- `hbase_zookeeper_data_dir` - where to keep ZooKeeper data
- `hbase_data_dir` - where to keep HBase data (on HDFS, not local disk)

## Known problems

 - Only using the ZooKeeper that is embedded into HBase, we will need to
   install a separate instance of other services need it as well.
 - No support for HA HDFS NameNodes.

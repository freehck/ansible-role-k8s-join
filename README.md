freehck.k8s_join
=========

Join nodes to Kubernetes cluster

Description
-----------

This role is applied to all the nodes and to Kubernetes master. Master host must have `k8s_join_is_master` set to `true`.

Role Variables
--------------

`k8s_join_command_filename`: The filename to store auth token/command, default is `k8s-join-command`

`k8s_join_is_master`: this boolean flag must be only set to `true` for one specific host in Kubernetes cluster, that is a master one; default is `false`

Example
-------

## group_vars/inventory

    k8s-node-0 ansible_host=10.118.19.10 k8s_is_master=true
    k8s-node-1 ansible_host=10.118.19.11
    k8s-node-2 ansible_host=10.118.19.12
    
    [k8s_cluster]
    k8s-node-0
    k8s-node-1
    k8s-node-2

## playbook.yml

    - hosts: k8s_cluster
      become: true
      vars:
        # common params
        k8s_ver: "1.16.2-00"
        k8s_node_ip: "{{ ansible_host }}"
        # k8s_base is an implicit dependency
        k8s_base_node_ip: "{{ k8s_node_ip }}"
        k8s_base_ver: "{{ k8s_ver }}"
        # k8s_init is an implicit dependency
        k8s_init_cidr: "192.168.0.0/16"
        k8s_init_node_ip: "{{ ansible_host }}"
        k8s_init_node_name: "{{ inventory_hostname }}"
        # this role configuration
        k8s_join_is_master: "{{ k8s_is_master | default('false') }}"
      roles:
        - role: freehck.k8s_base
        - role: freehck.k8s_init
          when: k8s_join_is_master
        - role: freehck.k8s_join



Notes
-----

As you can see in the example, this role is designed to be applied to both Kubernetes master and nodes. On master this role generates auth token and save it into the file on ansible controler. Do not commit this file, it will expire in a while! Then on nodes it uses this token for them to join cluster.

Install
-------

This role can be installed from [Ansible Galaxy](https://galaxy.ansible.com/):

`ansible-galaxy install freehck.k8s_join`

License
-------

MIT

Author Information
------------------

Dmitrii Kashin, <freehck@freehck.ru>

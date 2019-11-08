.DEFAULT: test
.PHONY: up down test clean

export ANSIBLE_HOST_KEY_CHECKING=false
export ANSIBLE_SSH_ARGS='-o UserKnownHostsFile=/dev/null -o ControlMaster=auto -o ControlPersist=60s'

ANSIBLE_OPTS:=
ANSIBLE_OPTS+= --private-key=~.vagrant.d/insecure_private_key
ANSIBLE_OPTS+= --user=vagrant



up:
	vagrant up

test: up
	cd provision && ansible-playbook $(ANSIBLE_OPTS) playbook.yml

down:
	vagrant destroy -f

clean: 
	find --maxdepth 1 -type d

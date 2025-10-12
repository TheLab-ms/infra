.PHONY: ansible foobar labpi

ansible: foobar labpi

foobar:
	ansible-playbook -i ansible-inventory -l foobar.thelab.ms playbooks/foobar.yaml

labpi:
	ansible-playbook -i ansible-inventory -l labpi.thelab.ms playbooks/labpi.yaml


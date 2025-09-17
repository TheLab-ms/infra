.PHONY: ansible foobar baz

ansible: foobar baz

foobar:
	ansible-playbook -i ansible-inventory -l foobar.thelab.ms playbooks/foobar.yaml

baz:
	ansible-playbook -i ansible-inventory -l baz.thelab.ms playbooks/baz.yaml

labpi:
	ansible-playbook -i ansible-inventory -l labpi.thelab.ms playbooks/labpi.yaml


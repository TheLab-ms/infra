.PHONY: ansible foobar baz apply

ansible:
	ansible-playbook -i ansible-inventory playbooks/*.yaml

foobar:
	ansible-playbook -i ansible-inventory -l foobar.thelab.ms playbooks/*.yaml

baz:
	ansible-playbook -i ansible-inventory -l baz.thelab.ms playbooks/*.yaml

apply:
	kubectl apply --prune --all --validate=false --kustomize .


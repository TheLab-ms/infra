.PHONY: apply
apply:
	kubectl apply --prune --all -f manifests


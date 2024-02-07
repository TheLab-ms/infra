.PHONY: apply
apply:
	kubectl apply --prune --all --kustomize .


.PHONY: apply prom

apply:
	kubectl apply --prune --all --kustomize .

prom:
	kubectl port-forward svc/prom 8080:80

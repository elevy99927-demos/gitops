# gitops
## This is a Demo repository for ARGOCD tutorial.
## for the full content of this project, please refer to:
## [https://github.com/elevy99927/Jenkins-k8s/tree/main/Part4-CICD/04-ArgoCD](https://github.com/elevy99927/Jenkins-k8s/tree/main/Part4-CICD/04-ArgoCD)

---
## Class GitOps Structure (Jenkins `helm template` + Argo CD ApplicationSet)

Branch: `main`

Everything Argo CD deploys lives under `systems/`. The class is split into 4 departments;
each department has 3 environments, and each student owns one file (one application) per environment.

```
systems/<department>/<environment>/<user>.yaml

└── systems
    ├── hr
    │   └── dev | qa | prd
    ├── finance
    │   └── dev | qa | prd
    ├── legal
    │   └── dev | qa | prd
    ├── digital
    │   └── dev | qa | prd
    └── devops                  # instructor
        └── dev
            └── elevy99927.yaml
```

| Level | Meaning | Example |
|-------|---------|---------|
| `<department>` | team, also the Kubernetes namespace | `hr` |
| `<environment>` | `dev`, `qa` or `prd` | `dev` |
| `<user>.yaml` | your application: plain Kubernetes manifests (`helm template` output). `<user>` = your Docker Hub user | `elevy99927.yaml` |

### Flow

```
app repo push ─► Jenkins ─► build image  docker.io/<user>/helloworld:<build>
                        └─► helm template <user> ./chart --set image.tag=<build>
                            ─► commit to systems/<DEPARTMENT>/<ENV>/<user>.yaml
                               ─► Argo CD (systems-manifests) syncs it to the cluster
```

The Jenkinsfile has parameters `ENV` (dev/qa/prd), `DEPARTMENT` and `SERVICE_MONITOR`.
Example: [hello-newapp/Jenkinsfile](https://github.com/elevy99927-demos/hello-newapp/blob/main/Jenkinsfile).

### ApplicationSet

[ApplicationSet/systems-manifests.yaml](ApplicationSet/systems-manifests.yaml) turns every
`systems/*/dev/*.yaml` file into one Application named `<department>-<env>-<user>`
(for example `devops-dev-elevy99927`) that applies the manifests in that file
into the department's namespace. Deleting the file removes the Application and its resources.

The lab runs on one kind cluster, so only `dev` is deployed. For all environments, change the path
to `systems/*/*/*.yaml`.

### Onboarding (students)

1. Fork the app repo and set `def user = "<your-docker-hub-user>"` in the Jenkinsfile.
2. Run the Jenkins job with your `DEPARTMENT` and `ENV`.
3. Jenkins commits `systems/<department>/<env>/<user>.yaml`, and Argo CD deploys it.

See your app:

```bash
kubectl -n <department> port-forward svc/<user> 8081:80
# open http://localhost:8081
```

### Monitoring (Helm charts)

```
monitoring/<env>/<app>.yaml        # Helm values, one file per chart

└── monitoring
    └── dev
        ├── prometheus.yaml        # kube-prometheus-stack 84.3.0 (Prometheus, Alertmanager, Grafana)
        ├── loki.yaml              # loki 7.0.0 (single binary)
        └── promtail.yaml          # promtail 6.17.1 (pod logs -> Loki)
```

[ApplicationSet/systems-helm.yaml](ApplicationSet/systems-helm.yaml) lists the three charts and creates
`monitoring-dev-prometheus`, `monitoring-dev-loki` and `monitoring-dev-promtail` in the `monitoring` namespace.
To add a chart: add its values file and one element (app, repoURL, chart, version) to the list.

```bash
kubectl apply -f ApplicationSet/systems-helm.yaml
kubectl -n monitoring port-forward svc/prometheus-grafana 3000:80    # Grafana: http://localhost:3000
```

---
## Contact

For questions or feedback, feel free to reach out:

- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

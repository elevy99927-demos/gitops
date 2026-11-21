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
Example: [hellow-newapp/Jenkinsfile](https://github.com/elevy99927-demos/hellow-newapp/blob/main/Jenkinsfile).

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

---
## Contact

For questions or feedback, feel free to reach out:

- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

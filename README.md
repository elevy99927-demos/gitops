# gitops
## This is a Demo repository for ARGOCD tutorial.
## for the full content of this project, please refer to:
## [https://github.com/elevy99927/Jenkins-k8s/tree/main/Part4-CICD/04-ArgoCD](https://github.com/elevy99927/Jenkins-k8s/tree/main/Part4-CICD/04-ArgoCD)

---
## Class GitOps Structure (Git Files Generator + Helm Multi-Source)

Branch: `main`

Everything Argo CD deploys lives under `systems/`. The class is split into 4 departments;
each department has 3 environments, and each student owns one file (one application) per environment.

```
systems/<department>/<environment>/<student>.yaml

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
| `<student>.yaml` | your application: Helm values for the podinfo chart | `student07.yaml` |

### ApplicationSet

[ApplicationSet/systems-helm.yaml](ApplicationSet/systems-helm.yaml) turns every
`systems/*/dev/*.yaml` file into one Application named `<department>-<env>-<student>`
(for example `hr-dev-student07`), deployed with the podinfo chart into the department's namespace.

The lab runs on one kind cluster, so only `dev` is deployed. For all environments, change the path
to `systems/*/*/*.yaml`.

### Onboarding (students)

Add one file, push, and Argo CD creates your Application. Deleting the file removes it.

```bash
# replace <department> and <your-name>
touch systems/<department>/dev/<your-name>.yaml
git add . && git commit -m "add <your-name>" && git push
```

The file may be empty (chart defaults) or set podinfo values, for example:

```yaml
replicaCount: 1
ui:
  color: "#2e7d32"
  message: "<your-name> | <department> | dev"
```

---
## Contact

For questions or feedback, feel free to reach out:

- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

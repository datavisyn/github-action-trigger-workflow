# Trigger Workflow and Wait

Github Action for trigger a workflow from another workflow. The action then waits for a response.
see: <https://github.com/datavisyn/github-action-trigger-workflow/blob/main/README.md>

see also <https://github.com/convictional/github-action-trigger-workflow>

**When would you use it?**

When deploying an app you may need to deploy additional services, this Github Action helps with that.

## Arguments

| Argument Name            | Required   | Default     | Description           |
| ---------------------    | ---------- | ----------- | --------------------- |
| `owner`                  | True       | N/A         | The owner of the repository where the workflow is contained. |
| `repo`                   | True       | N/A         | The repository where the workflow is contained. |
| `github_token`           | True       | N/A         | The Github access token with access to the repository. Its recommended you put it under secrets. |
| `workflow_file_name`     | True       | N/A         | The reference point. For example, you could use main.yml. |
| `github_user`            | False      | N/A         | The name of the github user whose access token is being used to trigger the workflow. |
| `ref`                    | False      | main        | The reference of the workflow run. The reference can be a branch, tag, or a commit SHA. |
| `wait_interval`          | False      | 10          | The number of seconds delay between checking for result of run. |
| `client_payload`         | False      | `{}`        | Payload to pass to the workflow, must be a JSON string |
| `propagate_failure`      | False      | `true`      | Fail current job if downstream job fails. |
| `trigger_workflow`       | False      | `true`      | Trigger the specified workflow. |
| `wait_workflow`          | False      | `true`      | Wait for workflow to finish. |

## Example

### Simple

```yaml
- uses: ./.github/actions/github-action-trigger-workflow
  with:
    owner: datavisyn
    repo: myrepo
    github_token: ${{ secrets.GITHUB_PERSONAL_ACCESS_TOKEN }}
```

### All Options

```yaml
- uses: ./.github/actions/github-action-trigger-workflow
  with:
    owner: datavisyn
    repo: myrepo
    github_token: ${{ secrets.GITHUB_PERSONAL_ACCESS_TOKEN }}
    github_user: github-user
    workflow_file_name: main.yml
    ref: release-branch
    wait_interval: 10
    client_payload: '{}'
    propagate_failure: false
    trigger_workflow: true
    wait_workflow: true
```

## Testing

You can test out the action locally by cloning the repository to your computer. You can run:

```shell
INPUT_OWNER="datavisyn" \
INPUT_REPO="myrepo" \
INPUT_GITHUB_TOKEN="<REDACTED>" \
INPUT_GITHUB_USER="github-user" \
INPUT_WORKFLOW_FILE_NAME="main.yml" \
INPUT_REF="release-branch" \
INPUT_WAIT_INTERVAL=10 \
INPUT_CLIENT_PAYLOAD='{}' \
INPUT_PROPAGATE_FAILURE=false \
INPUT_TRIGGER_WORKFLOW=true \
INPUT_WAIT_WORKFLOW=true \
busybox sh entrypoint.sh
```

You will have to create a Github Personal access token. You can create a test workflow to be executed. In a repository, add a new `main.yml` to `.github/workflows/`. The workflow will be:

```shell
name: Main
on:
  workflow_dispatch
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@main
      - name: Pause for 25 seconds
        run: |
          sleep 25
```

For testing a failure case, just add this line after the sleep:

```yaml
...
- name: Pause for 25 seconds
  run: |
    sleep 25
    echo "For testing failure"
    exit 1
```

## Potential Issues

### Changes

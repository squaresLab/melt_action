# MELT GitHub Action

MELT is a GitHub action that generates comby rules for clients of a library when a pull request contains deprecations. Clients can use these comby rules to adapt to the changes in the library.

*This is a work in progress. The current docker image does not contain the latest version of MELT.*

## Features

- Automatically generates comby rules from a pull request containing deprecations
- Easy integration with your GitHub workflow

## Usage

To use Fix It in your GitHub workflow, add the following snippet to your `.github/workflows/main.yml` file:

```yaml
on:
  pull_request:
    types: [opened, reopened]

jobs:
  gen_rules:
    runs-on: ubuntu-latest
    name: Automatically generate comby rules from the request
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        with:
          fetch-depth: 2
          ref: ${{ github.event.pull_request.head.sha }}

      - name: Generate comby rules
        uses: squaresLab/melt_action@v3
        with:
          mountpoint: /github/workspace
          basesha: ${{ github.event.pull_request.base.sha }}

      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          path: ${{ github.workspace }}/generated_file.txt
```

## Inputs

| Input       | Description                         | Required |
|-------------|-------------------------------------|----------|
| mountpoint  | Mount point for your repo           | Yes      |
| basesha     | Sha of the base of the merge        | Yes      |

## Outputs

| Output | Description                |
|--------|----------------------------|
| rules  | Rules MELT generated     |


## License

[MIT](LICENSE)

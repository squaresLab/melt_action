# MELT GitHub Action

MELT is a GitHub action that generates comby rules for clients of a library when a pull request contains deprecations. Clients can use these comby rules to adapt to the changes in the library.

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
        uses: danieltrt/fixit@v3
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

## Example

In this example, Fix It generates comby rules for a pull request containing deprecations and uploads the generated rules as an artifact.

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
        uses: danieltrt/fixit@v3
        with:
          mountpoint: /github/workspace
          basesha: ${{ github.event.pull_request.base.sha }}

      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          path: ${{ github.workspace }}/generated_file.txt
```

## License

[MIT](LICENSE) © [danieltrt](https://github.com/danieltrt)

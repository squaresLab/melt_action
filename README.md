# MELT GitHub Action

## What is MELT?

**MELT** is a tool that automatically generates upgrade rules when your library undergoes API-breaking changes. 
It integrates into your workflow, making it easier for your clients to transition between different versions of your library.
The upgrade rules are expressed in Comby, and thus easily interpratable, adaptable, and verifiable.

### Example Use Case

Suppose you have an API where a function previously took an optional keyword argument to determine whether to return a JSON response. 
You've now refactored the API to split this functionality into two separate methods, allowing the JSON conversion to be chained.

Imagine you submit the following breaking change to your library:

```diff
--- a/DataService.py
+++ b/DataService.py
@@ -1,6 +1,9 @@
 class DataService:
 ...
-    def fetch_data(self, endpoint: str, as_json: bool = False) -> dict[str, object] | DataService:
-        response = self._get_data(endpoint)
-        if as_json:
-            return response.json()
-        return self
+    def fetch_data(self, endpoint: str) -> 'DataService':
+        self.data = self._get_data(endpoint)
+        return self
+
+    def to_json(self) -> dict[str, object]:
+        return self.data.json()
 ...

```

This API change will break any client code that relies on the `as_json` argument. 
Fortunately, MELT's GitHub Action can automatically generate the necessary transformation rules to help your clients update their codebase automatically. 
For this particular change you've made, MELT would generate a transformation rule:

```python
:[x].fetch_data(:[endpoint], as_json=True) -> :[x].fetch_data(:[endpoint]).to_json()
```

Your library clients can easily apply this transformation rule to upgrade between versions. 
The only requirement is that they have (Comby)[comby.dev] installed — a lightweight code transformation tool similar to sed.

### How Does It Work?

MELT learns how to update your API by analyzing how you've updated your internal usages in your unit or integration tests. If you're interested in learning more, check out the [technical paper](https://arxiv.org/abs/2308.14687v2). The source code for MELT is also available on [GitHub](https://github.com/squaresLab/melt).


Please note that MELT is a prototype. Unfortunately, I don't have the bandwidth to maintain this tooling, but if you're interested in using it or developing something better, feel free to open an issue or email me (see the paper for contact details).

*This is a work in progress. The current Docker image does not contain the latest version of MELT.*

## Usage

To use MELT in your GitHub workflow, add the following snippet to your `.github/workflows/main.yml` file:

```yaml
on:
  pull_request:
    types: [opened, reopened]

jobs:
  gen_rules:
    runs-on: ubuntu-latest
    name: Automatically generate Comby rules from the pull request
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        with:
          fetch-depth: 2
          ref: ${{ github.event.pull_request.head.sha }}

      - name: Generate Comby rules
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
| `mountpoint` | Mount point for your repo           | Yes      |
| `basesha`    | SHA of the base of the merge        | Yes      |

## Outputs

| Output | Description                |
|--------|----------------------------|
| `rules`  | Rules MELT generated       |

## License

[MIT](LICENSE)

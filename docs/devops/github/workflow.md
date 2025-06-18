

## Token and Secret Management

### by default

```yaml
- name: something ...
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### using a personal access token (PAT)

1. repo → **settings** → **Secrets and variables** → **Actions** → **New repository secret**
2. using in workflow (example):
  ```yaml
  - name: deploy binaries to GitHub Release
    uses: softprops/action-gh-release@v2
    with:
      files: |
        dist/mtui-darwin-arm64
        dist/mtui-linux-amd64
        dist/mtui-windows-amd64.exe
    env:
      GITHUB_TOKEN: ${{ secrets.GH_PAT }}
  ```

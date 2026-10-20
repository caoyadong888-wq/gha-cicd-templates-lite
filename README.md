# GitHub Actions CI/CD Templates (preview)

A free preview of the GitHub Actions CI/CD Templates Pack. This repository has two workflows and a tiny Python app:

- `python-ci.yml` runs Ruff and pytest on Python 3.11 and 3.12, with a pip cache
- `docker-build-push.yml` builds that app with Docker Buildx and pushes to GitHub Container Registry (GHCR)

The Docker login uses `secrets.GITHUB_TOKEN` only. You do not create a personal access token. Sample image tags are semver (`1.2.3`, `1.2` from a `v1.2.3` tag), `sha-<short>`, and `latest` on the default branch. Pull requests build and do not push.

Workflows live in `.github-templates/`. GitHub runs files in `.github/workflows/`. The install script copies them.

## Requirements

- A GitHub repository you can push to
- Docker, for `make demo` and `./tests/run_tests.sh`
- Python is installed inside the `python:3.12` demo image. The host does not need a local Python for the demo

## Quick start

1. Run `./scripts/install-workflows.sh`.
2. If your app is not in `examples/python-app`, change `working-directory`, `cache-dependency-path`, and the Docker `context`.
3. In the repository settings, allow Actions to read and write packages if you want GHCR pushes. The workflow already requests `packages: write` for `GITHUB_TOKEN`.
4. Run the demo, then push `main`.

## One-click demo

```
make demo
```

`make demo` runs `./demo.sh`. That starts `python:3.12`, installs `examples/python-app/requirements.txt` and `requirements-dev.txt`, runs `ruff check --no-cache .`, and runs `pytest`. Those are the same commands as `.github-templates/python-ci.yml`.

```
./tests/run_tests.sh
```

runs actionlint, yamllint, and the Python demo.

## Deliverables / 交付物清单

- `.github-templates/python-ci.yml`
- `.github-templates/docker-build-push.yml`
- `examples/python-app/` with tests and a Dockerfile
- `demo.sh` and `Makefile` (`make demo`)
- `scripts/install-workflows.sh`
- `tests/run_tests.sh`
- `screenshots/` rendered from real actionlint and test output
- `.gitignore` and `.yamllint.yml`
- `LICENSE` (MIT)

## Estimated setup time / 预计部署时间

About 15 minutes. Copy the two workflows, run `make demo`, and push the repository. The first GHCR push creates the package under `ghcr.io/<owner>/<repository>`.

## 预计交付时间 / Estimated delivery time

Download is instant after payment. Setup on your own machine is about 15 minutes: copy the two workflows, run `make demo`, and push the repository. A custom setup service, if you order one, takes 1–2 business days.

付款后立即下载。自行部署大约 15 分钟：复制两条工作流，运行 `make demo`，然后推送仓库。如果需要代为部署，定制服务为 1–2 个工作日。

## License

This preview is MIT. See `LICENSE`.

## Full version / 完整版

The full pack is sold separately at https://caoyadong.gumroad.com/l/zbggp.

A related product, the $9 n8n DevOps Automation Pack, is at https://caoyadong.gumroad.com/l/yvmcqj

Only in the full version:

- `.github-templates/node-ci.yml`
- `.github-templates/deploy-ssh.yml` (SSH deploy, environment protection, manual approval)
- `.github-templates/release.yml` (tag, changelog, GitHub Release)
- `.github-templates/scheduled-healthcheck.yml` (cron curl, open an issue on failure)
- `.github-templates/reusable-python-ci.yml`
- `.github-templates/call-reusable-python-ci.yml`
- `examples/node-app/`
- `docs/secrets-setup.md` (bilingual secrets and environment guide)
- `CHANGELOG.md`
- `marketing/listing_en.md`
- `marketing/cover.png`
- `marketing/thumb.png`
- `marketing/make_images.py`
- `GUMROAD_LISTING.md`

The full license is personal and commercial use on your own servers and on client servers, with no resale and no redistribution. This preview stays MIT.

## 中文说明

这是 GitHub Actions CI/CD 模板包的免费预览。本仓库有两条工作流和一个很小的 Python 应用：

- `python-ci.yml`：在 Python 3.11 和 3.12 上运行 Ruff 和 pytest，并缓存 pip
- `docker-build-push.yml`：用 Docker Buildx 构建该应用，并推送到 GitHub Container Registry（GHCR）

Docker 登录只用 `secrets.GITHUB_TOKEN`，不需要个人访问令牌。标签包括 semver（`v1.2.3` 会得到 `1.2.3` 和 `1.2`）、`sha-<短提交号>`，以及默认分支上的 `latest`。Pull request 只构建，不推送。

工作流放在 `.github-templates/`。GitHub 只运行 `.github/workflows/` 里的文件。安装脚本负责复制。

### 环境要求

- 一个你可以推送的 GitHub 仓库
- Docker，用来运行 `make demo` 和 `./tests/run_tests.sh`
- 演示用的 Python 在 `python:3.12` 镜像里。跑演示时本机不必另装 Python

### 快速开始

1. 运行 `./scripts/install-workflows.sh`。
2. 如果你的应用不在 `examples/python-app`，修改 `working-directory`、`cache-dependency-path` 和 Docker 的 `context`。
3. 若要推送到 GHCR，在仓库设置里允许 Actions 读写 packages。工作流已经为 `GITHUB_TOKEN` 申请了 `packages: write`。
4. 先跑演示，再推送 `main`。

### 一键演示

```
make demo
```

`make demo` 会执行 `./demo.sh`。它启动 `python:3.12`，安装 `examples/python-app/requirements.txt` 和 `requirements-dev.txt`，再执行 `ruff check --no-cache .` 和 `pytest`。命令与 `.github-templates/python-ci.yml` 相同。

```
./tests/run_tests.sh
```

会运行 actionlint、yamllint，以及上面的 Python 演示。

### 交付物清单 / Deliverables

- `.github-templates/python-ci.yml`
- `.github-templates/docker-build-push.yml`
- `examples/python-app/`（含测试和 Dockerfile）
- `demo.sh` 和 `Makefile`（`make demo`）
- `scripts/install-workflows.sh`
- `tests/run_tests.sh`
- `screenshots/`（由真实的 actionlint 和测试输出渲染）
- `.gitignore` 和 `.yamllint.yml`
- `LICENSE`（MIT）

### 预计部署时间

大约 15 分钟。复制两条工作流，运行 `make demo`，然后推送仓库。第一次推送会在 `ghcr.io/<owner>/<repository>` 下创建 package。

### 预计交付时间 / Estimated delivery time

付款后立即下载。自行部署大约 15 分钟：复制两条工作流，运行 `make demo`，然后推送仓库。如果需要代为部署，定制服务为 1–2 个工作日。

Download is instant after payment. Setup on your own machine is about 15 minutes. A custom setup service takes 1–2 business days.

### 许可证

本预览版使用 MIT，见 `LICENSE`。

### 完整版

完整版单独销售，地址是 https://caoyadong.gumroad.com/l/zbggp。

另一件相关商品是 9 美元的 n8n DevOps Automation Pack：https://caoyadong.gumroad.com/l/yvmcqj

只在完整版中提供：

- `.github-templates/node-ci.yml`
- `.github-templates/deploy-ssh.yml`（SSH 部署、环境保护、人工批准）
- `.github-templates/release.yml`（标签、变更说明、GitHub Release）
- `.github-templates/scheduled-healthcheck.yml`（定时 curl，失败时开 issue）
- `.github-templates/reusable-python-ci.yml`
- `.github-templates/call-reusable-python-ci.yml`
- `examples/node-app/`
- `docs/secrets-setup.md`（中英双语的 secret 与环境说明）
- `CHANGELOG.md`
- `marketing/listing_en.md`
- `marketing/cover.png`
- `marketing/thumb.png`
- `marketing/make_images.py`
- `GUMROAD_LISTING.md`

完整版许可是：可在你自己的服务器和客户服务器上个人使用和商业使用，不得转售，不得再分发。本预览保持 MIT。

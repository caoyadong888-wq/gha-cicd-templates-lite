# Test results

Date: 2026-10-20T02:45:01Z

## Tool versions

```
actionlint:
1.7.12
installed by building from source
built with go1.26.1 compiler for linux/amd64
python image:
Python 3.12.15
pinned in examples/python-app/requirements-dev.txt:
ruff==0.17.0
pytest==8.3.5
yamllint: 1.35.1 installed in the yamllint check (python:3.12)
pillow:
12.3.0
```

## Checks

```
PASS: actionlint (.github-templates)
PASS: yamllint
PASS: python:3.12 demo (ruff + pytest)
PASS: readme and required files
PASS: screenshots
PASS: secret scan
checks failed: 0
PASS: all checks
```

## Command output

```

$ actionlint (.github-templates)
$ actionlint -version
1.7.12
installed by building from source
built with go1.26.1 compiler for linux/amd64

$ actionlint .github-templates/*.yml
exit code: 0

$ yamllint
yamllint yamllint 1.35.1
Python 3.12.15
exit code: 0

$ python:3.12 demo (ruff + pytest)
All checks passed!
....                                                                     [100%]
4 passed in 0.01s
exit code: 0

$ readme and required files
found README phrase: Deliverables / 交付物清单
found README phrase: Estimated setup time / 预计部署时间
found README phrase: make demo
found README phrase: 中文说明
found README phrase: Full version / 完整版
found README phrase: GUMROAD_URL
found README phrase: https://caoyadong.gumroad.com/l/yvmcqj
found README phrase: $9
exit code: 0

$ screenshots
screenshots/actionlint.png PNG (1280, 720)
screenshots/example-tests.png PNG (1280, 1440)
actionlint.png matches ../screenshots/actionlint.png
example-tests.png matches ../screenshots/example-tests.png
exit code: 0

$ secret scan
no emails, private-network IPs, or private key blocks
exit code: 0
```

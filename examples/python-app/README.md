# Python example

A one-module service used by `python-ci.yml`, the reusable Python workflow, and `docker-build-push.yml`.

```
python -m pip install -q -r requirements.txt -r requirements-dev.txt
ruff check --no-cache .
pytest
```

The local demo runs those commands inside `python:3.12`. From the pack root: `make demo`.

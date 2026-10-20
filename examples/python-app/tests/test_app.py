"""Tests for the sample health payload."""

import pytest

from healthcheck.app import health


def test_health_returns_ok() -> None:
    assert health("demo") == {"status": "ok", "service": "demo"}


def test_health_strips_whitespace() -> None:
    assert health("  api  ") == {"status": "ok", "service": "api"}


def test_default_service_name() -> None:
    assert health()["service"] == "python-example"


def test_health_rejects_blank_name() -> None:
    with pytest.raises(ValueError, match="service name is required"):
        health("   ")

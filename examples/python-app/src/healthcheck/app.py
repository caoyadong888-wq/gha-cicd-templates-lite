"""Build a small health payload for the CI example."""


def health(service: str = "python-example") -> dict[str, str]:
    """Return a status payload for a named service.

    Raises:
        ValueError: service is empty or only whitespace.
    """
    name = service.strip()
    if not name:
        raise ValueError("service name is required")
    return {"status": "ok", "service": name}

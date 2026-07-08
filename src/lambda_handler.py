import html
import json

from zippy.quotes import get_random_quote

HTML_TEMPLATE = """<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Zippy Quotes</title>
  <style>
    body {{ font-family: sans-serif; max-width: 40rem; margin: 4rem auto; padding: 0 1rem; text-align: center; }}
    blockquote {{ font-size: 1.4rem; font-style: italic; }}
    a {{ color: inherit; }}
  </style>
</head>
<body>
  <h1>Are we having fun yet?</h1>
  <blockquote>{quote}</blockquote>
  <p><a href="/">Reload for another</a> &middot; <a href="/api/quote">JSON</a></p>
</body>
</html>
"""


def _response(status_code, content_type, body):
    return {
        "statusCode": status_code,
        "headers": {"content-type": content_type},
        "body": body,
    }


def handler(event, context):
    path = event.get("rawPath", "/")

    if path == "/":
        quote = html.escape(get_random_quote())
        return _response(200, "text/html", HTML_TEMPLATE.format(quote=quote))

    if path == "/api/quote":
        quote = get_random_quote()
        return _response(200, "application/json", json.dumps({"quote": quote}))

    return _response(404, "application/json", json.dumps({"error": "not found"}))

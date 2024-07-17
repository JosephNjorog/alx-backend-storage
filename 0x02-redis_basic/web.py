#!/usr/bin/env python3
"""
This module contains a function that returns the HTML content of a particular
URL and stores it in a Redis cache
"""
import redis
import requests
from typing import Optional, Callable
from functools import wraps


def count_url_calls(fn: Callable) -> Callable:
    """
    Wrapper function that counts how many times a URL is called

    Args:
        fn (Callable): function to wrap

    Returns:
        Callable: wrapped function
    """
    @wraps(fn)
    def increment_url_count(*args, **kwargs):
        """
        Increment calls of method
        """
        r: redis.Redis = redis.Redis()
        url: str = ''
        if args:
            url = args[0]
        if kwargs:
            url = kwargs["url"] if "url" in kwargs else url
        r.incr("count:{}".format(url))
        return fn(*args, **kwargs)
    return increment_url_count


@count_url_calls
def get_page(url: str) -> str:
    """
    Returns the HTML content of the URL

    Args:
        url (str): URL to request

    Returns:
        str: HTML content of the URL
    """
    r: redis.Redis = redis.Redis()

    page_cache: Optional[bytes] = r.get(url)
    html_content: Optional[str] = ''
    if page_cache:
        html_content = page_cache.decode('utf-8')
    else:
        html_content = requests.get(url).text
        r.setex(url, 10, html_content)

    return html_content

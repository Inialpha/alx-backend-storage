#!/usr/bin/env python3
""" module for Cache class """
import redis
from uuid import uuid4
from typing import Any, Callable, List, Union
from functools import wraps


def count_calls(method: Callable) -> Callable:
    """ count the number of times a method is called
    """
    @wraps(method)
    def wrapper(self, *args, **kwargs) -> str:
        """ increment wrapper """
        self._redis.incr(method.__qualname__)
        return method(self, *args, **kwargs)
    return wrapper


def call_history(method: Callable) -> Callable:
    """ keep track of methods inputs and output
    """
    @wraps(method)
    def wrapper(self, *args, **kwargs) -> Any:
        """ wrapper function """
        input_key = f"{method.__qualname__}:inputs"
        output_key = f"{method.__qualname__}:outputs"
        self._redis.rpush(input_key, str(args))
        output = method(self, *args, **kwargs)
        self._redis.rpush(output_key, output)
        return output
    return wrapper


def replay(fn: Callable) -> Any:
    """ print function call details """
    fn_name = fn.__qualname__
    input_key = f"{fn_name}:inputs"
    output_key = f"{fn_name}:outputs"
    cache = fn.__self__
    num = cache.get_int(fn_name)
    output_list = cache._redis.lrange(output_key, 0, -1)
    input_list = cache._redis.lrange(input_key, 0, -1)
    print(f"{fn_name} was called {num} times:")
    for inp, oup in zip(input_list, output_list):
        print("{}(*({},)) -> {}".format(fn_name, inp.decode('utf-8'), oup.decode('utf-8')))


class Cache:
    """
    the Cache class
    """

    def __init__(self):
        """ initialize a Cache instance """
        self._redis = redis.Redis()
        self._redis.flushdb()

    @count_calls
    @call_history
    def store(self, data: Union[str, int, float, bytes]) -> str:
        """ store method for storing <data> """
        key = str(uuid4())
        self._redis.set(key, data)
        return key

    def get(self, key: str, fn: Callable = None) -> Any:
        data = self._redis.get(key)
        if data:
            if fn:
                return fn(data)
        return data

    def get_str(self, key: str) -> str:
        """ get a string """
        return self.get(key, lambda s: s.decode('utf-8'))

    def get_int(self, key: str) -> int:
        """ get an int """
        return self.get(key, lambda i: int(i))

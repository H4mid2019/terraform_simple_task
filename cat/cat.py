import logging
import requests
import random
import os
import redis
import boto3
from multiprocessing.pool import ThreadPool

logger = logging.getLogger()
logger.setLevel(logging.INFO)
redis_host = os.getenv("REDIS_ADDRESS")
redis_port = os.getenv("REDIS_PORT")
DYNAMO_DB_TABLE = os.getenv("DYNAMO_DB_TABLE")
redis_cache = redis.StrictRedis(host=redis_host, port=redis_port, decode_responses=True)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(DYNAMO_DB_TABLE)


def put_fact(fact, hash_primary):
    response = table.put_item(
        Item={
            'CatFactHashKey': hash_primary,
            'fact': fact,
        }
    )
    return response


def read_fact(hash_primary):
    tr = table.get_item(Key={'CatFactHashKey': hash_primary})
    return tr['Item']


def fetcher(url):
    response = requests.get(url, timeout=3)
    if response.status_code == 200:
        return response.json().get("fact")


urls = ["https://catfact.ninja/fact"] * 5
pool = ThreadPool(5)
results = []
for i in urls:
    results.append(pool.apply_async(fetcher, args=(i,)))
pool.close()
pool.join()
results = [r.get() for r in results]

for index, fact in enumerate(results):
    put_fact(fact, f"fact{str(index)}")
    redis_cache.set(f"fact{str(index)}", fact)


def lambda_handler(event, context):
    hash_primary = random.randint(0, 9)
    functions = [read_fact, redis_cache.get]
    fact = random.choice(functions)(f"fact{str(hash_primary)}")

    return {"fact": fact}

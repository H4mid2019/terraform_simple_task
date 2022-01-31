import logging
import requests
import random
import os
import redis
import boto3
import threading

logger = logging.getLogger()
logger.setLevel(logging.INFO)
redis_host = os.getenv("REDIS_ADDRESS")
redis_port = os.getenv("REDIS_PORT")
DYNAMO_DB_TABLE = os.getenv("DYNAMO_DB_TABLE")
redis_cache = redis.StrictRedis(host=redis_host, port=redis_port, decode_responses=True)
FACT_COUNTS = 3
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
    return tr.get('Item').get("fact")


results = []


def fetcher():
    response = requests.get("https://catfact.ninja/fact", timeout=3)
    if response.status_code == 200:
        results.append(response.json().get("fact"))
        return


ths = []
for _ in range(0, FACT_COUNTS+1):
    ths.append(threading.Thread(target=fetcher))

for i in ths:
    i.start()
del i
for i in ths:
    i.join()

for index, fact in enumerate(results):
    put_fact(fact, f"fact{str(index)}")
    redis_cache.set(f"fact{str(index)}", fact)


def lambda_handler(event, context):
    hash_primary = random.randint(0, FACT_COUNTS)
    functions = [read_fact, redis_cache.get]
    fact = random.choice(functions)(f"fact{str(hash_primary)}")

    return {"fact": fact}

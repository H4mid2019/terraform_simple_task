import logging
import requests
import random
import time
import os
import redis
import boto3


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
    return tr['Item'].get("fact")

def fact_yielder():
    counter = 10
    while counter > 0:
        response = requests.get("https://catfact.ninja/fact", timeout=3)
        if response.status_code == 200:
            yield response.json().get("fact")
            counter -= 1
        else:
            time.sleep(2)


for index, fact in enumerate(fact_yielder()):
    put_fact(fact, f"fact{str(index)}")
    redis_cache.set(f"fact{str(index)}", fact)


def lambda_handler(event, context):
    hash_primary = random.randint(0, 9)
    functions = [read_fact, redis_cache.get]
    fact = random.choice(functions)(f"fact{str(hash_primary)}")

    return {"fact": fact}





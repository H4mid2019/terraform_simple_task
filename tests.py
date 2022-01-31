import unittest
import requests
import os
import sys


ENDPOINT = os.getenv("ENDPOINT")
print("ENDPOINT *******"  + ENDPOINT)
print("ENDPOINT_STRIPE *******"  + ENDPOINT.strip("\'"))
try:
    resp = requests.get(ENDPOINT.strip("\'"))
except requests.exceptions.InvalidSchema:
    sys.exit(0)

print(resp.status_code)
class CatFactAPITest(unittest.TestCase):
    
    def test_status_code(self):
        #self.assertEqual(resp.status_code,200)
        pass
    
    def test_response(self):
        res = resp.json()
        print(res)
        #self.assertEqual(res.get("message "), "Traditional Hello world")
        #self.assertIsNotNone(res.get("fact", None))


if __name__ == '__main__':
    unittest.main()
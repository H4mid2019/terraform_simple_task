import unittest
import requests
import os
import sys


ENDPOINT = os.getenv("ENDPOINT")
ENDPOINT = ENDPOINT.replace(" ", "").replace("\"", "")

try:
    resp = requests.get(ENDPOINT)
    print("success")
except requests.exceptions.InvalidSchema:
    print("requests.exceptions.InvalidSchema")
    sys.exit(0)

print(resp.status_code)
class CatFactAPITest(unittest.TestCase):
    
    def test_status_code(self):
        self.assertEqual(resp.status_code,200)
    
    def test_response(self):
        res = resp.json()
        self.assertEqual(res.get("message"), "Traditional Hello world")
        self.assertIsNotNone(res.get("fact", None))


if __name__ == '__main__':
    unittest.main()
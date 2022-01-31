import unittest
import requests
import os
import sys
import urllib.request


ENDPOINT = os.getenv("ENDPOINT")
try:
    E = ENDPOINT.replace(" ", "").replace("\"", "")
    print("ENDPOINT *******"  + E)
except Exception as e:
    print(str(e))
    sys.exit(0)

try:
    resp = urllib.request.urlopen(ENDPOINT)
except Exception as e:
    print(str(e))

try:
    resp = requests.get(E)
except requests.exceptions.InvalidSchema as ee:
    print(str(ee))
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
import unittest
import requests
import os


ENDPOINT = os.getenv("ENDPOINT")
resp = requests.get(ENDPOINT)


class CatFactAPITest(unittest.TestCase):
    
    def test_status_code(self):
        self.assertEqual(resp.status_code,200)
    
    def test_response(self):
        res = resp.json()
        self.assertEqual(res.get("message "), "Traditional Hello world")
        self.assertIsNotNone(res.get("fact", None))


if __name__ == '__main__':
    unittest.main()
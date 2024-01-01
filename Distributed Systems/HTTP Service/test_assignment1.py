####################
# Course: CSE138
# Date: Fall 2023
# Assignment: 1
# This document is the copyrighted intellectual property of the authors.
# Do not copy or distribute in any form without explicit permission.
###################

import unittest
import subprocess
import requests

PORT=8090

class TestHW1(unittest.TestCase):
  # Make some sort of http request
  def test1(self):
    res = requests.get('http://localhost:'+str(PORT)+'/hello')
    self.assertEqual(dict(res.json()), {"message":"world"}, msg='Incorrect response to /hello endpoint')

  # Send a parameter with request to app, and access that parameter in app
  def test2(self):
    res = requests.post('http://localhost:'+str(PORT)+'/hello/Slug')
    self.assertEqual(dict(res.json()), {"message":"Hi, Slug."}, msg='Incorrect response to POST request to /hello/<name> endpoint')

  def test3(self):
      res = requests.get('http://localhost:'+str(PORT)+'/test')
      self.assertEqual(dict(res.json()), {"message":"test is successful"}, msg='Incorrect response to GET request to /test endpoint')
      res = requests.post('http://localhost:'+str(PORT)+'/test?msg=foo')
      self.assertEqual(dict(res.json()), {"message":"foo"}, msg='Incorrect response to POST request to /test endpoint')

  # Set the status codes of responses
  def test4(self):
    res = requests.get('http://localhost:'+str(PORT)+'/hello')
    self.assertEqual(res.status_code, 200, msg='Did not return status 200 to GET request to /hello endpoint')

    res = requests.post('http://localhost:'+str(PORT)+'/hello')
    self.assertEqual(res.status_code, 405, msg='Did not return status 405 to POST request to /hello endpoint')

    res = requests.post('http://localhost:'+str(PORT)+'/hello/Slug')
    self.assertEqual(res.status_code, 200, msg='Did not return status 200 to POST request to /hello/<name> endpoint')

    res = requests.get('http://localhost:'+str(PORT)+'/hello/Slug')
    self.assertEqual(res.status_code, 405, msg='Did not return status 405 to GET request to /hello/<name> endpoint')

    res = requests.post('http://localhost:'+str(PORT)+'/test?msg=ha')
    self.assertEqual(res.status_code, 200, msg='Did not return status 200 to POST request to /test?msg=ha endpoint')

    res = requests.get('http://localhost:'+str(PORT)+'/test')
    self.assertEqual(res.status_code, 200, msg='Did not return status 200 to POST request to /test endpoint')

    res = requests.post('http://localhost:'+str(PORT)+'/test')
    self.assertEqual(res.status_code, 400, msg='Did not return status 200 to POST request to /test endpoint when no msg was given')



if __name__ == '__main__':
  unittest.main()

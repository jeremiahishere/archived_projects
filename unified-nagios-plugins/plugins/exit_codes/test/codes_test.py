from .. import exit_codes

class RunningCodeTest(unittest.TestCase):
  def setUp(self):
    self.code = RunningCode("message")

  def test_level(self):
    self.assertEqual(self.code.level, 1)

  def tearDown(self):
    pass
    
if __name__ == "__main__":
  unittest.main() 

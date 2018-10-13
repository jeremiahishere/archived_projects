from nagios_check_base import NagiosCheckBase

# this is a sample check only to test the base class
# delete when no longer used
class CheckSample(NagiosCheckBase):
  def __init__(self):
    super(CheckSample, self).__init__() 

if __name__ == "__main__":
  cu = CheckSample()
  cu.run_script()

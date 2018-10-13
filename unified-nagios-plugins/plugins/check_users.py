from nagios_check_base import NagiosCheckBase
from exit_codes.codes import *

import optparse
from subprocess import Popen, PIPE

class CheckUsers(NagiosCheckBase):
  """
  Checks the number of users logged in to the system

  The --warn and --critical flags should be set to the maximum number of allowable users
  """

  def run(self):
    """
    Call 'who' and count the number of lines to determine the number of users
    """
    p1 = Popen("who", stdout=PIPE)
    output_string = p1.stdout.read()
    users = len(output_string.split('\n'))

    if users >= self.options.critical_level:
      self.set_exit_code(CriticalCode("There are " + str(users) + " users right now."))
    elif users >= self.options.warn_level:
      self.set_exit_code(WarningCode("There are " + str(users) + " users right now."))

  def available_options(self, parser):
    """
    Default warning and critical arguments
    """
    parser.add_option("-w", "--warn", action="store", type="int", dest="warn_level", default="2", help="Number of users to trigger a warning")
    parser.add_option("-c", "--critical", action="store", type="int", dest="critical_level", default="5", help="Number of users to trigger a critical")
    return parser

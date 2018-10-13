from nagios_check_base import NagiosCheckBase
from exit_codes.codes import *

import optparse
from subprocess import Popen, PIPE
import re


class CheckSsh(NagiosCheckBase):
  """
  """

  def usage_description(self):
    return "tbd"

  def available_options(self, parser):
    """
    """
    parser.add_option("-o", "--host", action="store", type="string", dest="host", default="www.cloudspace.com", help="Host url.")
    parser.add_option("-u", "--user", action="store", type="string", dest="user", default="root", help="User name.")
    return parser

  def run(self):
    """
    Just returning a critical code for now because this is not complete
    """
    self.set_exit_code(UnknownCode("This plugin is not complete an should not be used."))
    return

    user_at_host = self.options.user + "@" + self.options.host
    p1 = Popen(["ssh", user_at_host, "-o", "StrictHostKeyChecking=no"], stdout=PIPE, stderr=PIPE)
    output = p1.stdout.read()
    error = p1.stderr.read()
    

    if error:
      self.set_exit_code(CriticalCode("There was an ssh error: " + error))
    elif "Permission denied (publickey)." in output:
      self.set_exit_code(RunningCode("This server cannot be accessed without a key."))
    elif "Are you sure you want to continue connecting (yes/no)?" in output:
      self.set_exit_code(CriticalCode("This server needs to be added to known_hosts before this check can run."))
    elif "Password: " not in output:
      self.set_exit_code(CriticalCode("No password prompt detected: " + output))
    # else, it is working, keep the running code

# if __name__ == "__main__":
#   checker = CheckSsh()
#   checker.run()

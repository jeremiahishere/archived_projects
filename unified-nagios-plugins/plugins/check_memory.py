from nagios_check_base import NagiosCheckBase
from exit_codes.codes import *

import optparse
from subprocess import Popen, PIPE
import re


class CheckMemory(NagiosCheckBase):
  """
  Checks memory levels by parsing the output of 'free'

  The --warn and --crtical flags should be set to the minimum number of megabytes of free space.
  """

  def usage_description(self):
    return "Check for minimum amounts of free memory in the system."

  def available_options(self, parser):
    """
    Warn and Critical refer to the minimum number of megabytes before a status change is triggered
    """
    parser.add_option("-w", "--warn", action="store", type="int", dest="warn_level", default="90", help="Maximum amount of free memory before a warning is triggered")
    parser.add_option("-c", "--critical", action="store", type="int", dest="critical_level", default="95", help="Maximum amount of free memory before a critical is triggered")
    return parser

  def run(self):
    """
    Call free, read the results for memory available, and adds it to the message
    """
    p1 = Popen(["free", "-m"], stdout=PIPE)
    free_output = p1.stdout.read()
    self.set_status_on_memory_available(free_output)

  def set_status_on_memory_available(self, free_output):
    """
      Checks the buffers/cache line of the free output.  The second data point is checked against the warn and critical minimums.

      If there is a probably parsing the output, the status is changed to UNKNOWN.
    """
    # match line breaks
    matcher = re.compile('.*buffers/cache:[\s]*([\d]*)[\s]*([\d]*).*', re.DOTALL)
    matches = matcher.match(free_output)
    if matches:
      # this does not count memory used in buffer/cache
      used_memory = int(matches.group(1))
      free_memory = int(matches.group(2))
      total_memory = used_memory + free_memory
      # cast to floating point division
      percent_used = (used_memory / float(total_memory)) * 100

      if percent_used > self.options.critical_level:
        self.set_exit_code(CriticalCode("Free system memory: " + str(free_memory) + "MB."))
      elif percent_used > self.options.warn_level:
        self.set_exit_code(WarningCode("Free system memory: " + str(free_memory) + "MB."))
    else:
      self.set_exit_code(UnknownCode("The output of free could not be parsed:\n" + free_output))

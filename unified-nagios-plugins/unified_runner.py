# this file will be used as the starting point for all of the nagios tests
# it will handle arguments, figure out which script to run, call usage if necessary, and run the script

from plugins.exit_codes.codes import *
from optparse import OptionParser

# setting exit codes
import sys
import re

class UnifiedRunner(object):
  def __init__(self):
    """
    Read the first command line argument, instantiate the associated object, and handle errors
    """

    self.check = None
    self.exit_code = None

    # if there are no arguments, set unknown exit code
    if len(sys.argv) < 2:
      self.exit_code = UnknownCode("Missing arguments for UnifiedRunner")
    else:
      # figure out the class and module name
      # note that plugins is hard coded here
      class_name = self.to_class_name(sys.argv[1])
      module_name = "plugins." + sys.argv[1]

      # dynamically import the module
      __import__(module_name)
      module = sys.modules[module_name]
      # and instantiate the class
      CheckClass = getattr(module, class_name)
      self.check = CheckClass()

  def to_class_name(self, name):
    """
    Convert underscored works to capitalized: class_name to ClassName
    """
    return re.sub('_', '', name.title())

  def run(self):
    """
    Run the check class, print the exit message, and run a system exit with the specified level
    """
    # if the exit code is already set, we have bigger problems
    if not self.exit_code:
      self.exit_code = self.check.run_script()

    # print the message and exit with the status level
    print self.exit_code.message
    sys.exit(self.exit_code.level())

if __name__ == "__main__":
  runner = UnifiedRunner()
  runner.run()

from nagios_check_base import NagiosCheckBase
from exit_codes.codes import *

import optparse
from subprocess import Popen, PIPE
import re

class CheckDisk(NagiosCheckBase):
  """
  Checks if disk usage is higher than a percentage
  """
  
  def usage_description(self):
    return "Checks if disk usage is higher than a percentage"

  def available_options(self, parser):
    """
      Standard warn and critical options default to 75 and 85 percent of disk space
    """
    parser.add_option("-w", "--warn", action="store", type="int", dest="warn_level", default="75", help="Minimum disk usage percentage to trigger a warning.")
    parser.add_option("-c", "--critical", action="store", type="int", dest="critical_level", default="75", help="Minimum disk usage percentage to trigger a critical.")
    return parser

  def run(self):
    """
    Use df to read the disk usage.  Then write a response based on the percentage of used space.
    """
    p1 = Popen(["df"], stdout=PIPE)
    df_output = p1.stdout.read()

    use_percentages = self.get_disk_usage(df_output)
    self.process_use_percentages(use_percentages)

  def get_disk_usage(self, df_output):
    """
    Reads df output and finds the Use percentage on the / volume
    """
    # these are the columns in the df output
    filesystem = 0  # 0: Filesystem
    blocks = 1  # 1: 1K-blocks
    used = 2  # 2: Used
    available = 3  # 3: Available
    use_percentage = 4  # 4: Use%
    mounted_on = 5  # 5: Mounted on

    use_percentages = {}
    lines = df_output.split('\n')
    for line in lines:
      fields = line.split()
      if len(fields) == 6:
        # tempfs is a special filesystem in centos that we are ignoring
        if not 'tmpfs' in fields[filesystem]:
          use_percentages[fields[mounted_on]] = fields[use_percentage].rstrip('%')
    return use_percentages

  def process_use_percentages(self, use_percentages):
    """
    Compiles the message about each disk from the usages.  Sets the appropriate exit code.
    """
    critical = False
    warn = False
    output = ""
    # iterate over usages and set level
    for disk, use_percentage in use_percentages.iteritems():
      if int(use_percentage) >= int(self.options.critical_level):
        critical = True
      elif int(use_percentage) >= int(self.options.warn_level):
        warn = True
      output += "'" + disk + "': " + use_percentage + "%, "

    # set the exit code
    if critical:
      self.set_exit_code(CriticalCode(output))
    elif warn:
      self.set_exit_code(WarningCode(output))
    else:
      self.set_exit_code(RunningCode(output))

# for testing purposes only:
# if __name__ == "__main__":
#   check = CheckDisk()
#   check.run()

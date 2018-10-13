from nagios_check_base import NagiosCheckBase
from exit_codes.codes import *

import optparse
from subprocess import Popen, PIPE
import re
import time
from datetime import datetime
from time import mktime

class CheckDns(NagiosCheckBase):
  """
  Checks whois record to see when the dns expires

  The --url flag determines which url is checked.  
  The --warn and --critical flags set the minimum number of days before the dns record needs to be renewed

  Note that his check has bad support for determining the type of whois output.
  In the future, we may want to add support for checking for this: No match for "CLOUSDPACE.COM".
  """

  def usage_description(self):
    return "Check dns records to see if the url needs to be renewed."

  def available_options(self, parser):
    """
      Standard warn and critical options default to 90 days and 10 days before dns expiration.
      The url option determines which url to check.  It defaults to cloudspace.com and should be set whenever the script is run.
    """
    parser.add_option("-w", "--warn", action="store", type="int", dest="warn_level", default="90", help="Minimum number of days until dns expiration.")
    parser.add_option("-c", "--critical", action="store", type="int", dest="critical_level", default="10", help="Minimum number of days until dns expiration.")
    parser.add_option("-u", "--url", action="store", type="string", dest="url", default="cloudspace.com", help="URL to check.")
    return parser

  def run(self):
    """
    Use whois to read the expiration date of the domain name.
    Check if the expiration date is coming up soon and set appropriate exit codes.
    """
    p1 = Popen(["whois", self.options.url], stdout=PIPE)
    whois_output = p1.stdout.read()

    expiration_date = self.find_expiration_date(whois_output)
    today = datetime.now()
    self.compare_expiration_date(expiration_date, today)

  def find_expiration_date(self, whois_output):
    """
    Find expiration date from whois output.
    This is a naive solution to the problem and does not parse the entire file.

    Returns a datetime object representing the expiration date or None
    """
    matcher = re.compile('.*Expiration Date: ([\S]*).*') 
    lines = whois_output.split('\n')
    # Expiration Date: 31-oct-2015
    for line in lines:
      matches = matcher.match(line)
      if matches:
        expiration_date_struct = time.strptime(matches.group(1), '%d-%b-%Y')
        expiration_date = datetime.fromtimestamp(mktime(expiration_date_struct))
        return expiration_date
    return None

  def compare_expiration_date(self, expiration_date, today):
    """
    Given two dates, determines if there difference is below the warn/critical threshold and sets the exit codes
    """
    if expiration_date:
      days_until_expiration = (expiration_date - today).days
      print days_until_expiration
      print self.options.critical_level
      print self.options.warn_level
      if days_until_expiration < self.options.critical_level:
        self.set_exit_code(CriticalCode("The URL expires in " + str(days_until_expiration) + " days."))
      elif days_until_expiration < self.options.warn_level:
        self.set_exit_code(WarningCode("The URL expires in " + str(days_until_expiration) + " days."))
    else:
      self.set_exit_code(UnknownCode("The expiration date was not found."))

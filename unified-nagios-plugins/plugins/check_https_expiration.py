from nagios_check_base import NagiosCheckBase
from exit_codes.codes import *

import optparse
from subprocess import Popen, PIPE
import re
import datetime

class CheckHttpsExpiration(NagiosCheckBase):
  """
  Check if the ssl cert is expiring soon or has already expired by using the openssl program
  """

  def usage_description(self):
    return "Check if the ssl cert is expiring soon or has already expired"

  def available_options(self, parser):
    """
      Standard warn and critical options default to expiration 90 and 30 days in the future
      Additional path option to determine which cert to check
    """
    parser.add_option("-w", "--warn", action="store", type="int", dest="warn_level", default="90", help="Minimum days before cert expiration to trigger a warning.")
    parser.add_option("-c", "--critical", action="store", type="int", dest="critical_level", default="75", help="Minimum days before cert expiration to trigger a critical.")
    parser.add_option("-p", "--path", action="store", type="string", dest="path", default="/srv/default/default.crt", help="Absoluate path to cert file.")
    return parser

  def run(self):
    """
    Use openssl to check expiration dates of the given ssl cert
    """
    # noout suppresses the cert hash, dates ads dates to the output, in sets the file, x509 is the encoding (I think)
    # if there is a problem reading the file or with openssl, output goes to stderr
    p1 = Popen(["openssl", "x509", "-noout", "-in", self.options.path, "-dates"], stdout=PIPE, stderr=PIPE)
    openssl_output = p1.stdout.read()
    openssl_error = p1.stderr.read()

    # if there is anything in standard error, set a critical code and exit
    if openssl_error:
      self.set_exit_code(CriticalCode("There was an error with the openssl program: " + openssl_error))
    else:
      # parse standard out and set the appropriate code
      cert_dates = self.get_cert_dates(openssl_output)
      self.process_cert_dates(cert_dates)

  def get_cert_dates(self, openssl_output):
    """
    Parse the data returned from the openssl call
    format:
    notBefore=Sep 16 20:47:42 2010 GMT
    notAfter=Sep 16 20:47:42 2015 GMT
    """
    lines = openssl_output.splitlines()

    output = {}
    for line in lines:
      fields = line.split('=')
      # See method doc for date format
      # expect each line to have the format dateName=<datetime>
      output[fields[0]] = datetime.datetime.strptime(fields[1], "%b %d %H:%M:%S %Y %Z")
    return output

  def process_cert_dates(self, cert_dates):
    """
    Set the exit code based on the dates given by the parsed openssl output
    Note that the warning and critical responses are the same
    A special check determines if the cert end date is missing from the input and adds a critical code

    Sample outputs:
    "RUNNING - https expires in more than <warning> days"
    "WARNING/CRITICAL - https expires in X days"
    """
    if 'notAfter' not in cert_dates:
      self.set_exit_code(CriticalCode("The output of openssl could not be parsed."))
    else:
      today = datetime.datetime.today()
      days_until_expiration = (cert_dates['notAfter'] - today).days

      if days_until_expiration <= self.options.critical_level:
        self.set_exit_code(CriticalCode("https expires in " + str(days_until_expiration) + " days."))
      elif days_until_expiration <= self.options.warn_level:
        self.set_exit_code(WarningCode("https expires in " + str(days_until_expiration) + " days."))
      else:
        self.set_exit_code(RunningCode("https expires in more than " + str(self.options.warn_level) + " days."))

# for testing purposes only
# if __name__ == "__main__"
#   checker = CheckHttpsExpiration()
#   checker.run()

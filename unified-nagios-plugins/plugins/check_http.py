from nagios_check_base import NagiosCheckBase
from exit_codes.codes import *

import optparse
from subprocess import Popen, PIPE
import re

class CheckHttp(NagiosCheckBase):
  """
  Checks if a given url responds with a 200 and includes a string of text
  """

  def usage_description(self):
    return "Checks if a given url responds with a 200 and includes a string of text.  Note that this test has no warn or critical options."

  def available_options(self, parser):
    """
    No warn and critical options on this check
    url: the url to check
    string: the text to look for at the url
    """
    parser.add_option("-u", "--url", action="store", type="string", dest="url", default="http://www.cloudspace.com", help="URL to check.")
    parser.add_option("-s", "--search", action="store", type="string", dest="search", default="Cloudspace", help="What to look for.")
    return parser

  def run(self):
    """
    curl the host
    read the response code
    check if the search string is there
    set a critical code if anything fails
    """
    response_code = self.get_response_code()
    if response_code != "200":
      self.set_exit_code(CriticalCode("The site responded with " + response_code))

    matched = self.search_string_match()
    if not matched:
      self.set_exit_code(CriticalCode("Search string could not be found"))

  def get_response_code(self):
    """
    curl http://www.cloudspace.com -o /dev/null -sL -w "%{http_code}"
    -o: redirect output to dev/null
    -s: hide regular output
    -L: follow redirects (avoid 301 I think)
    -w: use custom output
    """
    p1 = Popen(["curl", self.options.url, "-s", "-L", "-o", "/dev/null", "-w", "\"%{http_code}\""], stdout=PIPE, stderr=PIPE)
    response = p1.stdout.read()
    response = response.strip('"')
    return response

  def search_string_match(self):
    """
    Basic curl to just read the html of the page, then search for the string
    """
    p1 = Popen(["curl", self.options.url], stdout=PIPE, stderr=PIPE)
    curl_output = p1.stdout.read()

    return self.options.search in curl_output

# if __name__ == "__main__":
#   checker = CheckHttp()
#   checker.run()

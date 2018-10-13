from nagios_check_base import NagiosCheckBase
from exit_codes.codes import *

import optparse
from subprocess import Popen, PIPE


class CheckMysql(NagiosCheckBase):
  """
  Connect to a mysql server, run a query on it, and valdiate the results.
  """

  def usage_description(self):
    return "Connect to a mysql server, run a query on it, and valdiate the results."

  def available_options(self, parser):
    """
    No warn or critical options here
    First three options connect to the server
    The next option sets the database
    The last two options query the database and optionally check the results
    """
    parser.add_option("-u", "--user", action="store", type="string", dest="user", default="root", help="The mysql user.")
    parser.add_option("-p", "--password", action="store", type="string", dest="password", default="", help="The mysql password. This defaults to an empty password.")
    parser.add_option("-o", "--host", action="store", type="string", dest="host", default="localhost", help="The mysql host. Note that this uses the o argument because h is reserved.  This defaults to localhost.")
    parser.add_option("-d", "--database", action="store", type="string", dest="database", default="the_db", help="The database to query.")
    parser.add_option("-q", "--query", action="store", type="string", dest="query", default="select 1234 + 5678", help="The query to run.  Defaults to a simple math expression.")
    parser.add_option("-r", "--result", action="store", type="string", dest="result", default="", help="Optional string to search for in the query result.  If this string is not found, return a critical code.  If the string is not set, any successful query will return a running code.")
    return parser

  def run(self):
    command = ["mysql", "-u" + self.options.user]
    if self.options.password:
      command.append( "-p" + self.options.password)
    command += ["-h" + self.options.host, self.options.database, "-e" + self.options.query]

    p1 = Popen(command, stdout=PIPE, stderr=PIPE)
    output = p1.stdout.read()
    errors = p1.stderr.read()

    if errors:
      self.set_exit_code(CriticalCode(errors))
    elif self.options.result and self.options.result not in output:
      # if result is set, check if it is in the output
      self.set_exit_code(CriticalCode("Expected output, " + self.options.result + ", was not found in the output: " + output))

# if __name__ == "__main__":
#   checker = CheckMysql()
#   checker.run()

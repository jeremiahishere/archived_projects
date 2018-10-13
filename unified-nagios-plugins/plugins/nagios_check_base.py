# option parsing
import optparse

# from exit_codes import codes
from exit_codes.codes import *

class NagiosCheckBase(object):
  """
  Base class for nagios checks.

  It handles statuses, running the check, and setting exit codes.
  Child classes only need to override the run method to make a basic check.
  """

  def __init__(self):
    """
    Set the status and parse command line arguments.
    """
    self.set_exit_code(RunningCode("Running normally."))
    self.set_options()

  def usage_description(self):
    """
    Set the description of the check when calling usage/help.
    This should be overriden by all child classes.
    """
    return "This is a nagios check"

  # this is designed to be overridden
  # note that the help message and defaults are probably not what you want
  def available_options(self, parser):
    """
    Sets default command line arguments for warn and critical levels.

    This should be overriden by all child classes to set the help and default values.
    """
    parser.add_option("-w", "--warn", action="store", type="int", dest="warn_level", default="1", help="Exceeding this amount will trigger a warning")
    parser.add_option("-c", "--critical", action="store", type="int", dest="critical_level", default="2", help="Exceeding this amount will trigger an error")
    return parser

  def set_options(self):
    """
    Setup the command line parser, run it, save the results to the options field
    """
    parser = optparse.OptionParser(self.usage_description())
    parser = self.available_options(parser)
    (options, args) = parser.parse_args()
    # note that unnamed/positional arguments are not saved
    self.options = options

  def set_exit_code(self, exit_code):
    """
    Set the status level and message

    If a status level decrease is attempted, the status will be changed to STATUS_UNKNOWN.

    When the status level is escalated, the status_message will be overwritten.
    When a duplicate status level is set, the message will be appended to the status_message.
    """
    if not hasattr(self, 'exit_code'):
      self.exit_code = exit_code
    elif self.exit_code.level > exit_code.level:
      self.exit_code = UnknownCode("The exit code level cannot be lowered.")
    elif self.exit_code.level == exit_code.level:
      self.exit_code.append_message(exit_code.message)
    else: # self.status_level < level
      self.exit_code = exit_code

  def run(self):
    """
    Put code here to be run.
    Should be overridden by child classes.
    """
    self.set_status_level(self.STATUS_UNKNOWN, "The run method for this check has not been written.")

  def run_script(self):
    """
    Wrapper around run method that outputs the status_message and sets the exit code.
    """
    try:
      self.run()
    except NotImplementedError as e:
      self.set_exit_code(UnknownCode("Attempted to run a feature that has not been implemented: %s" % e))
    except BaseException as e:
      self.set_exit_code(UnknownCode("An error has occurred: %s" % e))

    return self.exit_code

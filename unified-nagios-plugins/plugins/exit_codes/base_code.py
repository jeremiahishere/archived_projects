class BaseCode(object):
  """
  Base exit code for a nagios test
  """

  def __init__(self, new_message):
    self.message = self.message_prefix() + " - " + new_message

  def append_message(self, new_message):
    self.message += new_message

  def level(self):
    return -1

  def message_prefix(self):
    return "BASECODE"

  # not sure if this is necessary
  def message(self):
    return self.message

  def __eq__(self, other):
    return self.level() == other.level()

  def __ne__(self, other):
    return not self.__eq__(other)

  def __gt__(self, other):
    return self.level() > other.level()

  def __ge__(self, other):
    return self.level() >= other.level()

  def __lt__(self, other):
    return not self.__gt__(other)

  def __le__(self, other):
    return not self.__ge__(other)

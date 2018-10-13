from base_code import BaseCode

class RunningCode(BaseCode):
  def level(self):
    return 0

  def message_prefix(self):
    return "OK"

class WarningCode(BaseCode):
  def level(self):
    return 1

  def message_prefix(self):
    return "WARNING"

class CriticalCode(BaseCode):
  def level(self):
    return 2

  def message_prefix(self):
    return "CRITICAL"

class UnknownCode(BaseCode):
  def level(self):
    return 3

  def message_prefix(self):
    return "UNKNOWN"

# register the observer so that it starts watching mail
ActionMailer::Base.register_observer(EmailManager::ManagedEmailObserver)

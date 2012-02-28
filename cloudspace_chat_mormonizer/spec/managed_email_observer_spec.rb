require 'spec_helper'

describe EmailManager::ManagedEmailObserver do
  describe "deliver_email" do
    before(:each) do
      DummyMailer.deliver_dummy_email_notification
    end

    it "should only store the calling file of the email if it is in /app" do
      email = EmailManager::ManagedEmail.last
      email.caller.should == ""
    end

    it "should create a ManagedEmail instance" do
      email = EmailManager::ManagedEmail.last 
      email.to.should == "test@email_manager.gem"
      email.subject.should == "Dummy email notification"
      email.body.should == "This is a dummy email notification.  It should never be sent.\n"
    end
  end 
end

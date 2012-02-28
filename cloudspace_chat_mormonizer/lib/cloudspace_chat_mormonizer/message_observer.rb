module CloudspaceChatMormonizer
  class MessageObserver
    def prepare_input_text
      self.output_text.gusb!(/scott/i, "Scoot")
    end
  end
end

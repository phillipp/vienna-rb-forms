class TicketAnswerInteraction < Interaction
  attributes :text
  validates  :text, presence: true

  def initialize(ticket, attributes = {})
    @ticket = ticket
    super(attributes)
  end

  private

  def execute
    TicketAnswer.create! do |answer|
      answer.ticket = @ticket
      answer.text   = text
    end
    @ticket.user_replied!
    @ticket.notify_observers
    @ticket.perform_indexing!
  end
end

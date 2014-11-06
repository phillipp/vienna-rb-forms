RSpec::Matchers.define :allow_form_fields do |*expected|
  match do |subject|
    expected.map(&:to_s) == (subject.is_a?(Class) ? subject : subject.class).allowed_attributes
  end

  failure_message_for_should do |subject|
    klass = subject.is_a?(Class) ? subject : subject.class
    "expected #{klass.to_s} to allow form fields #{expected.map(&:to_s)}, but allows #{klass.allowed_attributes}"
  end
end

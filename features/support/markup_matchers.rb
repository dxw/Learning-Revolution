require 'markup_validity'

module Spec
  module Matchers
    def be_atom
      Matcher.new :be_atom do
        match do |atom|
          rng = Nokogiri::XML::RelaxNG(open('features/step_definitions/atom.rng').read)
          feed = Nokogiri::XML(atom)
          rng.valid?(feed)
        end

        failure_message_for_should do |actual|
          atom
        end
      end
    end
    def be_icalendar
      Matcher.new :be_icalendar do
        match do |ical|
          calendar = Icalendar.parse(ical)
        end

        failure_message_for_should do |actual|
          calendar
        end
      end
    end
  end
end

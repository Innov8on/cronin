module Cronin
  module Restricted

    def restricted?
      case @cron_value
        #TODO: repetition code from abstract timing
      when /^(\d{1,2}|\*\/\d{1,2})$/
        return true
      when "*"
      end
    end

  end
end

module System
  class Base
    OS_NAME=%w(windows linux macintosh)

    def self.os_by_user_agent(user_agent)
      user_agent=user_agent.downcase
      OS_NAME.each do |os|
        if match=Regexp.new(os).match(user_agent)
          return match[0]
        end
      end
    end
  end
end
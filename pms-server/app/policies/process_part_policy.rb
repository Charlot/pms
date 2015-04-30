class ProcessPartPolicy < ApplicationPolicy
	def update?
		user.av?
	end
end
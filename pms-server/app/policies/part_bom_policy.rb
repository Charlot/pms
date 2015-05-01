class PartBomPolicy<ApplicationPolicy
	def update?
		user.av?
	end
end
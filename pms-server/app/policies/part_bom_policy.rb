class PartBomPolicy<ApplicationPolicy
	def update?
		user.av? || user.system?
	end
end
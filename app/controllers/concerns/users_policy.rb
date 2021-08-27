module UsersPolicy
	extend ActiveSupport::Concern

	def can_read?(current_user)
		admin_present = current_user.roles.find_by(permission: "admin")
		return true if admin_present

		false
	end

	def can_delete?(current_user)
		admin_present = current_user.roles.find_by(permission: "admin")
		return true if admin_present

		false
	end

	def can_update?(user, current_user)
		admin_present = current_user.roles.find_by(permission: "admin")
		return true if admin_present
		
		user.id == current_user.id
	end
end
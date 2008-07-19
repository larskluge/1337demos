class Category < ActiveRecord::Base
	acts_as_nested_set :scope => "`published` = 1"

	@active = nil
	@leaf = nil



	def active?(controller, action)
		return @active unless @active.nil? # use cached value

		return @active = controller == self.controller && action == self.action
	end

	def self_or_descendant_active?(controller, action)
		return true if self.active?(controller, action)

		self.children.each do |child|
			return true if child.self_or_descendant_active?(controller, action)
		end
		return false
	end

	def leaf?
		return @leaf unless @leaf.nil? # use cached value

		return @leaf = self.children.empty?
	end
end


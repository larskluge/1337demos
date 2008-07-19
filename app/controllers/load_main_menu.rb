class LoadMainMenu
	def self.filter(controller)
		#controller.mainmenu = Category.find :all, :include => [ :children ], :conditions => '`published` = 1'
		#controller.mainmenu = Category.find :first, :include => [ :children ], :conditions => '`published` = 1'

		# loads just 3 levels of navigation
		# stupid implementation
		#controller.mainmenu = Category.find :first, :include => [ :children => [ :children => [ :children ] ] ],
		#							:conditions => '`published` = 1',
		#							:order => 'parent_id'
		controller.mainmenu = Category.find :first, :conditions => '`published` = 1'
	end
end

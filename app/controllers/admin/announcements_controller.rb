class Admin::AnnouncementsController < Admin::ApplicationController

	# caching
	cache_sweeper :announcement_sweeper, :only => [:create, :update, :destroy]

  active_scaffold :announcement do |opts|
    list.per_page = 50
    list.sorting = {:created_at => 'DESC'}
  end
end


class Admin::AnnouncementsController < Admin::ApplicationController

  active_scaffold :announcement do |opts|
    list.per_page = 50
    list.sorting = {:created_at => 'DESC'}
  end
end


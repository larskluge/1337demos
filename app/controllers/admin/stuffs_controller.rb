class Admin::StuffsController < Admin::ApplicationController

  active_scaffold :stuff do |opts|
    list.columns = [:name, :filename, :size, :comment, :created_at]
    list.per_page = 50
    list.sorting = {:created_at => 'DESC'}

    show.columns = [:name, :filename, :size, :comment, :content_type, :created_at]
  end

end


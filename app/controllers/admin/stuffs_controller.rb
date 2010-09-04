class Admin::StuffsController < Admin::ApplicationController

  active_scaffold :stuff do |opts|
    list.columns = [:name, :stuff_file_file_name, :stuff_file_file_size, :comment, :created_at]
    list.per_page = 50
    list.sorting = {:created_at => 'DESC'}

    show.columns = [:name, :stuff_file_file_name, :stuff_file_file_size, :comment, :stuff_file_content_type, :created_at]
  end

end


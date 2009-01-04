class Admin::StuffsController < Admin::ApplicationController

  active_scaffold :stuff do |opts|
    list.columns = [:name, :filename, :size, :created_at]
    list.per_page = 50
    list.sorting = {:created_at => 'DESC'}
  end

end

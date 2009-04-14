class Admin::NicknamesController < Admin::ApplicationController

  active_scaffold :nicknames do |opts|
    list.columns = [:nickname, :created_at]
    list.per_page = 50
    list.sorting = {:created_at => 'DESC'}
  end

end


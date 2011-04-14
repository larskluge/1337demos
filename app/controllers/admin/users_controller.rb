class Admin::UsersController < Admin::ApplicationController

  active_scaffold :user do |opts|
    list.columns = [:approved, :name, :mail, :created_at]
    list.per_page = 50
    list.sorting = {:created_at => 'DESC'}

    show.columns = [:approved, :name, :mail]

    opts.columns[:approved].form_ui = :checkbox
    opts.columns[:approved].inplace_edit = true
  end

end


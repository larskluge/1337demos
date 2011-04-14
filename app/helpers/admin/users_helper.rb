module Admin::UsersHelper

  def name_column(record)
    render_nickname_plain(record.name)
  end

end


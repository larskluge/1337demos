module Admin::NicknameHelper

  def nickname_column(record)
    raw '<div style="background-color:#ccc">%s</div>' % render_nickname(record.nickname)
  end

end


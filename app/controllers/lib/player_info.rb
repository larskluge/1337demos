module PlayerInfo

  protected

  def player_info
    @playerinfo ||= if cookies[:player].present?
      YAML.load(cookies[:player])
    else
      {}
    end
  end

  def persist_player_info(comment)
    if comment
      cookies[:player] = {
        :value => {:name => comment.name, :mail_pass => comment.mail_pass}.to_yaml,
        :expires => 1.year.from_now
      }
    end
  end
end


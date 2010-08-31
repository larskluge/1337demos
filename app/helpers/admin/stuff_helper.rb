module Admin::StuffHelper

  def name_column(record)
    c = record.comment
    if c
      gravatar_tag(c, 20) + ' ' + mail_to(c.mail, render_nickname_plain(c.name))
    else
      'anonymous'
    end
  end

  def filename_column(record)
    link_to record.filename, record.stuff_file.url
  end

  def size_column(record)
    number_to_human_size record.size
  end

  def comment_column(record)
    h record.comment.message
  end

end


class CommentSweeper < ActionController::Caching::Sweeper

  # This sweeper is going to keep an eye on this model
  observe Comment

  def after_save(record)
    expire_cache_for(record)
  end

  def after_destroy(record)
    expire_cache_for(record)
  end

  private
  def expire_cache_for(record)
    case(record.commentable_type.to_s.downcase)
    when 'welcomes'
      expire_action(:controller => '/welcomes', :action => 'index')
      # and delete all pages
      expire_fragment(%r{/welcomes/index*})
    when 'demo'
      expire_action(:controller => '/comments', :action => 'index')
      expire_fragment(%r{/comments/index*})
    end
  end
end


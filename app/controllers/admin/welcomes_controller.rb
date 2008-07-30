class Admin::WelcomesController < Admin::ApplicationController

  def index
    list
    render :action => 'list'
  end

  def list
	@cnt_cached_files = nil
	if cache_store.class == ActiveSupport::Cache::FileStore
		@cnt_cached_files = `find "#{cache_store.cache_path}" -type f -iname "*.cache" | wc -l`.to_i
	end


	@demos = Demo.all :order => 'updated_at DESC', :conditions => 'data_correct IS NULL OR data_correct = 0'
  end

  def delete_cache
	`find "#{cache_store.cache_path}" -type f -iname "*.cache"`.split("\n").each do |f|
		File.delete f
	end

	redirect_to :action => 'index'
  end

end


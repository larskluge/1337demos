class Admin::NicknamesController < Admin::ApplicationController
	# GET /admin_nicknames
	# GET /admin_nicknames.xml
	def index
		@nicknames = Nickname.find(:all, :order => 'updated_at DESC')

		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @nicknames }
		end
	end

	# GET /admin_nicknames/1
	# GET /admin_nicknames/1.xml
	def show
		@nickname = Nickname.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @nickname }
		end
	end

	# GET /admin_nicknames/new
	# GET /admin_nicknames/new.xml
	def new
		@nickname = Nickname.new

		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @nickname }
		end
	end

	# GET /admin_nicknames/1/edit
	def edit
		@nickname = Nickname.find(params[:id])
	end

	# POST /admin_nicknames
	# POST /admin_nicknames.xml
	def create
		@nickname = Nickname.new(params[:nickname])

		respond_to do |format|
			if @nickname.save
				flash[:notice] = 'Nickname was successfully created.'
				format.html { redirect_to([:admin, @nickname]) }
				format.xml  { render :xml => @nickname, :status => :created, :location => @nickname }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @nickname.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /admin_nicknames/1
	# PUT /admin_nicknames/1.xml
	def update
		@nickname = Nickname.find(params[:id])

		respond_to do |format|
			if @nickname.update_attributes(params[:nickname])
				flash[:notice] = 'Nickname was successfully updated.'
				format.html { redirect_to([:admin, @nickname]) }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @nickname.errors, :status => :unprocessable_entity }
			end
		end
	end

	# DELETE /admin_nicknames/1
	# DELETE /admin_nicknames/1.xml
	def destroy
		@nickname = Nickname.find(params[:id])
		@nickname.destroy

		respond_to do |format|
			format.html { redirect_to(admin_nicknames_url) }
			format.xml  { head :ok }
		end
	end
end

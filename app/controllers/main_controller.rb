class MainController < ApplicationController
  
  def all_days
    offset = 0
    total_per_page = 6
    @page = 1

    if params[:page]
      @page = params[:page].to_i
      offset = total_per_page * (@page - 1)
    end

  	@devotionals = Devotional.order("id DESC").limit(total_per_page).offset(offset)
    @total_pages = Devotional.count / total_per_page

    if @page > 0
      @previous_page_path = "?page=" + (@page - 1).to_s
    else
      if (@page + 1)*10 < Devotional.count
        @next_page_path = "?page=" + (@page + 1).to_s
      end
    end 

    if Devotional.count % total_per_page > 0
      @total_pages += 1
    end
  end

  def today
  	start_date = Date.new(2015, 5, 18)

  	if params[:id]
  		@devotional = Devotional.find(params[:id])
  	else
  		today = Date.today
  		day = (today - start_date).to_i - 1

  		@devotional = Devotional.find_by_day(day) rescue nil

  		if @devotional.nil?
  			@devotional = Devotional.where('day>?', day).order('id ASC').first rescue Devotional.last
  		end
  	end
  end

  def download_devotional
    @devotional = Devotional.find(params[:id])
    respond_to do |format|
      format.pdf do
        render pdf: "devocional_dia_#{@devotional.day}"
      end
    end
  end

end
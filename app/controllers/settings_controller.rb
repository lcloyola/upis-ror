class SettingsController < ApplicationController
	before_filter :only => [:edit, :update] { |c| c.allow_access! 14 }
	def edit
		@settings = Setting.transcript
	end

	def update
		# WAAAAALALALANG VALIDATION. Doomed.
		raw = params[:raw] == "true" ? true : false 
		elevenpt = params[:elevenpt] == "true" ? true : false

		Setting.transcript = {:headera => params[:headera],
													:headerb => params[:headerb],
													:raw => raw,
													:elevenpt => elevenpt,
													:height => params[:height].to_i,
													:syperpage => params[:syperpage].to_i,
													:copyfor => params[:copyfor],
													:prepared_by => params[:prepared_by]}
		redirect_to "edit"
	end
end

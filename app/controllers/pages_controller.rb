class PagesController < ApplicationController
	include PagesHelper
	skip_before_action :verify_authenticity_token
	before_action :authenticate_user!, :except => [:index, :search, :about, :result, :test]

	def index

	end

	def profile
		
	end

	def add_to_db
		username = current_user.username
		to_add = params[:name].to_s
		puts("Adicionando =>  " + to_add)
		user_exists = false
		for user in UserSetting.all
			if user.username == username
				for link in user.settings
					if link == to_add
						return
					end
				end
			end
			user_exists = true
		end
		if user_exists
			for user in UserSetting.all
				if user.username == username
					user.settings << to_add
					user.save
					return
				end
			end
		else
			new_entry = UserSetting.create(:settings => [to_add.to_s], :username => username)
			new_entry.save
		end
	end

	def remove_from_db
		username = current_user.username
		to_delete = params[:name].to_s
		puts("Removendo =>  " + to_delete)
		for user in UserSetting.all
			if user.username == username
				id = 0
				for link in user.settings
					if link == to_delete
						user.settings.delete_at(id)
						break
					end
					id = id+1
				end
				user.save
				return
			end
		end
	end

	def about
		@title = 'About us'
		@content = 'Projeto de Técnicas de Programação II'
	end

	def search
		
	end

	def add
		puts("Opa kk")
		puts(params[:link])
	end

	def result
		handle1 = params[:param1].to_s
		handle2 = params[:param2].to_s
		if handle1.empty? or handle2.to_s.empty?
			render html: "Please provide 2 valid Codeforces handles!"
			return
		end
		@info = build_result(handle1, handle2)
		if @info['handle1']['rating'] >= 2900
			@first_letter1 =  'legendary-user-first-letter'
		else
			@first_letter1 =  color(@info['handle1']['rating'])   
		end

		if @info['handle2']['rating'] >= 2900
			@first_letter2 =  'legendary-user-first-letter'
		else
			@first_letter2 =  color(@info['handle2']['rating'])   
		end
	end

	def test
		#### metodo para testar novas features, sera apagado futuramente! ####
		username = current_user.username

		for user in UserSetting.all
			#user.delete
		end
		#return

	end

end

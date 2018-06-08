module DatabaseHelper

	#user.info
	#contest.status


	def validate (url, type)
		require "net/http"
		puts(url, type)
		if (type == "user")
			url = URI.parse(url)
			req = Net::HTTP.new(url.host, url.port)
			req.use_ssl = true
			res = req.request_head(url.path)
			if res.code == "200"
				puts("deu bom")
			else
				puts("deu ruim")
			end
		end
	end

end
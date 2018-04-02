require 'rest-client'
require 'json'

class TesteController < ApplicationController
	def hello
  	
  	#aqui pega da API
  	url = 'http://codeforces.com/api/user.info?handles=PedroBortolli'
  	response = RestClient.get(url)

  	#pra printar o json todo com os keys e values
  	#render json: response

  	#parse o objeto JSON
  	parsed = JSON.parse(response)

  	#pega os values da key "result" e coloca em info
  	info = parsed['result'][0]

  	#pra printar a organizacao, por exemplo:
  	#render html: info['organization']

  	#pra printar o status (se deu ok ou nao)
  	#render html: parsed['status']

  	#pra printar o lastname:
  	#render html: info['lastName']

  	firstName = info['firstName']
  	lastName = info['lastName']
  	organization = info['organization']
  	rating = info['rating'].to_s
  	s = "Pequeno teste fazendo uso da API do codeforces: ....... " + firstName + " " + lastName + ", " + organization + " ....... current rating = " + rating

  	render html: s
  	
  end
end

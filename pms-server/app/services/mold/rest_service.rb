module Mold
  class RestService
    REST_HOST='http://192.168.5.86:9090/rest'
    TOKEN='3dcba17f596969a676bfdd90b5425c703f983acf7306760e1057c95afe9f17b1d'

    def update_cut_count(mold_nr, cut, total)
      begin
        puts "/set_cut/#{mold_nr}/#{cut}/#{total}".yellow
        init_client("/set_cut/#{mold_nr}/#{cut}/#{total}").get
      rescue => e
        puts e
      end
    end

    def init_client(api)
      RestClient::Resource.new("#{REST_HOST}#{api}",
                               :timeout => nil,
                               :open_timeout => nil,
                               headers: {'Authorization' => "Bearer #{TOKEN}"},
                               :content_type => 'application/json')
    end
  end
end
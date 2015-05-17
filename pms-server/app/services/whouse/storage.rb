module Whouse
  class Storage<BaseClass
    TOKEN='3dcba17f596969a676bfdd90b5425c703f983acf7306760e1057c95afe9f17b1d'
    REST_HOST='http://localhost:9000/'
    ENTER_STOCK_API='/api/v3/whouse/enter_stock'
    MOVE_STOCKS_API='/api/v3/whouse/moves'

    def enter_stock(params)
      res=init_client(ENTER_STOCK_API).post(params)
      if res.code==201
        msg=JSON.parse(res.body)
        if msg['result'].to_s=='1'
          return true
        end
      end
      false
    end

    def move_stocks(params)
      puts "#{params.to_json}".blue

      res=init_client(MOVE_STOCKS_API).post({moves:params.to_json})
      if res.code==201
        msg=JSON.parse(res.body)
        if msg['result'].to_s=='1'
          return true
        end
      end
      false
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
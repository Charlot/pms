module V1
  module Service
    class MachineServiceAPI<ServiceBase
      namespace :machine do
        guard_all!
        namespace :setting do
          post :ip do
            msg=Message.new
            if machine=Machine.find_by_nr(params[:machine])
              if params[:ip]=~Resolv::IPv4::Regex
                msg.result = machine.update(ip: params[:ip])
              else
                msg.content = "Machine IP #{params[:ip]} is not valid"
              end
            else
              msg.content="No Machine Nr: #{params[:machine]}"
            end
            msg
          end
        end
      end
    end
  end
end
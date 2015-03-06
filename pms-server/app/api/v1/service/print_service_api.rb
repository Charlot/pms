module V1
  module Service
    class PrintServiceAPI<ServiceBase
      namespace :printer do
        guard_all!

        get :data do
          printer=Printer::Client.new(params[:code],params[:id])
          printer.gen_data
        end
      end
    end
  end
end
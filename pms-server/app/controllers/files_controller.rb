class FilesController < ApplicationController
  def index
    puts params
    # send_file File.join($TEMPLATEPATH, params[:id]+'.'+params[:format])

  end

  def show
    send_file Base64.decode64(params[:id])
  end
end
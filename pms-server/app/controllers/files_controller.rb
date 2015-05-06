class FilesController < ApplicationController
  #before_filter :skip_authorization

  def index
    puts params
    # send_file File.join($TEMPLATEPATH, params[:id]+'.'+params[:format])

  end

  def show
    send_file Base64.urlsafe_decode64(params[:id])
  end
end
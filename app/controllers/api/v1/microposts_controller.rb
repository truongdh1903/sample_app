class Api::V1::MicropostsController < Api::V1::ApplicationController
  def index
    microposts = Micropost.all
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(
        microposts, each_serializer: MicropostSerializer
      )
    }
  end

  def show
    micropost = Micropost.find_by params[:id]
    if micropost.nil?
      render json: {message: "No record"}, status: :bad_request
    else
      render json: {
        data: ActiveModelSerializers::SerializableResource.new(
          micropost, each_serializer: MicropostSerializer
        )
      }
    end
  end
end

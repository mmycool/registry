require 'serializers/registrant_api/domain'

module Api
  module V1
    module Registrant
      class DomainsController < ::Api::V1::Registrant::BaseController
        def index
          limit = params[:limit] || 200
          offset = params[:offset] || 0

          if limit.to_i > 200 || limit.to_i < 1
            render(json: { errors: [{ limit: ['parameter is out of range'] }] },
                   status: :bad_request) && return
          end

          if offset.to_i.negative?
            render(json: { errors: [{ offset: ['parameter is out of range'] }] },
                   status: :bad_request) && return
          end

          @domains = associated_domains(current_registrant_user).limit(limit).offset(offset)

          serialized_domains = @domains.map do |item|
            serializer = Serializers::RegistrantApi::Domain.new(item)
            serializer.to_json
          end

          render json: serialized_domains
        end

        def show
          domain_pool = associated_domains(current_registrant_user)
          @domain = domain_pool.find_by(uuid: params[:uuid])

          if @domain
            serializer = Serializers::RegistrantApi::Domain.new(@domain)
            render json: serializer.to_json
          else
            render json: { errors: [{ base: ['Domain not found'] }] }, status: :not_found
          end
        end
      end
    end
  end
end

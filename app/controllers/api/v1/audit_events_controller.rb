module Api
  module V1
    class AuditEventsController < ApplicationController
      before_action :set_events, only: [ :show ]

      def create
        safe_params = event_params.to_h
        safe_params[:detail] ||= {}

        event = AuditEvent.create!(safe_params)
        render json: { message: "Evento registrado", id: event.id }, status: :created
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def show
        invoice_id = params[:id].to_i
        @events = AuditEvent.where("detail.invoice_id" => invoice_id).to_a
        render json: @events, status: :ok
      end

      private

      def event_params
        params.require(:audit_event).permit(:timestamp, :origin_service, :action, :state, detail: {})
      end

      def set_events
        invoice_id = params[:id].to_i
        @events = AuditEvent.where("detail.invoice_id" => invoice_id)
      end
    end
  end
end

module Api
  module V1
    class AuditEventsController < ApplicationController
      before_action :set_events, only: [ :show ]

      def create
        safe_params = event_params.to_h
        safe_params[:detail] ||= {}

        event = AuditEvent.create!(safe_params)
        render_success(data: event, status: :created)
      rescue ActiveRecord::RecordInvalid => e
        render_error(message: "Error al registrar evento: #{e.message}")
      rescue => e
        Rails.logger.error("[Audit] Error general: #{e.message}")
        render_error(message: "Error interno al registrar evento", status: :internal_server_error)
      end

      def show
        invoice_id = params[:id].to_i
        @events = AuditEvent.where("detail.invoice_id" => invoice_id).to_a
        render_success(data: @events)
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

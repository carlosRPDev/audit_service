class AuditEvent
  include Mongoid::Document
  include Mongoid::Timestamps

  field :timestamp, type: Time
  field :origin_service, type: String
  field :action, type: String
  field :state, type: String

  field :detail, type: Hash, default: {}

  validates :timestamp, :origin_service, :action, :state, presence: true

  index({ "detail.invoice_id": 1 })
  index({ origin_service: 1 })
  index({ created_at: 1 })

  scope :by_invoice, ->(invoice_id) { where("detail.invoice_id" => invoice_id) }
end

class DomainTransfer < ActiveRecord::Base
  belongs_to :domain

  belongs_to :transfer_from, class_name: 'Registrar'
  belongs_to :transfer_to, class_name: 'Registrar'

  PENDING = 'pending'
  CLIENT_APPROVED = 'clientApproved'
  CLIENT_CANCELLED = 'clientCancelled'
  CLIENT_REJECTED = 'clientRejected'
  SERVER_APPROVED = 'serverApproved'
  SERVER_CANCELLED = 'serverCancelled'
end

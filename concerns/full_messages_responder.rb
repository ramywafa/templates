class FullMessagesResponder < ActionController::Responder
  def resource_errors
    errors = resource.errors
    {
      errors: errors,
      error_messages: errors.full_messages
    }
  end
end

class UserChannel < ApplicationCable::Channel

  def subscribed
    stream_for current_user

    UserChannel.broadcast_to current_user, {type: "UserConnected", object: UserSerializer.new(current_user).as_json}
  end

  def request_assistance(data)
    ar = AssistanceRequest.new(:requestor => current_user, reason: data["reason"])
    ar.save

    ActionCable.server.broadcast "assistance-#{current_user.cohort.location.name}", {
      type: "AssistanceRequest",
      object: AssistanceRequestSerializer.new(ar, root: false).as_json
    }

    UserChannel.broadcast_to current_user, {type: "AssistanceRequested", object: current_user.position_in_queue}
  end

  def cancel_assistance
    ar = current_user.assistance_requests.where(type: nil).open_or_in_progress_requests.newest_requests_first.first
    if ar && ar.cancel
      ActionCable.server.broadcast "assistance-#{current_user.cohort.location.name}", {
        type: "CancelAssistanceRequest",
        object: AssistanceRequestSerializer.new(ar, root: false).as_json
      }

      UserChannel.broadcast_to current_user, {type: "AssistanceEnded"}

      teacher_available(ar.assistance.assistor) if ar.assistance
      update_students_in_queue(ar.requestor.cohort.location.name)
    end
  end

end
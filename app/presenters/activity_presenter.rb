class ActivityPresenter < BasePresenter
  presents :activity

  delegate :name, to: :activity

  def render_sidenav
    if activity.prep?
      content_for :prep_nav do
        render('shared/menus/prep_side_menu')
      end
    else
      unless current_user.prepping? || current_user.prospect? || activity.prep?
        content_for :side_nav do
          render('layouts/side_nav')
        end
      end
    end
  end

  def previous_button
    if activity.previous
      link_to '&laquo; Previous'.html_safe, get_activity_path(activity.previous), class: 'btn btn-previous'
    end
  end

  def next_button
    if activity.next
      link_to 'Next &raquo;'.html_safe, get_activity_path(activity.next), class: 'btn btn-next'
    end
  end

  def submissions_text
    activity.allow_submissions? ? "Submissions" : "Completions"
  end

  def submission_form
    render "activity_submission_form"
  end

  def edit_button
    if activity.prep?
      path = edit_prep_activity_path(activity.section, activity)
    else
      path = edit_day_activity_path(activity.day, activity)
    end

    link_to 'Edit', path, class: 'btn btn-edit'
  end

  def display_outcomes
    render "outcomes", activity: activity if activity.outcomes.present? || admin?
  end

end
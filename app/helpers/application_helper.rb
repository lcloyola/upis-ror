module ApplicationHelper
  def pdf_image_tag(image, options = {})
    options[:src] = File.expand_path(Rails.root) + '/public' + image
    tag(:img, options)
  end
  def is_faculty?
    return true if current_user.role == Role::Faculty
    return false
  end
  def is_staff?
    return true if current_user.role == Role::RecordStaff
    return false
  end
  def is_moderator?
    return true if current_user.role == Role::Moderator
    return false
  end
  def is_admin?
    return true if current_user.role == Role::Admin
    return false
  end
  def allow_access(x)
    return true if (current_user.role == 0) and x >= 8
    return true if (current_user.role == 3) and x.odd?
    return true if (current_user.role == 1) and ((4..7).include?(x) or (11..14).include?(x))
    return true if (current_user.role == 2) and ([2,3,6,7,10,11,13,14].include?(x))
  end
end


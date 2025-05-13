module ApplicationHelper
  def store_name
    "Quán Ăn Ngon"
  end

  def active_link_to(name, path, html = {})
    active_css = html[:active_class] || "active"
    active_class = request.fullpath == path ? active_css : ""
    Rails.logger.info "Current page: #{path}"
    html[:class] = [ html[:class], active_class ].compact.join(" ")
    Rails.logger.info "Active class: #{html[:class]}"
    link_to(name, path, html)
  end

  def status_string(status)
    case status
    when "pending"
      "Đang chờ xử lý"
    when "paid"
      "Đã thanh toán"
    when "shipped"
      "Đang giao hàng"
    when "completed"
      "Hoàn tất"
    when "canceled"
      "Đã hủy"
    else
      status.humanize
    end
  end
end

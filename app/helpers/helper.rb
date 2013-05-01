# coding: utf-8

Rubia::App.helpers do
  def exist_or_404(item)
    return error 404 if item.blank?

    true
  end
end

module ProductsHelper

  def build_filter_link(filtering, name, count, new_param)
    link_to "#{t(name, default: name.titleize)} (#{count})", products_path + '?' + filtering.params.merge(new_param).to_param
  end

end

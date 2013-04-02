class Filtering

  def initialize(params)
    @category_id = params[:category_id]
    @sub_category_id = params[:sub_category_id]
    @brand_id = params[:brand_id]
    @min_price = params[:min_price]
    @max_price = params[:max_price]
    @property_list = params[:property_list]
    @page = params[:page]
    @product_property_list = params[:product_properties]
    @params = params
    build_conditions
  end

  def products
    return @products if @products.present?
    @products = Product.
        page(@page).per(20).
        joins( { sub_category: :category }, :brand, :product_properties ).
        includes(:image_attachments).
        where(@conditions.join(' AND ')).
        group('products.id')
  end

  def sub_category_counts
    count_sql = <<-SQL
      SELECT sub_categories.name `name`, sub_categories.id id
      FROM products, sub_categories, categories, brands, product_properties
      WHERE products.sub_category_id = sub_categories.id
        AND sub_categories.category_id = categories.id
        AND products.brand_id = brands.id
        AND product_properties.product_id = products.id
        #{@condition_query}
      GROUP BY sub_categories.id, products.id
      ORDER BY sub_categories.name
    SQL
    results = {}
    ActiveRecord::Base.connection.select_all(count_sql).each do |record|
      id = record['id']
      if results[id].present?
        results[id]['count'] += 1
      else
        results[id] = {}
        results[id]['count'] = 1
        results[id]['name'] = record['name']
      end
    end
    results
  end

  def brand_counts
    count_sql = <<-SQL
      SELECT brands.name `name`, brands.id id
      FROM products, sub_categories, categories, brands, product_properties
      WHERE products.sub_category_id = sub_categories.id
        AND sub_categories.category_id = categories.id
        AND products.brand_id = brands.id
        AND product_properties.product_id = products.id
        #{@condition_query}
      GROUP BY brands.id, products.id
      ORDER BY brands.name
    SQL

    results = {}
    ActiveRecord::Base.connection.select_all(count_sql).each do |record|
      id = record['id']
      if results[id].present?
        results[id]['count'] += 1
      else
        results[id] = {}
        results[id]['count'] = 1
        results[id]['name'] = record['name']
      end
    end
    results
  end

  def property_counts
    # for performance purposes disable these count if none of the main filters selected
    return {} if !@category_id && !@sub_category_id && !@brand_id

    count_sql = <<-SQL
      SELECT product_properties.name `property_name`, product_properties.value property_value
      FROM products, sub_categories, categories, brands, product_properties
      WHERE products.sub_category_id = sub_categories.id
        AND sub_categories.category_id = categories.id
        AND products.brand_id = brands.id
        AND product_properties.product_id = products.id
        AND product_properties.is_primary = '1'
        #{@condition_query}
    SQL

    results = {}
    ActiveRecord::Base.connection.select_all(count_sql).each do |record|
      name = record['property_name']
      value = record['property_value']

      results[name] ||= {}
      results[name][value] ||= 0
      results[name][value] += 1
    end
    results
  end

  def params
    @params.delete_if { |k, _| %w(action controller page).include? k }
  end

  def current_url
    params.to_param
  end

  private

  def build_conditions
    @conditions = []
    @conditions << "categories.id = '#{@category_id}'" if @category_id.present?
    @conditions << "sub_categories.id = '#{@sub_category_id}'" if @sub_category_id.present?
    @conditions << "brands.id = '#{@brand_id}'" if @brand_id.present?
    @conditions << "products.price > '#{@min_price}'" if @min_price
    @conditions << "products.price < '#{@max_price}'" if @max_price
    @conditions << "product_properties.value IN ('#{@product_property_list.join("', '")}')" if @product_property_list.present?
    @condition_query = @conditions.blank? ? '' : "AND #{@conditions.join(' AND ')}"
    @condition_query = ActiveRecord::Base.send(:sanitize_sql_array, @condition_query)
  end
end
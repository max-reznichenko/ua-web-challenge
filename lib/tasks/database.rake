namespace :database do

  desc 'populates database with fake data'
  task fill: :environment do
    Brand.populate(12..33) do |b|
      b.name = Populator.words(2..4)
    end

    10.times do
      User.create(
        email: "#{Populator.words(1)}@somewhere.com",
        password: '12345678',
        password_confirmation: '12345678'
      )
    end
    brand_ids = Brand.pluck(:id)
    user_ids = User.pluck(:id)

    Category.populate(3) do |c|
      c.name = Populator.words(1..2)

      SubCategory.populate(3) do |s|
        s.name = Populator.words(1..3)
        s.category_id = c.id

        primary_attributes = Populator.words(8).split

        Product.populate(10..12) do |p|
          p.name = Populator.words(3..10).titleize
          p.description = Populator.sentences(4..6).titleize
          p.price = 15..500
          p.discount_value = 1 / (1..100).to_a.sample
          p.stock_count = 0..1220
          p.sub_category_id = s.id
          p.brand_id = brand_ids.sample
          p.is_top_seller = [true, false]

          2.times do |t|
            ImageAttachment.create(
              product_id: p.id,
              attachment: File.open(File.join(Rails.root, "product_image_#{t+1}.png"), 'r')
            )
          end

          # build primary properties
          ProductProperty.populate(5) do |pp|
            pp.product_id = p.id
            pp.name = primary_attributes[ pp.id % 8 ]
            pp.value = Populator.words(1..3).underscore
            pp.is_primary = true
          end

          # build secondary properties
          ProductProperty.populate(4..5) do |pp|
            pp.product_id = p.id
            pp.name = Populator.words(1..3).titleize
            pp.value = Populator.words(5..12).titleize
            pp.is_primary = false
          end

          Review.populate(3..7) do |review|
            review.product_id = p.id
            review.user_id = user_ids.sample
            review.positive_description = Populator.sentences(2..5)
            review.negative_description = Populator.sentences(1..3)
            review.custom_description = Populator.sentences(2..4)
          end

          Rating.populate(3..7) do |rating|
            rating.product_id = p.id
            rating.user_id = user_ids.sample
            rating.value = 1..5
          end
        end
      end
    end
  end

  desc 'reset db'
  task reset: %w(db:drop db:create db:migrate)
end
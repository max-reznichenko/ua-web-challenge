class ProductsController < ApplicationController

  def index
    @filtering = Filtering.new(params)
  end

  def show
    @product = Product.includes(sub_category: [:category]).find_by_id(params[:id])
  end

  def search
    @products = Product.search(params[:query], page: params[:page])
  end

end
# frozen_string_literal: true

class CategoryComponent < ViewComponent::Base
  attr_reader :category
  def initialize(category: nil)
    @category = category
  end

  def title
    category ? category.name : t(".all")
  end

  def link
    category ? products_path(category_id: category.id) : products_path
  end

  def active?
    return true if !category && !params[:category_id]
    category&.id == params[:category_id].to_i
  end

  def classes
    base = "category whitespace-nowrap px-4 py-2 rounded-full text-sm font-semibold border transition-colors"
    state = active? ? "border-brand-gold text-brand-gold bg-brand-gold/10" : "border-brand-border text-brand-text-secondary bg-brand-surface hover:border-brand-gold hover:text-brand-gold"
    "#{base} #{state}"
  end
end

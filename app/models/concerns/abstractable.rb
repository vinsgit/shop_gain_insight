# frozen_string_literal: true

module Abstractable
  extend ActiveSupport::Concern

  class_methods do
    def abstract_methods(*names)
      names.each do |name|
        define_method(name) do
          raise NotImplementedError.new("Subclass must implement method #{name}")
        end
      end
    end
  end
end

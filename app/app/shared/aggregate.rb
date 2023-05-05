# frozen_string_literal: true

module Aggregate

  def self.included(base)
    base.class_eval do
      attr_reader :uuid

      def self.on(event_class, &block)
        define_method "apply_#{event_class::NAME}", &block
      end
    end
  end

  def version
    @version || 0
  end

  def version=(new_version)
    @version = new_version.to_i
  end

  def changes
    @changes ||= []
  end

  def clear_changes
    @changes = []

    self
  end

  def apply(event)
    self.send("apply_#{event.class::NAME}", event)

    self
  end

  private

  def enqueue(event)
    apply(event)
    changes.append(event)

    self
  end
end

require_relative './field'

module Avocado
  module Fields
    class BelongsToField < Field
      def initialize(name, **args)
        super(name, args)

        @component = 'belongs-to-field'
      end

      def fetch_for_resource(model, view)
        fields = super(model)

        return fields if model_or_class(model) == 'class'

        fields[:is_relation] = true
        target_resource = App.get_resources.find { |r| r.class == "Avocado::Resources::#{name}".safe_constantize }
        relation_model = model.public_send(target_resource.name.underscore)
        fields[:value] = relation_model[target_resource.title] if relation_model.present?

        fields
      end
    end
  end
end
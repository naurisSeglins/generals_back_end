# frozen_string_literal: true

# Configure ActiveModel::Serializer to use JsonApi adapter
ActiveModelSerializers.config.adapter = :json_api

# By default, use the registered application/vnd.api+json MIME type
# See: http://jsonapi.org/format/#content-negotiation-servers
ActiveModelSerializers.config.key_transform = :unaltered

# Disable pluralization of type names (keeps them singular like "unit" instead of "units")
ActiveModelSerializers.config.jsonapi_resource_type = :singular

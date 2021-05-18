Rails.application.reloader.to_prepare do
  require "active_storage/cloud_variant/preview"
  require "active_storage/cloud_variant/variant"

  # Overwrite original methods to replace Rails' variant implementation with our own

  ActiveStorage::Blob::Representable.class_eval do
    def preview(transformations)
      if video?
        ActiveStorage::CloudVariant::Preview.new(self, transformations)
      else
        super
      end
    end

    def variable?
      # # Original method implementation documented here as of ActiveStorage 6.1:
      # ActiveStorage.variable_content_types.include?(content_type)

      content_type =~ /^(image|video)\//
    end

    private

    def variant_class
      # # Original method implementation documented here as of ActiveStorage 6.1:
      # ActiveStorage.track_variants ? ActiveStorage::VariantWithRecord : ActiveStorage::Variant

      ActiveStorage::CloudVariant::Variant
    end
  end
end


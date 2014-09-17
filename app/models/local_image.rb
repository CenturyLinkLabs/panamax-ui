class LocalImage < BaseImage
  PANAMAX_IMAGE_NAMES = ['centurylink/panamax-ui', 'centurylink/panamax-api']

  def panamax_image?
    PANAMAX_IMAGE_NAMES.include?(name)
  end

  def local?
    true
  end

  def name
    tags.first
  end

  def self.batch_destroy(image_ids)
    count = 0
    failed = image_ids.each_with_object(Set.new) do |id, fail_list|
      begin
        image = LocalImage.find_by_id(id)
        if image.destroy
          count += 1
        else
          fail_list << "#{image.name} failed to be removed"
        end
      rescue => ex
        fail_list << ex.message
      end
    end
    {
      count: count,
      failed: failed
    }
  end
end

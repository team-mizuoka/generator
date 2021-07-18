require "google/cloud/storage"

class CloudStorageUploader
  def initialize
    @storage = Google::Cloud::Storage.new(
      project_id: ENV["GOOGLE_CLOUD_PROJECT"],
    )
    @bucket_name = ENV["CLOUD_STORAGE_BUCKET"]
  end

  def upload(input_file, output_file)
    bucket = @storage.bucket(@bucket_name)
    return bucket.create_file(input_file, output_file)
  end
end

class TuftsDatastream < ActiveFedora::OmDatastream

  def datastream_content
    begin
      options = {:pid => pid, :dsid => dsid}
      options[:asOfDateTime] = asOfDateTime if asOfDateTime

      @content ||= File.open(convert_url_to_local_path(self.dsLocation)).read

        #repository.datastream_dissemination options
    rescue RestClient::ResourceNotFound
    end

    content = @content.read and @content.rewind if @content.kind_of? IO
    content ||= @content
  end

  private

  def convert_url_to_local_path(url)
    Settings.object_store_root + url.gsub(Settings.trim_bucket_url, "")
  end


end

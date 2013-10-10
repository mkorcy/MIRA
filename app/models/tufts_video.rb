class TuftsVideo < TuftsBase
  has_metadata "ARCHIVAL_XML", type: TuftsAudioTextMeta
  #MK 2011-04-13 - Are we really going to need to access FILE-META from FILE-META.  I'm guessing
  # not.

 # has_metadata :name => "Archival.xml", :type => TuftsRcrMeta

   # Given a datastream name, return the local path where the file can be found.
  # @example
  #   obj.file_path('ARCHIVAL_XML', 'tif')
  #   # => /local_object_store/data01/tufts/central/dca/MS054/archival_xml/MS054.003.DO.02108.archival.tif
  def file_path(name, extension = nil)
    case name
    when 'ARCHIVAL_WAV', 'ARCHIVAL_XML'
      if self.datastreams[name].dsLocation
        self.datastreams[name].dsLocation.sub(Settings.trim_bucket_url + '/' + object_store_path, "")
      else
        raise ArgumentError, "Extension required for #{name}" unless extension
        File.join(directory_for(name), "#{pid_without_namespace}.archival.#{extension}")
      end
    else
      File.join(directory_for(name), "#{pid_without_namespace}.#{name.downcase.sub('_', '.')}")
    end
  end

  def to_solr(solr_doc=Hash.new, opts={})
    super
    index_sort_fields solr_doc
    return solr_doc
  end

end

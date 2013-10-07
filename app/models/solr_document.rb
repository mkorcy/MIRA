# -*- encoding : utf-8 -*-
class SolrDocument 

  include Blacklight::Solr::Document

  # self.unique_key = 'id'

  def published?
    self[Solrizer.solr_name("edited_at", :stored_sortable, type: :date)] == 
      self[Solrizer.solr_name("published_at", :stored_sortable, type: :date)]
  end

  def preview_fedora_path
    if published?
      fedora_url = Settings.preview_fedora_prod_url
    else
      fedora_url = Settings.preview_fedora_stage_url
    end

    fedora_url + "/objects/#{id}" 
  end

  def preview_dl_path
    if published?
      dl_url = Settings.preview_dl_prod_url
    else
      dl_url = Settings.preview_dl_stage_url
    end
    if self['displays_ssi'].blank? || self['displays_ssi'] == 'dl'
      dl_url + "/catalog/#{id}" 
    else
      return nil
    end
  end
end

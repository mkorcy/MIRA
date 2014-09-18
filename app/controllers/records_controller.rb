class RecordsController < ApplicationController
  include RecordsControllerBehavior

  before_filter :load_object, only: [:review, :publish, :destroy, :cancel]
  authorize_resource only: [:review]

  # We don't even want them to see the 'choose_type' page if they can't create
  prepend_before_filter :ensure_can_create, only: :new

  def new
    unless has_valid_type?
      render 'choose_type'
      return
    end

    args = params[:pid].present? ? {pid: params[:pid]} : {}

    if !args[:pid] || (args[:pid] && /:/.match(args[:pid]))
      if ActiveFedora::Base.exists?(args[:pid])
        flash[:alert] = "A record with the pid \"#{args[:pid]}\" already exists."
        redirect_to hydra_editor.edit_record_path(args[:pid])
      else
        @record = params[:type].constantize.new(args)
        @record.save(validate: false)
        redirect_to next_page
      end
    else
      flash[:error] = "You have specified an invalid pid. A valid pid must contain a colon (i.e. tufts:1231)"
      render 'choose_type'
    end
  end

  def review
    if @record.respond_to?(:reviewed)
      @record.reviewed
      if @record.save
        flash[:notice] = "\"#{@record.title}\" has been marked as reviewed."
      else
        flash[:error] = "Unable to mark \"#{@record.title}\" as reviewed."
      end

    else
      flash[:error] = "Unable to mark \"#{@record.title}\" as reviewed."
    end
    redirect_to catalog_path(@record)
  end

  def edit
     @record = ActiveFedora::Base.find(params[:id], cast: true)
     #if this object has the old style DCA-ADMIN datasteram, indicated by the old XML schema
     if @record.datastreams['DCA-ADMIN'].ng_xml.to_s[/<dca_admin:admin/]
       #create a new dca-admin stream
       admin_stream = DcaAdmin.new
       #check if this is a perseus object, an aah object or otherwise assume its a dl object
       if @record.pid[/perseus/]
         admin_stream.displays = 'perseus'
       elsif @record.pid[/aah/]
         admin_stream.displays = 'aah'
       else
         admin_stream.displays = 'dl'
       end

       #set the steward to dca since we know that to be true for all objects that predate the hydra admin head
       admin_stream.steward = 'dca'
       @record.datastreams['DCA-ADMIN'].ng_xml = admin_stream.ng_xml
       @record.save

     end
     authorize! :edit, @record
     initialize_fields
  end

  def publish
    authorize! :publish, @record
    @record.publish!(current_user.id)
    redirect_to catalog_path(@record), notice: "\"#{@record.title}\" has been pushed to production"
  end

  def destroy
    authorize! :destroy, @record
    @record.state= "D"
    @record.save(validate: false)
    # only push to production if it's already on production.
    @record.audit(current_user, 'deleted')
    @record.push_to_production! if @record.published_at
    if @record.is_a?(TuftsTemplate)
      flash[:notice] = "\"#{@record.template_name}\" has been purged"
      redirect_to templates_path
    else
      flash[:notice] = "\"#{@record.title}\" has been purged"
      redirect_to root_path
    end
  end

  def cancel
    if @record.DCA_META.versions.empty?
      authorize! :destroy, @record
      @record.destroy
    end
    if @record.is_a?(TuftsTemplate)
      redirect_to templates_path
    else
      redirect_to root_path
    end
  end

  def redirect_after_update
    if @record.is_a?(TuftsTemplate)
      templates_path
    else
      main_app.catalog_path @record
    end
  end

  def set_attributes
    resource.working_user = current_user
    # set rightsMetadata access controls
    resource.apply_depositor_metadata(current_user)

    # pull out because it's not a real attribute (it's derived, but still updatable)
    resource.stored_collection_id = raw_attributes.delete(:stored_collection_id).try(&:first)

    resource.datastreams= raw_attributes[:datastreams] if raw_attributes[:datastreams]
    resource.relationship_attributes = raw_attributes['relationship_attributes'] if raw_attributes['relationship_attributes']
    super
  end

  private

  def ensure_can_create
    authorize! :create, ActiveFedora::Base
  end

  def load_object
    @record = ActiveFedora::Base.find(params[:id], cast: true)
  end

  def next_page
    if @record.is_a?(TuftsTemplate)
      hydra_editor.edit_record_path(@record)
    else
      record_attachments_path(@record)
    end
  end

  # Override method from hydra-editor to include rels-ext fields
  # def set_attributes
  #   puts "params #{params}"
  #   rels_ext_fields = { relationship_attributes: params[ActiveModel::Naming.singular(resource)]['relationship_attributes'] }
  #   puts "Rels #{rels_ext_fields}"
  #   resource.attributes = collect_form_attributes.merge(rels_ext_fields)
  # end

end

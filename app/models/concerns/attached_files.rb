module AttachedFiles
  extend ActiveSupport::Concern

  included do
    class_attribute :original_file_datastream
  end

  def create_derivatives
  end

  def store_archival_file(file)
    dir = File.join(local_path_root, directory_for(original_file_datastream))
    FileUtils.mkdir_p(dir) unless Dir.exists?(dir)
    File.open(local_path_for(original_file_datastream), 'wb') do |f| 
      f.write file.read 
    end

    datastreams[original_file_datastream].dsLocation = remote_url_for(original_file_datastream)
    create_derivatives
  end

  def remote_url_for(name)
    File.join(remote_root, file_path(name))
  end

  def local_path_for(name)
    File.join(local_path_root, file_path(name))
  end


  private

  def collection_id
    pid.sub(/.+:([^.]+).*/, '\1')
  end

  def pid_without_namespace
    pid.sub(/.+:(.+)$/, '\1')
  end

  def remote_root
    File.join(Settings.trim_bucket_url, Settings.object_store_path)
  end


  def local_path_root
    File.join(Settings.object_store_root, Settings.object_store_path)
  end

  def file_path(name)
    File.join(directory_for(name), "#{pid_without_namespace}.#{name.downcase}")
  end

  def directory_for(name)
    File.join(collection_id, name.downcase.gsub('.', '_'))
  end


  module ClassMethods

    # @note this overrides the has_file_datastream method from ActiveFedora::Base
    #   Adding the :original option.
    # @overload has_file_datastream(name, args)
    #   Declares a file datastream exists for objects of this type
    #   @param [String] name 
    #   @param [Hash] args 
    #     @option args :type (ActiveFedora::Datastream) The class the datastream should have
    #     @option args :label ("File Datastream") The default value to put in the dsLabel field
    #     @option args :control_group ("M") The type of controlGroup to store the datastream as. Defaults to M
    #     @option args :original [Boolean] (false) Declare whether or not this datastream contain the preservation master
    #     @option args [Boolean] :autocreate Always create this datastream on new objects
    #     @option args [Boolean] :versionable Should versioned datastreams be stored
    # @overload has_file_datastream(args)
    #   Declares a file datastream exists for objects of this type
    #   @param [Hash] args 
    #     @option args :name ("content") The dsid of the datastream
    #     @option args :type (ActiveFedora::Datastream) The class the datastream should have
    #     @option args :label ("File Datastream") The default value to put in the dsLabel field
    #     @option args :control_group ("M") The type of controlGroup to store the datastream as. Defaults to M
    #     @option args :original [Boolean] (false) Declare whether or not this datastream contain the preservation master
    #     @option args [Boolean] :autocreate Always create this datastream on new objects
    #     @option args [Boolean] :versionable Should versioned datastreams be stored
    def has_file_datastream(*args)
      super
      if args.first.is_a? String 
        name = args.first
        args = args[1] || {}
        args[:name] = name
      else
        args = args.first || {}
      end

      self.original_file_datastream = args.fetch(:name, 'content') if args[:original]
    end

  end



end

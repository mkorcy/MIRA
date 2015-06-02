class Batch::ExportsController < BatchesController
  before_filter :build_batch, only: :create
  load_resource only: [:new, :show, :edit], instance_name: :batch, class: 'BatchExport'
  before_filter :load_batch, only: :update
  authorize_resource instance_name: :batch, class: 'BatchExport', except: :new

private

  def build_batch
    @batch = BatchExport.new(pids: params[:pids])
  end

  def load_batch
    @batch = BatchExport.lock.find(params.require(:id))
  end

  def run_batch
    BatchExportRunnerService.new(@batch, params[:datastream_ids]).run
  end
end
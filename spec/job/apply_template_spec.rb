require 'spec_helper'

describe Job::ApplyTemplate do

  it 'uses the "templates" queue' do
    Job::ApplyTemplate.queue.should == :templates
  end

  describe '::create' do
    let(:opts) { { record_id: '1',
                   user_id: '1',
                   attributes: {},
                   batch_id: '1' } }

    it 'requires the user id' do
      opts.delete(:user_id)
      expect{Job::ApplyTemplate.create(opts)}.to raise_exception(ArgumentError, /user_id/)
    end

    it 'requires the record id' do
      opts.delete(:record_id)
      expect{Job::ApplyTemplate.create(opts)}.to raise_exception(ArgumentError, /record_id/)
    end

    it 'requires the attributes for update' do
      opts.delete(:attributes)
      expect{Job::ApplyTemplate.create(opts)}.to raise_exception(ArgumentError, /attributes/)
    end

    it 'requires the batch id' do
      opts.delete(:batch_id)
      expect{Job::ApplyTemplate.create(opts)}.to raise_exception(ArgumentError, /batch_id/)
    end
  end


  describe '#perform' do
    it 'raises an error if it fails to find the object' do
      obj_id = 'tufts:1'
      TuftsPdf.find(obj_id).destroy if TuftsPdf.exists?(obj_id)

      job = Job::ApplyTemplate.new('uuid', 'user_id' => 1, 'record_id' => obj_id, 'attributes' => {})
      expect{job.perform}.to raise_error(ActiveFedora::ObjectNotFoundError)
    end

    it 'updates the record' do
      object = TuftsPdf.new(title: 'old title', toc: 'old toc', displays: ['dl'])
      object.save!
      job = Job::ApplyTemplate.new('uuid', 'user_id' => 1, 'record_id' => object.id, 'attributes' => {toc: 'new toc'})
      job.perform
      object.reload
      object.toc.should == ['old toc', 'new toc']
    end

    it "can be killed" do
      object = TuftsPdf.new(title: 'old title', toc: 'old toc', displays: ['dl'])
      object.save!
      job = Job::ApplyTemplate.new('uuid', 'user_id' => 1, 'record_id' => object.id, 'attributes' => {toc: 'new toc'})
      allow(job).to receive(:tick).and_raise(Resque::Plugins::Status::Killed)
      expect{job.perform}.to raise_exception(Resque::Plugins::Status::Killed)
      object.reload
      expect(object.toc).to eq ['old toc']
    end

    it 'runs the job as a batch item' do
      pdf = FactoryGirl.create(:tufts_pdf)
      batch_id = '10'
      job = Job::ApplyTemplate.new('uuid', 'record_id' => pdf.id, 'user_id' => '1', 'batch_id' => batch_id, 'attributes' => {title: 'new title 123'})

      job.perform
      pdf.reload
      expect(pdf.title).to eq 'new title 123'
      expect(pdf.batch_id).to eq [batch_id]

      pdf.delete
    end
  end
end

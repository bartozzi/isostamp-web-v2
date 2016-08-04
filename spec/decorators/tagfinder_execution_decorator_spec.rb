require 'spec_helper'

describe TagfinderExecutionDecorator do
  describe 'status' do
    before { Document.any_instance.stub(:set_upload_attributes).and_return(true) }

    it 'is decorated with the expected decorator' do
      @te = build(:tagfinder_execution).decorate
      @te.should be_decorated_with described_class
    end

    it 'is "Still running..." when success is not yet defined' do
      @te = build(:tagfinder_execution).decorate
      expect(@te.status).to eq('<div class="label label-info">Still running...</div>')
    end

    it 'is "Success!" when success is true' do
      @te = create(:tagfinder_execution, success: true).decorate
      expect(@te.status).to eq('<div class="label label-success">Success!</div>')
    end

    it 'is "Failure" when success is false' do
      @te = create(:tagfinder_execution, success: false).decorate
      expect(@te.status).to eq('<div class="label label-danger">Failure</div>')
    end
  end
end

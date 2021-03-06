require 'spec_helper'

describe TuftsImage do

  describe "with access rights" do
    before do
      @image = TuftsImage.new(title: 'test image', displays: ['dl'])
      @image.read_groups = ['public']
      @image.save!
    end

    after do
      @image.destroy
    end

    let (:ability) {  Ability.new(nil) }

    it "should be visible to a not-signed-in user" do
      ability.can?(:read, @image.pid).should be_truthy
    end
  end
end

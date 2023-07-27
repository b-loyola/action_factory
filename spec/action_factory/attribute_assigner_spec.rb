require "spec_helper"

RSpec.describe ActionFactory::AttributeAssigner do
  let(:instance) { double }

  subject(:assigner) { described_class.new(instance) }

  describe "#assign" do
    let(:attributes) { { name: "John" } }

    it "assigns the attributes to the instance" do
      expect(instance).to receive(:name=).with("John")
      assigner.assign(attributes)
    end
  end
end

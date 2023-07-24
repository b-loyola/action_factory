require "spec_helper"

RSpec.describe ActionFactory::FactoryFinder do
  describe ".factory_class_for" do
    let(:factory_class) { Class.new(ActionFactory::Base) }

    before do
      stub_const("UserFactory", factory_class)
    end

    it "returns the factory class for the given name" do
      expect(described_class.factory_class_for(:user)).to eq(factory_class)
    end
  end

  describe "#factory_class" do
    let(:factory_class) { Class.new(ActionFactory::Base) }
    let(:factory_name) { :user }

    before do
      stub_const("UserFactory", factory_class)
    end

    subject(:factory_finder) { described_class.new(factory_name) }

    it "returns the factory class for the given name" do
      expect(factory_finder.factory_class).to eq(factory_class)
    end

    context "when the factory class is not found" do
      let(:factory_name) { :foo }

      it "raises an error" do
        expect { factory_finder.factory_class }.to raise_error(ActionFactory::FactoryFinder::FactoryNotFound)
      end
    end
  end
end

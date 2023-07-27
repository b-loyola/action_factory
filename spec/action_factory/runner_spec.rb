require "spec_helper"

RSpec.describe ActionFactory::Runner do
  describe "#run" do
    let(:factory_class) { Class.new(ActionFactory::Base) }
    let(:factory_name) { :user }
    let(:attributes) { { name: "John" } }
    let(:traits) { [:admin] }
    let(:factory) { instance_double(ActionFactory::Base) }
    let(:instance) { double }

    before do
      stub_const("UserFactory", factory_class)
      allow(ActionFactory::FactoryFinder).to receive(:factory_class_for).with(factory_name).and_return(factory_class)
      allow(factory_class).to receive(:new).with(*traits, **attributes).and_return(factory)
    end

    subject(:runner) { described_class.new(factory_name, *traits, **attributes) }

    it "runs the factory" do
      allow(factory).to receive(:run).with(nil).and_return(instance)
      expect(runner.run).to eq(instance)
    end

    context "when a strategy is given" do
      subject(:runner) { described_class.new(factory_name, *traits, strategy: strategy, **attributes) }

      let(:strategy) { :create }

      it "runs the factory with the given strategy" do
        allow(factory).to receive(:run).with(strategy).and_return(instance)
        expect(runner.run(strategy)).to eq(instance)
      end
    end
  end
end

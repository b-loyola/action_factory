require "spec_helper"

RSpec.describe ActionFactory do
  it "has a version number" do
    expect(ActionFactory::VERSION).to eq "0.1.1"
  end

  describe ".configuration" do
    subject { described_class.configuration }

    it { is_expected.to be_a(ActionFactory::Configuration) }
  end

  describe ".configure" do
    subject(:configure) { described_class.configure { |config| config.persist_method = :save } }

    it "configures the gem" do
      expect { configure }.to change { described_class.configuration.persist_method }.from(:save!).to(:save)
    end
  end

  describe ActionFactory::Configuration do
    subject(:configuration) { described_class.new }

    describe "#persist_method" do
      subject { configuration.persist_method }

      it { is_expected.to eq :save! }
    end

    describe "#initialize_method" do
      subject { configuration.initialize_method }

      it { is_expected.to eq :new }
    end
  end
end

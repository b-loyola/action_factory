require "spec_helper"

RSpec.describe ActionFactory::Registry do
  let(:factory_name) { :user }
  let(:model_name) { "CustomUser" }
  let(:default_factory_class_name) { "UserFactory" }
  let(:expected_factory_class_name) { "CustomUserFactory" }

  describe ".register" do
    subject(:register) { described_class.register(factory_name, model_name) }

    it "registers the factory class name for the given factory name" do
      expect { register }.to(
        change { described_class.factory_class_name(factory_name) }.from(
          default_factory_class_name
        ).to(
          expected_factory_class_name
        )
      )
    end
  end

  describe ".factories" do
    subject { described_class.factories }

    it { is_expected.to be_a(Hash) }

    it "returns a hash with default values" do
      expect(subject.default_proc).to be_a(Proc)
      expect(subject[:foo]).to eq("Foo")
    end
  end

  describe ".factory_class_name" do
    before do
      described_class.register(factory_name, model_name)
    end

    subject(:factory_class_name) { described_class.factory_class_name(factory_name) }

    it "returns the factory class name for the given factory name" do
      expect(factory_class_name).to eq(expected_factory_class_name)
    end
  end
end

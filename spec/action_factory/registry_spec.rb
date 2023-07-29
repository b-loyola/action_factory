require "spec_helper"

RSpec.describe ActionFactory::Registry do
  let(:factory_name) { :user }
  let(:default_class_name) { "User" }
  let(:custom_class_name) { "CustomUser" }
  let(:default_factory_class_name) { "UserFactory" }
  let(:custom_factory_class_name) { "SomeCustomUserFactory" }

  after do
    described_class.clear
  end

  describe ".register" do
    subject(:register) do
      described_class.register(
        factory_class_name: custom_factory_class_name,
        factory_name: factory_name,
        class_name: custom_class_name
      )
    end

    it "registers the factory class name for the given factory name" do
      expect { register }.to(
        change { described_class.factory_class_name_for(factory_name) }.from(
          default_factory_class_name
        ).to(
          custom_factory_class_name
        )
      )
    end
  end

  describe ".factory_class_name_for" do
    subject(:factory_class_name_for) { described_class.factory_class_name_for(name) }

    context "when the name is registered" do
      before do
        described_class.register(
          factory_class_name: custom_factory_class_name,
          factory_name: factory_name,
          class_name: custom_class_name
        )
      end

      context "when the name is a symbol" do
        let(:name) { factory_name }

        it { is_expected.to eq(custom_factory_class_name) }
      end

      context "when the name is a string" do
        let(:name) { custom_class_name }

        it { is_expected.to eq(custom_factory_class_name) }
      end

      context "when the name is a class" do
        let(:name) { custom_class_name.constantize }

        before do
          stub_const(custom_class_name, Class.new)
        end

        it { is_expected.to eq(custom_factory_class_name) }
      end
    end

    context "when the name is not registered" do
      context "when the name is a symbol" do
        let(:name) { factory_name }

        it { is_expected.to eq(default_factory_class_name) }
      end

      context "when the name is a string" do
        let(:name) { default_class_name }

        it { is_expected.to eq(default_factory_class_name) }
      end

      context "when the name is a class" do
        let(:name) { default_class_name.constantize }

        before do
          stub_const(default_class_name, Class.new)
        end

        it { is_expected.to eq(default_factory_class_name) }
      end
    end
  end

  describe ".class_name_for" do
    subject(:class_name_for) { described_class.class_name_for(name) }

    context "when the name is registered" do
      before do
        described_class.register(
          factory_class_name: custom_factory_class_name,
          factory_name: factory_name,
          class_name: custom_class_name
        )
      end

      context "when the name is a symbol" do
        let(:name) { factory_name }

        it { is_expected.to eq(custom_class_name) }
      end

      context "when the name is a string" do
        let(:name) { custom_factory_class_name }

        it { is_expected.to eq(custom_class_name) }
      end

      context "when the name is a class" do
        let(:name) { custom_factory_class_name.constantize }

        before do
          stub_const(custom_factory_class_name, Class.new)
        end

        it { is_expected.to eq(custom_class_name) }
      end
    end

    context "when the name is not registered" do
      context "when the name is a symbol" do
        let(:name) { factory_name }

        it { is_expected.to eq(default_class_name) }
      end

      context "when the name is a string" do
        let(:name) { default_factory_class_name }

        it { is_expected.to eq(default_class_name) }
      end

      context "when the name is a class" do
        let(:name) { default_factory_class_name.constantize }

        before do
          stub_const(default_factory_class_name, Class.new)
        end

        it { is_expected.to eq(default_class_name) }
      end
    end
  end
end

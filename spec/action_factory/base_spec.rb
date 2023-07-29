require "spec_helper"
require "ostruct"

RSpec.describe ActionFactory::Base do
  let(:factory_class_name) { "FooFactory" }
  let(:class_name) { "Foo" }
  let(:factory_class) { Class.new(described_class) }
  let(:factory_instance) { factory_class.new(*traits, **attributes) }
  let(:traits) { [] }
  let(:attributes) { {} }
  let(:factory_class_with_attributes) do
    Class.new(described_class) do
      attribute(:foo) { "foo" }
      sequence(:bar) { |i| "bar-#{i}" }
      trait(:baz) { self.baz = "baz" }
    end
  end

  before do
    stub_const(factory_class_name, factory_class)
  end

  after do
    ActionFactory::Registry.clear
  end

  describe ".register" do
    context "when no arguments are provided" do
      it "raises an error" do
        expect { factory_class.register }.to raise_error(ArgumentError)
      end
    end

    context "when factory_name is provided" do
      let(:factory_name) { :foobar }

      it "registers the factory" do
        expect { factory_class.register(factory_name: :foobar) }.to(
          change { ActionFactory::Registry.factory_class_name_for(factory_name) }.from("FoobarFactory").to(factory_class_name)
        )
      end
    end

    context "when class_name is provided" do
      let(:class_name) { "BarFoo" }

      it "registers the factory" do
        expect { factory_class.register(class_name: class_name) }.to change {
          ActionFactory::Registry.factory_class_name_for(class_name)
        }.from("BarFooFactory").to(factory_class_name)
      end
    end

    context "when factory_name and class_name are provided" do
      let(:factory_name) { :baz }
      let(:class_name) { "Bar" }
      it "registers the factory" do
        expect { factory_class.register(factory_name: :baz, class_name: "Bar") }.to(
          change { ActionFactory::Registry.factory_class_name_for(factory_name) }.from("BazFactory").to(factory_class_name).and(
            change { ActionFactory::Registry.factory_class_name_for(class_name) }.from("BarFactory").to(factory_class_name)
          )
        )
      end
    end
  end

  describe ".klass" do
    context "when the model class does not exist" do
      it "raises an error" do
        expect { factory_class.klass }.to raise_error(ActionFactory::Base::ClassNotFound)
      end
    end

    context "when the model class exists" do
      let(:klass) { Class.new }

      before do
        stub_const(class_name, klass)
      end

      it "returns the class" do
        expect(factory_class.klass).to eq(klass)
      end
    end
  end

  describe ".to_initialize" do
    context "when no block is provided" do
      it "raises an error" do
        expect { factory_class.to_initialize }.to raise_error(ArgumentError)
      end
    end

    context "when a block is provided" do
      it "sets the initializer" do
        proc = Proc.new { }
        factory_class.to_initialize(&proc)
        expect(factory_class.initializer).to eq(proc)
      end
    end
  end

  describe ".to_create" do
    context "when no block is provided" do
      it "raises an error" do
        expect { factory_class.to_create }.to raise_error(ArgumentError)
      end
    end

    context "when a block is provided" do
      it "sets the creator" do
        proc = Proc.new { }
        factory_class.to_create(&proc)
        expect(factory_class.creator).to eq(proc)
      end
    end
  end

  describe ".attribute" do
    subject(:attribute_assignment) { factory_class.attribute(name, &block) }
    let(:name) { :foo }
    let(:block) { Proc.new { "They're taking the hobbits to Isengard!" } }

    it "adds the attribute to the assignments" do
      expect { attribute_assignment }.to(
        change { factory_class.assignments[:attributes] }.from({}).to(
          { name => ActionFactory::Assignments::Attribute.new(block) }
        )
      )
    end
  end

  describe ".sequence" do
    subject(:sequence_assignment) { factory_class.sequence(name, &block) }
    let(:name) { :bar }
    let(:block) { Proc.new { "Tis but a scratch" } }

    it "adds the sequence to the assignments" do
      expect { sequence_assignment }.to(
        change { factory_class.assignments[:attributes] }.from({}).to(
          { name => ActionFactory::Assignments::Sequence.new(block) }
        )
      )
    end
  end

  describe ".trait" do
    subject(:trait_assignment) { factory_class.trait(name, &block) }
    let(:name) { :baz }
    let(:block) { Proc.new { "I'm not dead yet!" } }

    it "adds the trait to the assignments" do
      expect { trait_assignment }.to(
        change { factory_class.assignments[:traits] }.from({}).to(
          { name => ActionFactory::Assignments::Trait.new(block) }
        )
      )
    end
  end

  describe ".assignments" do
    subject(:assignments) { factory_class.assignments }

    context "when no assignments have been made" do
      it { is_expected.to eq({}) }

      it "returns a hash with default proc" do
        expect(assignments[:foo]).to be_a(ActiveSupport::HashWithIndifferentAccess)
      end
    end

    context "when assignments have been made" do
      let!(:attribute_assignment) { factory_class.attribute(:foo) { } }
      let!(:sequence_assignment) { factory_class.sequence(:bar) { } }
      let!(:trait_assignment) { factory_class.trait(:baz) { } }

      it "returns the assignments" do
        expect(assignments).to eq(
          "attributes" => {
            "foo" => attribute_assignment,
            "bar" => sequence_assignment
          },
          "traits" => {
            "baz" => trait_assignment
          }
        )
      end
    end

    context "when assignments have been made in a parent class" do
      let(:parent_factory_class) do
        Class.new(described_class) do
          attribute(:foo) { "foo" }
          sequence(:bar) { "bar" }
          trait(:baz) { "baz" }
        end
      end

      let(:factory_class) do
        Class.new(parent_factory_class) do
          attribute(:qux) { "qux" }
          sequence(:bar) { "other bar" }
        end
      end

      it "returns the expected assignments" do
        expect(factory_class.assignments).to eq(
          "attributes" => {
            "foo" => parent_factory_class.assignments[:attributes][:foo],
            "bar" => factory_class.assignments[:attributes][:bar],
            "qux" => factory_class.assignments[:attributes][:qux]
          },
          "traits" => {
            "baz" => parent_factory_class.assignments[:traits][:baz]
          }
        )
      end
    end
  end

  describe "#initialize" do
    context "when the class is ActionFactory::Base" do
      it "raises an error" do
        expect { described_class.new }.to raise_error("cannot initialize base class")
      end
    end

    context "when the class is not ActionFactory::Base" do
      it "does not raise an error" do
        expect { factory_class.new }.not_to raise_error
      end
    end
  end

  describe "#run" do
    context "when strategy is build" do
      let(:strategy) { :build }

      it "calls build" do
        expect(factory_instance).to receive(:build)
        factory_instance.run(strategy)
      end
    end

    context "when strategy is create" do
      let(:strategy) { :create }

      it "calls create" do
        expect(factory_instance).to receive(:create)
        factory_instance.run(strategy)
      end
    end
  end

  describe "#build" do
    subject(:build) { factory_instance.build }
    let(:model_class) { Class.new(OpenStruct) }

    before do
      stub_const(class_name, model_class)
    end

    it "returns the instance" do
      expect(build).to be_an_instance_of(model_class)
    end

    context "when the initializer is defined" do
      let(:initializer) { Proc.new { } }
      let(:built_instance) { instance_double(model_class) }

      before do
        factory_class.to_initialize(&initializer)
      end

      it "calls the initializer" do
        expect(model_class).to receive(:class_exec).with(factory_instance, &initializer).and_return(built_instance)
        expect(build).to eq(built_instance)
      end
    end
  end
end

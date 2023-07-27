require "spec_helper"

RSpec.describe ActionFactory::AssignmentCompiler do
  let(:factory) { double }

  subject(:compiler) { described_class.new(factory) }

  describe "#compile" do
    let(:name_attribute_assignment) { instance_double(ActionFactory::Assignments::Attribute) }
    let(:uid_sequence_assignment) { instance_double(ActionFactory::Assignments::Sequence) }
    let(:unique_trait_assignment) { instance_double(ActionFactory::Assignments::Sequence) }
    let(:assignments) do
      {
        name: name_attribute_assignment,
        uid: uid_sequence_assignment,
        unique: unique_trait_assignment
      }
    end
    let(:name) { "John" }
    let(:uid) { "123" }
    let(:unique) { "unique" }

    let(:expected_attributes) do
      {
        name: name,
        uid: uid,
        unique: unique
      }
    end

    it "compiles the assignments" do
      assignments.each do |key, assignment|
        expect(assignment).to receive(:compile).with(factory).and_return(send(key))
      end
      expect(compiler.compile(assignments)).to eq(expected_attributes)
    end

    context "when 'only' is given" do
      let(:only) { [:name] }

      it "compiles only the given assignments" do
        expect(name_attribute_assignment).to receive(:compile).with(factory).and_return(name)
        expect(compiler.compile(assignments, only: only)).to eq(name: name)
      end
    end

    context "when 'except' is given" do
      let(:except) { [:name] }

      it "compiles all except the given assignments" do
        expect(uid_sequence_assignment).to receive(:compile).with(factory).and_return(uid)
        expect(unique_trait_assignment).to receive(:compile).with(factory).and_return(unique)
        expect(compiler.compile(assignments, except: except)).to eq(uid: uid, unique: unique)
      end
    end

    context "when both 'only' and 'except' are given" do
      let(:only) { [:name] }
      let(:except) { [:uid] }

      it "raises an ArgumentError" do
        expect { compiler.compile(assignments, only: only, except: except) }.to raise_error(ArgumentError)
      end
    end
  end
end

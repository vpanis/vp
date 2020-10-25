require 'spec_helper'

RSpec.describe SolidusPaypalCommercePlatform::Configuration do
  let(:subject) { described_class.new }

  describe '#default_env' do
    it "uses ENV['PAYPAL_ENV'] when present" do
      expect(ENV).to receive(:[]).with("PAYPAL_ENV").and_return("foo").at_least(:once)
      expect(subject.default_env).to eq("foo")
    end

    it "falls back to Rails.env if ENV['PAYPAL_ENV'] is not set" do
      expect(ENV).to receive(:[]).with("PAYPAL_ENV").and_return(nil).at_least(:once)

      expect(Rails).to receive(:env).and_return("development".inquiry)
      expect(subject.default_env).to eq("sandbox")

      expect(Rails).to receive(:env).and_return("test".inquiry)
      expect(subject.default_env).to eq("sandbox")

      expect(Rails).to receive(:env).and_return("production".inquiry)
      expect(subject.default_env).to eq("live")

      expect(Rails).to receive(:env).and_return("staging".inquiry)
      expect{ subject.default_env }.to raise_error(described_class::InvalidEnvironment)
    end
  end

  describe '#env' do
    it 'returns a string inquirer' do
      expect(subject.env).to eq("sandbox")
      expect(subject.env).to be_sandbox

      subject.env = "live"
      expect(subject.env).to eq("live")
      expect(subject.env).to be_live

      subject.env = "sandbox"
      expect(subject.env).to eq("sandbox")
      expect(subject.env).to be_sandbox
    end

    it 'raises an error when assigned an unsupported value' do
      expect{ subject.env = "foo" }.to raise_error(described_class::InvalidEnvironment)
    end
  end

  describe '#env_class' do
    it 'changes based on the current env' do
      subject.env = "live"
      expect(subject.env_class).to eq(PayPal::LiveEnvironment)

      subject.env = "sandbox"
      expect(subject.env_class).to eq(PayPal::SandboxEnvironment)
    end
  end

  describe '#env_domain' do
    it 'changes based on the current env' do
      subject.env = "live"
      expect(subject.env_domain).to eq("www.paypal.com")

      subject.env = "sandbox"
      expect(subject.env_domain).to eq("www.sandbox.paypal.com")
    end
  end

  describe "#state_guesser_class" do
    before do
      stub_const('SolidusPaypalCommercePlatform::BetterStateGuesser', Class.new)
    end

    it "returns a class" do
      expect(subject.state_guesser_class).to be_kind_of(Class)
    end

    it "is settable" do
      expect(subject.state_guesser_class).to eq(SolidusPaypalCommercePlatform::StateGuesser)

      subject.state_guesser_class = "SolidusPaypalCommercePlatform::BetterStateGuesser"

      expect(subject.state_guesser_class).to eq(SolidusPaypalCommercePlatform::BetterStateGuesser)
    end
  end

  describe "#partner_code" do
    it "returns the correct code" do
      expect(subject.partner_code).to eq("Solidus_PCP_SP")
    end
  end
end

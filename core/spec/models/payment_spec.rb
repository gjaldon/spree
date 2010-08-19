require 'spec_helper'

describe Payment do

  let(:order) { mock_model(Order, :update! => nil) }
  # let(:payment) { Payment.new }
  before(:each) do
    @payment = Payment.new(:order => order)
    @payment.source = mock_model(Creditcard, :save => true, :payment_gateway => nil, :process => nil)
    @payment.stub!(:valid?).and_return(true)
    @payment.stub!(:check_payments).and_return(nil)
  end

  context "#process!" do

    context "when state is checkout" do
      before(:each) do
        @payment.source.stub!(:process!).and_return(nil)
      end
      it "should process the source" do
        @payment.source.should_receive(:process!)
        @payment.process!
      end
      it "should make the state 'processing'" do
        @payment.process!
        @payment.should be_processing
      end
    end

    context "when already processing" do
      before(:each) { @payment.state = 'processing' }
      it "should return nil without trying to process the source" do
        @payment.source.should_not_receive(:process!)
        @payment.process!.should == nil
      end
    end

  end

  context "#credit_allowed" do
    it "is the difference between offsets total and payment amount"
  end

  context "#can_credit?" do
    it "is true if credit_allowed > 0"
  end

  context "#credit" do
    context "when amount <= credit_allowed" do
      it "makes the state processing"
      it "calls credit on the source with the amount"
    end
    context "when amount > credit_allowed" do
      it "should not call credit on the source"
    end
  end

  context "#save" do
    it "should call order#update!" do
      payment = Payment.create(:amount => 100, :order => order)
      order.should_receive(:update!)
      payment.save
    end
  end

end

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EmailSubscriptionsController do
  describe "GETting new" do
    it "should assign the last_view variable" do
      get :new, :last_view => 'map'
      assigns[:last_view].should == 'map'
    end

    it "should render the new template" do
      get :new
      response.should render_template('email_subscriptions/new')
    end
  end

  describe "POSTing create" do
    before(:each) do
      @email_subscription = mock_model(EmailSubscription, :save => true, :filter= => nil, :email => "example@example.com")
      EmailSubscription.stub!(:new).and_return(@email_subscription)
    end

    it "should create a new email subscription" do
      EmailSubscription.should_receive(:new).with('email' => "example@example.com").and_return(@email_subscription)
      @email_subscription.should_receive(:filter=).with({'theme' => "Food and Cookery", 'location' => "NR28 9JH"})
      @email_subscription.should_receive(:save).and_return(true)
      post_create
    end

    it "should set a notice flash" do
      post_create
      flash[:notice].should_not be_blank
    end

    it "should redirect back to the map view" do
      post_create
      response.should redirect_to("/events/2009/October?filter%5Blocation%5D=NR28+9JH&filter%5Btheme%5D=Food+and+Cookery&view=map")
    end

    def post_create
      post :create,
        'email_subscription' => {'email' => "example@example.com"},
        'filter' => {'theme' => "Food and Cookery", 'location' => "NR28 9JH"},
        'last_view' => 'map'
    end
  end
end

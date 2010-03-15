require File.dirname(__FILE__) + '/../../spec_helper'

describe "events/_event_search_filter" do
  before(:each) do
    @filter = {
      :location => '',
      :theme => 'Food and Cookery'
    }
    @params = {
      :filter => @filter,
      :controller => 'events',
      :action => 'index',
      :year => '2009',
      :month => 'October'
    }

    template.stub!(:params).and_return(@params)
  end

  describe "on a calendar page" do
    before(:each) do
      @params[:view] = 'calendar'
      assigns[:events] = [mock_model(Event)]
    end

    it "should show a link to send an email of these events" do
      render 'events/_event_search_filter'
      response.should have_tag("a[href=/email_subscriptions/new?filter%5Blocation%5D=&amp;filter%5Btheme%5D=Food+and+Cookery]")
    end
  end

  describe "on a map page" do
    before(:each) do
      @params[:view] = 'map'
      assigns[:venues] = [mock_model(Venue)]
    end

    it "should show a link to send an email of these events" do
      render 'events/_event_search_filter'
      response.should have_tag("a[href=/email_subscriptions/new?filter%5Blocation%5D=&amp;filter%5Btheme%5D=Food+and+Cookery]")
    end
  end
end

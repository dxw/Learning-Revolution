require File.dirname(__FILE__) + '/../../spec_helper'

describe "email_subscriptions/new" do
  before(:each) do
    @filter = {
      :location => '',
      :theme => 'Food and Cookery'
    }
    @params = {
      :filter => @filter
    }
    template.stub!(:params).and_return(@params)
    assigns[:last_view] = 'map'
  end

  it "should display a form to create a new email subscription" do
    render 'email_subscriptions/new'
    response.should have_tag("form[method=post][action=/email_subscriptions?filter%5Blocation%5D=&amp;filter%5Btheme%5D=Food+and+Cookery&amp;last_view=map]") do
      with_tag("input[name='email_subscription[email]']")
      with_tag("input[type=submit]")
    end
  end

  it "should have a link back to the previous map page" do
    render 'email_subscriptions/new'
    response.should have_tag('a[href=/events/2009/October?filter%5Blocation%5D=&amp;filter%5Btheme%5D=Food+and+Cookery&amp;view=map]')
  end
end

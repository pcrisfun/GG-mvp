require 'spec_helper'

describe "portfolios/edit" do
  before(:each) do
    @portfolio = assign(:portfolio, stub_model(Portfolio,
      :name => "MyString"
    ))
  end

  it "renders the edit portfolio form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => portfolios_path(@portfolio), :method => "post" do
      assert_select "input#portfolio_name", :name => "portfolio[name]"
    end
  end
end

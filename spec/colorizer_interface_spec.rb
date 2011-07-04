describe "Colorizer interface" do
  before(:each) { Wirb.colorizer = @colorizer = double() }

  it "invokes Colorizer.color to get color codes" do
    @colorizer.should_receive(:color).with(:c3po)
    wirb = Wirb.get_color(:c3po)
  end

  it "invokes Colorizer.run to colorize strings" do
    @colorizer.should_receive(:run).with('chewbacca', 'r2d2')
    wirb = Wirb.colorize_string('chewbacca', 'r2d2')
  end
  
  after(:each) {Wirb.colorizer = nil}
end

describe "Colorizer loading" do
  before(:each) {Wirb.colorizer = nil}
  
  it "defaults to using the Wirb0 colorizer" do
    Wirb.colorizer = nil
    Wirb.instance_variable_get(:@colorizer).should be_nil
    foo = Wirb.colorizer # Force a colorizer to be loaded
    Wirb.colorizer.should == Wirb::Colorizer::Wirb0
  end

  it "attempts to load the appropriate colorizer" do
    Wirb.colorizer = nil
    Wirb.instance_variable_get(:@colorizer).should be_nil
    Wirb::Colorizer.should_receive(:require).
      with(File.dirname(File.dirname(__FILE__)) + '/lib/wirb/colorizer/notloaded').
      and_return(true)
    expect {
      Wirb.colorizer = Wirb::Colorizer::NotLoaded
    }.to raise_error(LoadError) # Because the Colorizer doesn't actually exist, wasn't loaded
                                # and didn't define Wirb::Colorizer::NotLoaded
  end
  
  it "fails if the colorizer is not found" do
    expect {
      Wirb.colorizer = Wirb::Colorizer::DoesntExist
    }.to raise_error(LoadError)
  end
  
  it "fails if the colorizer definition doesn't define the colorizer class" do
    Wirb::Colorizer.should_receive(:require).
      with(File.dirname(File.dirname(__FILE__)) + '/lib/wirb/colorizer/badcolorizer').
      and_return(true)
    expect {
      Wirb.colorizer = Wirb::Colorizer::BadColorizer
    }.to raise_error(LoadError)
  end
  
  it "sets the Colorizer object" do
    Wirb.colorizer = nil
    Wirb.instance_variable_get(:@colorizer).should be_nil
    Wirb.colorizer = Wirb::Colorizer::Wirble
    Wirb::Colorizer.const_defined?(:Wirble).should be_true
    Wirb.colorizer.should == Wirb::Colorizer::Wirble
  end
  
  it "doesn't load Colorizers until they are referenced" do
    # Can't figure out how to test for this, actually
  end
  
  after(:each) {Wirb.colorizer = nil}
end

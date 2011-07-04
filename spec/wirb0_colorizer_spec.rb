describe Wirb::Colorizer::Wirb0 do
  before :each do
    Wirb.colorizer = Wirb::Colorizer::Wirb0
  end
  
  it_behaves_like "a Wirb0 colorizer"
  
  after :each do
    Wirb.colorizer = nil
  end
end
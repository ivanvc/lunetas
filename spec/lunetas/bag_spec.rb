require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Lunetas::Bag do

  describe "register" do
    before(:each) do
      @luneta_class, @luneta_object = mock_candy
    end

    it 'should register a new class' do
      Lunetas::Bag.register(/test/, @luneta_class)
      @luneta_object.should_receive(:bite)
      Lunetas::Bag.call(mock_env('/test'))
    end
  end

  describe "call" do
    before(:each) do
      @luneta_class, @luneta_object = mock_candy
    end

    it 'should return a 404 if no matching path' do
      Lunetas::Bag.call(mock_env('/123')).first.should == 404
    end

    it 'should return the bite of the called' do
      Lunetas::Bag.register(/chunky/, @luneta_class)
      @luneta_class.should_receive(:new).and_return(@luneta_object)
      @luneta_object.should_receive(:bite).once
      Lunetas::Bag.call(mock_env('/chunky')).first.should == 200
    end

    it 'should pass the matched regex and matches' do
      Lunetas::Bag.register(/bacon\/(bbacon)/, @luneta_class)
      env = mock_env('/bacon/bbacon')
      @luneta_class.should_receive(:new).with(env, ['bacon/bbacon', 'bbacon'])
      Lunetas::Bag.call(env)
    end

    it 'should serve an external file' do
      Lunetas::Bag.set_public_directory "spec/support"
      env = mock_env('/image.png')
      response = [200, {"Content-Type" => "image/png"}, ["test\n"]]
      Lunetas::Bag.call(env).should == response
    end
  end

  describe 'set_public_directory' do
    it 'should raise an exception if the directory is not found' do
      lambda {
        Lunetas::Bag.set_public_directory "blah"
      }.should raise_error
    end

    it 'should change the value if the directory is found' do
      lambda {
        Lunetas::Bag.set_public_directory "examples"
      }.should change(Lunetas::Bag, :public_directory)
    end
  end
end

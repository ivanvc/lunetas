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
  end
end

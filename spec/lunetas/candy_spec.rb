require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Lunetas::Candy::InstanceMethods do
  describe '.initialize' do
    before(:each) do
      @instance = TestClass.new(mock_env('/just_a_test'), ['/just_a_test', 'a', 'b'])
    end

    it 'should set the url variable' do
      @instance.url.should == '/just_a_test'
    end

    it 'should set the url params' do
      @instance.url_param(0).should == 'a'
      @instance.url_param(1).should == 'b'
    end
  end

  describe '.url_param' do
    it 'should be accasible through its index' do
      instance = TestClass.new(mock_env('/just_a_test'), ['/just_a_test', 'a'])
      instance.url_param(0).should == 'a'
    end

    it 'should have none if no matches' do
      instance = TestClass.new(mock_env('/just_a_test'), ['/just_a_test'])
      instance.url_param(0).should be_nil
    end
  end

  describe '.bite' do
    before(:each) do
      @instance = TestClass.new(mock_env('/just_a_test'), ['/just_a_test', 'a'])
    end

    it 'should call the before method' do
      @instance.should_receive(:before).once
      @instance.bite
    end
    
    it 'should call to the response' do
      @instance.should_receive(:response).once.and_return('')
      @instance.bite
    end

    it 'should answer with the raised error' do
      test_exception = TestException.new
      @instance.should_receive(:before).and_raise(test_exception)
      @instance.should_receive(:response).with(test_exception, 400)
      @instance.bite
    end

    it 'should answer with a 500 if raised a runtime error' do
      @instance.should_receive(:before).and_raise(StandardError)
      @instance.bite.first.should == 500
    end

    it 'should call to the get method' do
      @instance.should_receive(:get)
      @instance.bite
    end

    it 'should render the given response' do
      @instance.bite.last.should == ['Chunky Bacon']
    end

    it 'should have the default ContentType if not set' do
      @instance.bite[1]["Content-Type"].should == "text/html"
    end

    it 'should set another ContentType' do
      TestClass.send(:set_content_type, 'text/plain')
      @instance.bite[1]["Content-Type"].should == "text/plain"
    end

    %w{post put delete head trace options}.each do |verb|
      it 'should call to the #{verb} method if called with #{verb.upcase}' do
        mock_env = mock_env('/just_a_test')
        mock_env['REQUEST_METHOD'] = verb.upcase
        @instance = TestClass.new(mock_env, ['/just_a_test'])
        @instance.should_receive(verb)
        @instance.bite
      end

      it 'should return an API Error to #{verb.upcase} if no defined' do
        mock_env = mock_env('/just_a_test')
        mock_env['REQUEST_METHOD'] = verb.upcase
        @instance = TestClass.new(mock_env, ['/just_a_test'])
        @instance.should_receive(verb).and_raise(Lunetas::Error::APIError)
        @instance.bite.last.should == ["API route error"]
      end
    end

    it 'should call to other_verb with the passed method' do
      mock_env = mock_env('/just_a_test')
      mock_env['REQUEST_METHOD'] = 'TEAPOT'
      @instance = TestClass.new(mock_env, ['/just_a_test'])
      @instance.should_receive(:other_verb).with('TEAPOT')
      @instance.bite
    end

    it 'should call to other_verb with the passed method and return the response if method handled' do
      mock_env = mock_env('/just_a_test')
      mock_env['REQUEST_METHOD'] = 'TEAPOT'
      @instance = TestClass.new(mock_env, ['/just_a_test'])
      @instance.should_receive(:other_verb).with('TEAPOT').and_return('TEAPOT YEAH')
      @instance.bite.last.should == ['TEAPOT YEAH']
    end

    it 'should call to other_verb with the passed method and return error if method not handled' do
      mock_env = mock_env('/just_a_test')
      mock_env['REQUEST_METHOD'] = 'TEAPOT'
      @instance = TestClass.new(mock_env, ['/just_a_test'])
      @instance.should_receive(:other_verb).with('TEAPOT')
      @instance.bite.last.should == ['API route error']
    end
    
  end

end

require 'helper'
require 'rr'

class WebpostOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
    RR.reset
  end

  CONFIG = %[
  ]

  def create_driver(conf = CONFIG, tag = 'test.test')
    Fluent::Test::BufferedOutputTestDriver.new(Fluent::WebpostOutput, tag).configure(conf)
  end

  def test_configure_with_params
    d = create_driver %[
        post_url http://example.com
        user_agent fugafuga
    ]
    d.run
    assert_equal 'http://example.com' , d.instance.instance_variable_get(:@post_url).to_s
    assert_equal 'fugafuga' , d.instance.instance_variable_get(:@user_agent).to_s
  end

  def test_configure_with_out
    assert_raise(Fluent::ConfigError) do
        d = create_driver %[
        ]
        d.run
    end
  end

  def test_configure_with_empty_url
    assert_raise(Fluent::ConfigError) do
        d = create_driver %[
            post_url
        ]
        d.run
    end
  end

  def test_configure_without_ua
    d = create_driver %[
        post_url http://example.com
    ]
    d.run
    assert_equal 'ruby/webpost' , d.instance.instance_variable_get(:@user_agent).to_s
  end

  def test_run
    d = create_driver %[
        post_url http://example.com/
    ]

    http = Object.new
    require 'json'
    mock(http).post.with_any_args do |*args|
        assert_equal "/", args[0]
        a = JSON.parse args[1]

        assert_equal Array, a.class
        assert_equal "world", a[0]["hello"]
        assert_equal({"user-agent" => "ruby/webpost"}, args[2])

        res = Object.new
        mock(res).code { 200 }
        res
    end

    mock(Net::HTTP).start("example.com",80).yields(http)

    time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    d.emit({"hello" => "world"})
    d.run
  end

  def test_run_2
    d = create_driver %[
        post_url http://example.com/hello.post
        user_agent hello agent
    ]

    http = Object.new
    require 'json'
    mock(http).post.once.with_any_args do |*args|
        assert_equal "/hello.post", args[0]
        a = JSON.parse args[1]

        assert_equal Array, a.class
        assert_equal "world", a[0]["hello"]
        assert_equal({"user-agent" => "hello agent"}, args[2])

        res = Object.new
        mock(res).code { 200 }
        res
    end

    mock(Net::HTTP).start("example.com",80).yields(http)

    time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    d.emit({"hello" => "world"})
    d.run
  end
end


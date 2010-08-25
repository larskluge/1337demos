$LOAD_PATH << File.dirname(__FILE__) + '/..'
require "test_helper"

class DemoTest < ActiveSupport::TestCase
  context "Demo" do
    setup do
      @map = Map.create!(:name => 'foo')
      @player = Player.create!(:main_nickname_id => 1)

      @demo_attributes = {
        :data_correct => true,
        :demofile_id => 1,
        :game => "Warsow",
        :gamemode => 'race',
        :map => @map,
        :players => [@player],
        :status => :uploaded,
        :time => 24966,
        :title => nil,
        :version => 10
      }
    end

    should "calc position right" do
      @d1 = Demo.create!(@demo_attributes)
      @d1.reload
      assert_equal 1, @d1.position
    end

    should "calc position right, create order: 1st, 2nd" do
      @d1 = Demo.create!(@demo_attributes)
      @d1.reload
      assert_equal 1, @d1.position
      assert_equal @player, @d1.players.first

      @p2 = Player.create!(:main_nickname_id => 2)
      @d2 = Demo.create!(@demo_attributes.merge({
        :time => 29460,
        :players => [@p2]
      }))
      @d1.reload
      @d2.reload
      assert_equal 1, @d1.position
      assert_equal 2, @d2.position
    end

    should "calc position right, upload order: 2st, 1nd" do
      @d1 = Demo.create!(@demo_attributes.merge(:time => 20000))
      @d1.reload
      assert_equal 1, @d1.position

      @p2 = Player.create!(:main_nickname_id => 2)
      @d2 = Demo.create!(@demo_attributes.merge({
        :time => 15000,
        :players => [@p2]
      }))
      @d1.reload
      @d2.reload
      assert_equal 1, @d2.position
      assert_equal 2, @d1.position
    end

    should "set position of 1st uploaded demo to nil when improved by same player" do
      @d1 = Demo.create!(@demo_attributes.merge(:time => 20000))
      @d1.reload
      assert_equal 1, @d1.position

      @d2 = Demo.create!(@demo_attributes.merge(:time => 15000))
      @d1.reload
      @d2.reload
      assert_nil @d1.position
      assert_equal 1, @d2.position
    end
  end
end


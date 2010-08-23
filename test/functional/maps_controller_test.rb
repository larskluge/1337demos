require File.dirname(__FILE__) + '/../test_helper'

class MapsControllerTest < ActionController::TestCase

  def assert_valid_thumb_for(map)
    get :thumb, :id => map.id, :size => "200x150"
    assert_response :success
    assert_equal @response.content_type, 'image/jpeg'

    assert(@response.body.is_a? Proc)

    output = StringIO.new
    output.binmode
    assert_nothing_raised do
      @response.body.call(@response, output)
    end

    img = Magick::Image.from_blob(output.string).first
    assert_equal "JPEG", img.format
    assert_equal 200, img.columns
    assert_equal 150, img.rows
  end


  test "#thumbs: generate thumbnail for missing levelshot" do
    assert_valid_thumb_for(Map.create!(:name => "missing"))
  end

  test "#thumbs: generate thumbnail for map with levelshot" do
    assert_valid_thumb_for(Map.create!(:name => "#pgrun"))
  end

  test "#thumbs: ask for unavailable size" do
    get :thumb, :id => 1, :size => "1x1"
    assert_response :not_found
  end

end


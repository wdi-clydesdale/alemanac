class HomeController < ApplicationController

  get '/' do
    puts 'hello there'
    erb :index

  end


  post '/' do
    puts params
    @search_string = EntriesModel.new
    #puts @search_string
    @search_string = params[:search_string]
    puts 'Hey, this:' + @search_string
    @search_results = HTTParty.get('http://api.brewerydb.com/v2/beers?glasswareId=3', {:query => {:key => 'fdf1b28c011f27510720ab3070943f3e'} })

  # Load beers table
  #
    # beers = beers.new #create a new instance

    mydata = @search_results["data"][0]
    puts mydata

    temp =  @search_results["data"][0]["labels"]["medium"]
    puts temp.to_s
    temp =  @search_results["data"][4]["labels"]["medium"]
    puts temp.to_s
    temp =  @search_results["data"][7]["labels"]["medium"]
    puts temp.to_s
    # @search_results.save

    # puts @search_results["data"] # the data key contains all beer info and is an array
    # {"id"=>"AZI8ib", "name"=>"Indian Brown Ale", "nameDisplay"=>"Indian Brown Ale", "description"=>"Forget about the car companies, this is the original hybrid, a cross between a Scotch Ale, an India Pale Ale, and an American Brown. Our Indian Brown Ale is well-hopped and malty at the same time (magical). The beer has characteristics of each style that inspired it; the color of an American Brown, the caramel notes of a Scotch Ale, and the hopping regiment of an India Pale Ale. We dry-hop the Indian Brown Ale in a similar fashion as our 60 Minute IPA and 90 Minute IPAs. This beer is brewed with Aromatic barley and organic brown sugar.", "abv"=>"7.2", "ibu"=>"50", "glasswareId"=>5, "availableId"=>1, "styleId"=>37, "isOrganic"=>"N", "labels"=>{"icon"=>"https://s3.amazonaws.com/brewerydbapi/beer/AZI8ib/upload_1uf5Zr-icon.png", "medium"=>"https://s3.amazonaws.com/brewerydbapi/beer/AZI8ib/upload_1uf5Zr-medium.png", "large"=>"https://s3.amazonaws.com/brewerydbapi/beer/AZI8ib/upload_1uf5Zr-large.png"}, "status"=>"verified", "statusDisplay"=>"Verified", "foodPairings"=>"Balsamic vinaigrette salads, smoked meats, duck confit, braised ribs, venison, prosciutto, stews", "createDate"=>"2012-01-03 02:43:29", "updateDate"=>"2015-05-07 14:49:47", "glass"=>{"id"=>5, "name"=>"Pint", "createDate"=>"2012-01-03 02:41:33"}, "available"=>{"id"=>1, "name"=>"Year Round", "description"=>"Available year round as a staple beer."}, "style"=>{"id"=>37, "categoryId"=>3, "category"=>{"id"=>3, "name"=>"North American Origin Ales", "createDate"=>"2012-03-21 20:06:45"}, "name"=>"American-Style Brown Ale", "shortName"=>"American Brown", "description"=>"American brown ales range from deep copper to brown in color. Roasted malt caramel-like and chocolate-like characters should be of medium intensity in both flavor and aroma. American brown ales have evident low to medium hop flavor and aroma, medium to high hop bitterness, and a medium body. Estery and fruity-ester characters should be subdued. Diacetyl should not be perceived. Chill haze is allowable at cold temperatures.", "ibuMin"=>"25", "ibuMax"=>"45", "abvMin"=>"4", "abvMax"=>"6.4", "srmMin"=>"15", "srmMax"=>"26", "ogMin"=>"1.04", "fgMin"=>"1.01", "fgMax"=>"1.018", "createDate"=>"2012-03-21 20:06:46", "updateDate"=>"2015-04-07 15:27:35"}, "type"=>"beer"}

    erb :search_results
  end

end

module Helpers
  def generate_analytics(url_info)
    data = Hash.new(0)
    url_info.each do |view|
      data[Time.parse(view['data']['created_at']).strftime("%Y/%m/%d")]+=1
    end

    convert_data = []
    data.each do |d|
      convert_data << [DateTime.parse(d[0].to_s).to_time.to_i*1000, d[1]]
    end

    return convert_data
  end
end
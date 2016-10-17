require 'pxlsrt'
require 'pry'

def output(base_uri, input_name = nil, output_name = nil, options)
  if output_name.nil?
    settings = options.to_s.gsub(/[{}>,":]/, '{}>,"' => '', ':' => '_').gsub(/\s+/, '')
    out_file = File.new(base_uri + input_name + settings + '.txt', "w")
    out_file.puts(options.to_s)
    out_file.close
    return base_uri + input_name + settings + '.png'
  else
    settings = options.to_s.gsub(/[{}>,":]/, '{}>,"' => '', ':' => '_').gsub(/\s+/, '')
    out_file = File.new(base_uri + output_name + '.txt', "w")
    out_file.puts(options.to_s)
    out_file.close
   return base_uri + output_name + '.png'
 end
end

def file_name_with_settings(input_uri, options, output_name)
    base_uri = input_uri.dup
    input_name = File.basename(base_uri, '.png')
    length = input_name.length + 4
    uri_length = base_uri.length
    start = uri_length - length
    base_uri[start..uri_length] = ''
  if output_name.nil?
    return output(base_uri, input_name, nil, options)
  else
    return output(base_uri, nil,  output_name, options)
  end
end

def brute_sort_save_with_settings(input, options = {},output_name = nil)
defaults = {reverse: false, vertical: false, diagonal: false, 
            smooth: false, method: 'sum-rgb', verbose: false,
            min: Float::INFINITY, max: Float::INFINITY, 
            trusted: false, middle: false}
  options = defaults.merge(options)
    Pxlsrt::Brute.brute(input, reverse: options[:reverse], vertical: options[:vertical],
                        diagonal: options[:diagonal], smooth: options[:smooth], method: options[:method], 
                        verbose: options[:verbose], min: options[:min], max: options[:max],
                        trusted: options[:trusted], middle: options[:middle] ).save(file_name_with_settings(input, options, output_name))
end

def uri_helper(location, file_name)
  if location == 'desktop'
    "/Users/#{ENV['USER']}/desktop/" + file_name + '.png'
  elsif location == 'downloads'
    "/Users/#{ENV['USER']}/downloads/" + file_name + '.png'
  end
end

############# settings ############
sharp = {:verbose=>true, :vertical=>true, :min=>20, :max=>60, :method=>'uniqueness'}
soft = {:verbose=>true, :vertical=>true, :min=>100, :max=>300}
test1 = {:verbose=>true, :diagonal=>true, :min=>100, :max=>300}
test2 = {:verbose=>true, :vertical=>false, :min=>40, :middle=>-1}

########### base uris ###########
test = uri_helper('desktop', 'test')

########## running the wrapper ##########
brute_sort_save_with_settings(test, sharp, 'test_sharp')
brute_sort_save_with_settings(test, soft,'test_soft')

#Pxlsrt::Brute.brute("/Users/christiansamuel/desktop/test.png", :verbose=>true, :vertical=>true, :max=>80, :min=>10, :smooth=>true, :method=>'uniqueness', :middle=>1).save("/Users/christiansamuel/desktop/test.png")
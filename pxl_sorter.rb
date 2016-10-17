require 'pxlsrt'
require 'pry'

def output(base_uri, input_name = nil, output_name = nil, options)
  if output_name.nil?
    rando = '_' + (0...4).map{65.+(rand(26)).chr}.join.downcase
    out_file = File.new(base_uri + input_name + rando + '.txt', "w")
    out_file.puts(options.to_s)
    out_file.close
    return base_uri + input_name + rando + '.png'
  else
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
@sharp = {verbose: true, vertical: true, min:20, max: 60, method: 'uniqueness'}
@soft = {verbose: true, vertical: true, min: 100, max: 300}
@soft_diagonal = {verbose: true, diagonal: true, min: 100, max: 300}
@side_glitch = {verbose: true, vertical: false, min: 40, middle: -1}
@side_glitch_soft = {verbose: true, vertical: false, min: 100, max: 300, :middle=>-1}
@side_glitch_erratic = {verbose: true, vertical: false, min: 100, max: 300, :middle=>-4}
@vertical_glitch_soft = {verbose: true, vertical: true, min: 100, max: 300, :middle=>-1}
@soft_unique = {verbose: true, vertical: true, min: 100, max: 300, method: 'uniqueness'}
@side_soft_unique = {verbose: true, vertical: false, min: 100, max: 300, method: 'uniqueness'}
@side_soft_aggressive = {verbose: true, vertical: false, min: 100, max: 300, method: 'sum-hsb', smooth: true}
@side_soft_harsh = {verbose: true, vertical: false, min: 100, max: 300, method: 'hue', smooth: true}
@side_soft_sand = {verbose: true, vertical: false, min: 100, max: 300, method: 'random', smooth: true}
@side_soft_yellow = {verbose: true, vertical: false, min: 100, max: 300, method: 'yellow', smooth: true}
@soft_reverse = {verbose: true, vertical: true, min: 100, max: 300, reverse: true}

########### base uris ###########
test = uri_helper('desktop', 'test')
testing = uri_helper('downloads', 'testing')

########## running the wrapper ##########

def barrage(input, output_name)
  barrage_hash = { sharp: @sharp, soft: @soft, soft_diagonal: @soft_diagonal,
                   side_glitch: @side_glitch, side_glitch_soft: @side_glitch_soft,
                   side_glitch_erratic: @side_glitch_erratic, vertical_glitch_soft: @vertical_glitch_soft,
                   soft_unique: @soft_unique, side_soft_unique: @side_soft_unique,
                   side_soft_aggressive: @side_soft_aggressive, side_soft_harsh: @side_soft_harsh,
                   side_soft_sand: @side_soft_sand, side_soft_yellow: @side_soft_yellow,
                   soft_reverse: @soft_reverse }
  barrage_hash.each do |key, setting_hash|
    brute_sort_save_with_settings(input, setting_hash, (output_name + "_#{key}"))
  end
end

# barrage(testing, 'testing')

brute_sort_save_with_settings(test, @soft_reverse)

#Pxlsrt::Brute.brute("/Users/christiansamuel/desktop/test.png", :verbose=>true, :vertical=>true, :max=>80, 
#                                                               :min=>10, :smooth=>true, :method=>'uniqueness', 
#                                                               :middle=>1).save("/Users/christiansamuel/desktop/test.png")
require 'json'

def directory_hash(path, name=nil)
  data = {:name => (name || path)}

  Dir.foreach(path) do |entry|
    next if (entry == '..' || entry == '.')
    full_path = File.join(path, entry)

    if File.directory?(full_path)
      data[:dirs] = [] unless data[:dirs]
      data[:dirs] << directory_hash(full_path, entry)
    else
      data[:files] = [] unless data[:files]
      data[:files] << entry
    end
  end

  return data
end

run lambda { |env|
  [200, { 'Content-Type' => 'application/json' }, [ directory_hash('.').to_json ]]
}
